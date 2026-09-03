#!/usr/bin/env bash
# ============================================================
# deck.sh — the deck registry's only moving part.
#
#   deck.sh new <slug> [--theme notify-me-dark] [--kind investor]
#   deck.sh build <slug>      # PDF + cover thumbnail, from the HTML
#   deck.sh shots <slug>      # one PNG per slide, for a design review
#   deck.sh list
#   deck.sh serve             # http://127.0.0.1:8291 over the registry
#
# Every deck is a folder under ~/.openclaw/workspace/decks/ holding
# index.html, deck.css, deck.json and assets/. The built PDF and the
# thumbnail land beside them in dist/. Nothing here needs npm: the
# whole toolchain is chromium, which is already on the box.
# ============================================================
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DECKS="${DECKS_DIR:-$HERE/decks}"
KIT="$DECKS/_kit"
find_chrome() {
  local c
  for c in "${CHROME_BIN:-}" \
           "$HOME/.cache/ms-playwright"/chromium-*/chrome-linux/chrome \
           "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Chromium.app/Contents/MacOS/Chromium" \
           "$(command -v google-chrome || true)" \
           "$(command -v chromium || true)"; do
    [ -n "$c" ] && [ -x "$c" ] && { printf '%s' "$c"; return; }
  done
  # A snap chromium is deliberately last: it is confined, writes its output
  # into its own private /tmp, and reports success while producing no file.
  command -v chromium-browser 2>/dev/null || true
}
CHROME="$(find_chrome)"

die() { printf 'deck: %s\n' "$*" >&2; exit 1; }

need_chrome() {
  [ -n "$CHROME" ] || die "no chromium found. set CHROME_BIN."
}

# Chromium on a headless server needs these every single time. Kept in
# one place because forgetting --no-sandbox produces a crash whose
# message says nothing about sandboxes.
chrome_run() {
  "$CHROME" --headless --disable-gpu --no-sandbox --hide-scrollbars \
    --disable-dev-shm-usage --force-color-profile=srgb \
    --font-render-hinting=none "$@" 2>/dev/null
}

cmd_new() {
  local slug="${1:-}"; shift || true
  [ -n "$slug" ] || die "usage: deck.sh new <slug> [--theme X] [--kind Y] [--title 'T']"
  local dir="$DECKS/$slug"
  [ -e "$dir" ] && die "$dir already exists"

  local theme="notify-me-dark" kind="investor" title="$slug" subtitle="" presenter="Sam Eidi" kicker="Notify Me!"
  while [ $# -gt 0 ]; do
    case "$1" in
      --theme) theme="$2"; shift 2 ;;
      --kind) kind="$2"; shift 2 ;;
      --title) title="$2"; shift 2 ;;
      --subtitle) subtitle="$2"; shift 2 ;;
      --presenter) presenter="$2"; shift 2 ;;
      --kicker) kicker="$2"; shift 2 ;;
      *) die "unknown flag $1" ;;
    esac
  done
  [ -f "$KIT/css/themes/$theme.css" ] || die "no theme '$theme'. have: $(ls "$KIT/css/themes" | sed 's/.css//' | tr '\n' ' ')"

  cp -r "$KIT/template" "$dir"
  local date; date="$(date +%Y-%m-%d)"
  local footer; footer="$kicker · $date"

  # A deck is a text file until it is presented, so substitution is
  # sed rather than a template engine on purpose: one less thing that
  # can be broken by a dependency upgrade three months from now.
  for f in "$dir/index.html" "$dir/deck.json"; do
    sed -i \
      -e "s|{{TITLE}}|$title|g" \
      -e "s|{{SUBTITLE}}|$subtitle|g" \
      -e "s|{{THEME}}|$theme|g" \
      -e "s|{{KIND}}|$kind|g" \
      -e "s|{{AUDIENCE}}|$kind|g" \
      -e "s|{{DATE}}|$date|g" \
      -e "s|{{PRESENTER}}|$presenter|g" \
      -e "s|{{KICKER}}|$kicker|g" \
      -e "s|{{FOOTER}}|$footer|g" \
      "$f"
  done
  printf 'created %s\n  open  file://%s/index.html\n  build %s\n' "$dir" "$dir" "deck.sh build $slug"
}

cmd_build() {
  local slug="${1:-}"; [ -n "$slug" ] || die "usage: deck.sh build <slug>"
  local dir="$DECKS/$slug"
  [ -d "$dir" ] || die "no deck '$slug'"
  need_chrome
  mkdir -p "$dir/dist"

  # The PDF is assembled from one screenshot per slide rather than
  # from chromium's --print-to-pdf.
  #
  # Why: reveal.js 5 owns the print pipeline, and its paper stylesheet
  # unpins absolutely positioned slides. Measured here 2026-09-03, that
  # path produced a 1 KB two-page blank PDF, and claiming its
  # .print-pdf class to opt out produced a blank render on screen too.
  # Capturing the real frames costs a raster PDF (text is not
  # selectable, file lands around 3 MB for 12 slides) and buys an exact
  # match with what the room saw, including the aurora, the glass
  # surfaces and the settled count-ups. For a deck that is looked at
  # rather than parsed, that is the right side of the trade.
  cmd_shots "$slug" >/dev/null

  echo "assembling PDF..."
  python3 - "$dir" "$slug" <<'PY'
import glob, os, sys
from PIL import Image
d, slug = sys.argv[1], sys.argv[2]
frames = sorted(glob.glob(os.path.join(d, "dist", "shots", "*.png")))
if not frames:
    sys.exit("no frames captured")
pages = [Image.open(f).convert("RGB") for f in frames]
out = os.path.join(d, "dist", f"{slug}.pdf")
# 96 DPI keeps a 1920x1080 frame at 20 x 11.25 inches, which is what a
# 16:9 slide is meant to be. Quality 92 is the point where the glass
# edges stop showing JPEG ringing.
pages[0].save(out, save_all=True, append_images=pages[1:], resolution=96.0, quality=92)
pages[0].save(os.path.join(d, "dist", "cover.png"))
print(f"{len(pages)} pages -> {out}")
PY

  local pages
  pages="$(grep -c 'section class="slide' "$dir/index.html" || echo 0)"
  # Record what was built, so the Workbench listing never has to guess.
  python3 - "$dir/deck.json" "$pages" <<'PY'
import json, sys, datetime
path, pages = sys.argv[1], int(sys.argv[2])
try:
    meta = json.load(open(path))
except Exception:
    meta = {}
meta["slides"] = pages
meta["built"] = datetime.datetime.now().astimezone().isoformat(timespec="seconds")
json.dump(meta, open(path, "w"), indent=2)
open(path, "a").write("\n")
PY
  ls -la "$dir/dist"
}

cmd_shots() {
  local slug="${1:-}"; [ -n "$slug" ] || die "usage: deck.sh shots <slug>"
  local dir="$DECKS/$slug"
  [ -d "$dir" ] || die "no deck '$slug'"
  need_chrome
  mkdir -p "$dir/dist/shots"
  local n; n="$(grep -c 'section class="slide' "$dir/index.html")"
  # ?qa freezes motion and shows every fragment, so each frame is the
  # finished state of the slide rather than a random point in its
  # entrance. Reviewing animated frames is how a deck gets "fixed" for
  # a problem it never had.
  for i in $(seq 0 $((n - 1))); do
    chrome_run --screenshot="$dir/dist/shots/$(printf '%02d' "$i").png" \
      --window-size=1920,1080 --virtual-time-budget=4000 \
      "file://$dir/index.html?qa#/$i" || true
  done
  echo "$n frames in $dir/dist/shots"
}

cmd_list() {
  python3 - "$DECKS" <<'PY'
import json, os, sys
root = sys.argv[1]
rows = []
for name in sorted(os.listdir(root)):
    d = os.path.join(root, name)
    if name.startswith("_") or not os.path.isdir(d):
        continue
    meta = {}
    try:
        meta = json.load(open(os.path.join(d, "deck.json")))
    except Exception:
        pass
    rows.append((name, meta.get("status", "?"), meta.get("kind", "?"),
                 meta.get("slides", "?"), meta.get("title", name)))
if not rows:
    print("no decks yet. deck.sh new <slug>")
w = max((len(r[0]) for r in rows), default=4)
for name, status, kind, slides, title in rows:
    print(f"{name:<{w}}  {status:<9} {kind:<9} {slides:>3} slides  {title}")
PY
}

cmd_serve() {
  echo "serving $DECKS on http://127.0.0.1:8291"
  cd "$DECKS" && python3 -m http.server 8291 --bind 127.0.0.1
}

case "${1:-}" in
  new)   shift; cmd_new "$@" ;;
  build) shift; cmd_build "$@" ;;
  shots) shift; cmd_shots "$@" ;;
  list)  shift; cmd_list "$@" ;;
  serve) shift; cmd_serve "$@" ;;
  *) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//' ;;
esac

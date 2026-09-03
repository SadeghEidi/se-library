# Deck Kit

A pitch deck system. Decks are built as HTML, from one shared kit, so they come
out brand-exact, reviewable in git, and identical on a laptop, a 4K monitor and
a boardroom projector.

![Six slides from the reference deck](docs/preview.png)

It is three things that work together:

- **the kit** (`decks/_kit`) — reveal.js underneath, one stylesheet for layout
  and motion, themes for colour and type, a small runtime, the fonts
- **the tool** (`bin/deck.sh`) — scaffold a deck, screenshot every slide,
  export a PDF, list what exists
- **the skill** (`skill/`) — the judgement: which narrative fits which room,
  what makes a slide read as expensive, and the pass to run before sending
  anything. It is an AgentSkill, so Claude Code and OpenClaw both read it.

## Start a deck

```bash
bin/deck.sh new acme-series-a --kind investor \
  --title "Acme" --subtitle "One line about the company" --presenter "Your Name"
open decks/acme-series-a/index.html
```

Edit `decks/acme-series-a/index.html`. Every layout you need is already in
`decks/example/index.html` with a comment on it saying when to use it, so copy
from there rather than inventing markup.

```bash
bin/deck.sh shots acme-series-a    # one PNG per slide, into dist/shots
bin/deck.sh build acme-series-a    # the PDF and the cover
bin/deck.sh list
```

While presenting: arrows to move, `Esc` for the overview, `G` to overlay the
12-column grid when a slide feels subtly wrong.

## Install the skill

```bash
./install.sh
```

It symlinks `skill/` into `~/.claude/skills/` and `~/.openclaw/skills/`, so
Claude Code and OpenClaw both pick it up. One copy, both tools. After that, ask
either of them to build a deck and the skill fires on its own.

## Requirements

Bash, Python 3 with Pillow (`pip install pillow`), and a Chromium. The tool
finds Chrome or Chromium automatically; set `CHROME_BIN` to override.

**Not the snap build of Chromium.** It is confined: it writes its output inside
its own private `/tmp` and reports success while producing no file, which looks
exactly like a bug in this tool. Any other Chromium, including the one
Playwright installs, is fine.

## Why the PDF is raster

The PDF is assembled from one capture per slide rather than from the browser's
print pipeline. reveal.js 5 owns that pipeline and its paper stylesheet unpins
absolutely positioned slides; measured 2026-09-03, both `chromium
--print-to-pdf` and a CDP `Page.printToPDF` with an explicit 1920x1080 paper
size returned two blank pages regardless of deck length. Capturing frames costs
selectable text and buys an exact match with what the room saw.

## Themes

`notify-me-dark` (the default), `notify-me-light`, and `neutral`. A theme sets
custom properties and nothing else: colour, type, and the background layer. To
point the kit at another brand, copy `neutral.css`, change `--accent` and the
two font stacks, and leave the rest of the kit alone.

## Fonts

TT Drugs is a commercial TypeType family, licensed to Notify Me. It ships here
because this repository is private and internal. **Read `FONTS.md` before making
this repository public or sending it outside the company.** Inter Tight is open
(SIL OFL) and can go anywhere.

## Layout

```
bin/deck.sh          the tool
decks/_kit/          the engine: css, js, vendor, fonts, template
decks/example/       every layout, worked, with comments
skill/               the AgentSkill: SKILL.md and its references
```

The canonical copy of the kit lives in Sam's OpenClaw workspace; this repository
is exported from it by `bin/deck-kit-publish.sh` there. Send changes as a PR or
tell Sam, rather than editing here and hoping.

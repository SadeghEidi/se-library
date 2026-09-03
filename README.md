# Deck Kit

A pitch deck system. Decks are built as HTML, from one shared kit, so they come
out brand-exact, reviewable in git, and identical on a laptop, a 4K monitor and
a boardroom projector.

![Six slides from the reference deck](docs/preview.png)

It is three things that work together:

- **the kit** (`deck-kit/kit`) — reveal.js underneath, one stylesheet for
  layout and motion, themes for colour and type, a small runtime, the fonts
- **the tool** (`deck-kit/bin/deck.sh`) — scaffold a deck, screenshot every
  slide, export a PDF, list what exists
- **the skill** (`deck-kit/skills/`) — the judgement: which narrative fits which
  room, what makes a slide read as expensive, and the pass to run before
  sending anything. It is an AgentSkill, so Claude Code and OpenClaw both read
  it.

## Install it as a Claude Code plugin

```
/plugin marketplace add SadeghEidi/deck-kit
/plugin install deck-kit@deck-kit
```

That is the whole setup. The skill comes with it, so from then on asking Claude
for a pitch deck in any project uses this kit and this judgement, and
`/deck-kit:deck` starts one explicitly.

Decks land in `./decks/` in whatever project you are working in. The first deck
you make there also copies the engine into `./decks/_kit`, so the deck keeps
working if the plugin is later updated or removed, and still opens in five years
on a laptop with nothing installed.

## Or use it without Claude

Clone it and run the tool directly.

## Start a deck

```bash
deck-kit/bin/deck.sh new acme-series-a --kind investor \
  --title "Acme" --subtitle "One line about the company" --presenter "Your Name"
open decks/acme-series-a/index.html
```

Edit `decks/acme-series-a/index.html`. Every layout you need is already in
`decks/example/index.html` with a comment on it saying when to use it, so copy
from there rather than inventing markup.

```bash
deck-kit/bin/deck.sh shots acme-series-a   # one PNG per slide, into dist/shots
deck-kit/bin/deck.sh build acme-series-a   # the PDF and the cover
deck-kit/bin/deck.sh list
```

`DECKS_DIR` keeps decks somewhere else, `DECK_KIT` points at another copy of the
engine, `CHROME_BIN` chooses the browser.

While presenting: arrows to move, `Esc` for the overview, `G` to overlay the
12-column grid when a slide feels subtly wrong.

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
.claude-plugin/marketplace.json   the catalog Claude Code installs from
deck-kit/                         the plugin
  .claude-plugin/plugin.json
  skills/building-a-pitch-deck/   the judgement
  commands/deck.md                /deck-kit:deck
  kit/                            the engine: css, js, vendor, fonts, template
  bin/deck.sh                     the tool
decks/example/                    every layout, worked, with comments
```

The canonical copy of the kit lives in Sam's OpenClaw workspace; this repository
is exported from it by `bin/deck-kit-publish.sh` there. Send changes as a PR or
tell Sam, rather than editing here and hoping.

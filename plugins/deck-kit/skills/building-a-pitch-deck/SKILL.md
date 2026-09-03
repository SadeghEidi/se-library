---
name: "building-a-pitch-deck"
description: "Build, review or rebuild a pitch deck, keynote, investor, sales, partner or board presentation; also for slide design, deck narrative and exporting a deck PDF."
---

# Building a pitch deck

Sam's decks are built as code, in this repo, from one kit. Not in Google
Slides, not in Gamma, not as a one-off HTML file that never gets found again.

The kit and the tool both travel with this plugin. Run the tool as
`${CLAUDE_PLUGIN_ROOT}/bin/deck.sh`, from whatever project the deck belongs
to; decks land in `./decks/` there. On Sam's own machine they also surface
on the Decks page in Sam Workbench.

## Before anything: is a deck the right artifact

A deck is for a room, live, with a speaker. If the thing will be read alone
with nobody talking, it is a document, and Sam's document shape is the
one-pager with subpages. Decks that are secretly
documents are the most common failure, and they read as dense, wordy and dull
because they are being asked to do a job they are the wrong tool for.

If it genuinely is a deck, the second question is which kind, because the
narrative spine differs. Read `references/narrative.md` and pick one before
writing a single slide.

## The path

**1. Decide the spine, on one page, before any HTML.**
Write the deck as a list of action titles first, in a scratch file. An action
title is the conclusion of the slide, not its topic: "Retention is where the
money leaks", never "Retention". If the titles alone, read in order, do not
make the argument, the deck will not either, and no amount of design fixes it.
Show Sam the title list and get it agreed before building. This is the step
that saves the most time and gets skipped the most.

**2. Scaffold.**

```bash
deck.sh new <slug> --kind investor \
  --title "Title" --subtitle "One line" --presenter "Sam Eidi"
```

Themes: **`notify-me-dark` is the default**, at Sam's instruction 2026-09-03.
`notify-me-light` is there for a deck that will mostly be read as a PDF on a
laptop, and `neutral` for anything that is not Notify Me. Kinds: investor,
sales, partner, board, internal, conference.

**3. Build the slides.** Edit `decks/<slug>/index.html`. Every layout you need
is already in `${CLAUDE_PLUGIN_ROOT}/example/index.html` with a comment saying when
to use it, so copy from there rather than inventing markup. The rules that
matter are in `references/slide-craft.md` and `references/visual-system.md`.
Anything true of only this deck goes in its own `deck.css`; anything reusable
goes in the kit.

**4. Look at it, every time.**

```bash
deck.sh shots <slug>     # one PNG per slide into dist/shots/
```

Then actually read the images. A deck is judged by looking at it, and a slide
that overflows its frame or collides with the footer is invisible in source and
obvious in a screenshot. Review against `references/checklist.md`.

**5. Build and file.**

```bash
deck.sh build <slug>     # PDF + cover, updates deck.json
```

Then set `status` in `decks/<slug>/deck.json` (`draft`, `review`, `final`,
`presented`) and, after it is delivered, fill in `presented` and `outcome`.
That record is the point of the registry: next time, the question "what did we
send Nosto and how did it land" has an answer.

**6. Hand it over.** Send the deck itself, or the PDF in `dist/`. Never a
gallery of screenshots of it: show the thing, in the place it lives.

## The five rules that decide whether it looks expensive

These are the ones that separate a deck from a template. The full spec is in
`references/visual-system.md`; these are the ones to never get wrong.

0. **Every content slide is head, stage, source, in that order.** The title
   starts at the same height on every slide and the content is centred in what
   is left. This is structural, it lives in `kit.css`, and it is the single
   thing that makes a deck feel like one object rather than a pile of
   arrangements. Content put straight into a `section` does not sit on those
   rows and will look subtly wrong in a way that is hard to name.
1. **One idea per slide, and the title says what it is.** If a slide needs two
   sentences to explain, it is two slides. Twelve to sixteen slides, and an
   appendix for everything that is evidence rather than argument.
2. **Type does the work, colour barely appears.** Two typefaces, one accent.
   On a normal slide the only saturated colour is one accent element. A deck
   that is colourful is a deck that has nothing to say.
3. **Whitespace is the budget.** 110px outer margins, nothing meaningful
   within 96px of the top or bottom. A slide that fills its frame reads as
   cheap no matter how good the content is.
4. **Show the real thing.** A screenshot of the actual product, a photo of the
   actual person, the actual chart. Stock illustration and generated imagery
   are what a deck reaches for when it has nothing to show, and every audience
   can tell.
5. **Every number carries its source and its definition.** Sam's standing rule
   for findings applies on a slide too: the figure, what it counts, and where
   it came from, on the slide, in the `.source` line.

## Motion

The kit's motion is deliberately small: content rises 18px into place on
arrival, grouped items stagger 70ms apart, numbers count up over 900ms, chart
bars grow. One easing curve, `cubic-bezier(0.16, 1, 0.3, 1)`, everywhere.

Do not add more. Motion in a deck exists to direct the eye to what just
arrived; an audience that notices a transition has stopped listening to the
argument. Nothing spins, flies in from the side, or bounces. `references/motion.md`
has the durations and the failure modes.

Stepped reveals (reveal.js fragments) are for when the *order* of arrival is
the argument, and for nothing else. Never to hide a bullet list from the room.

## Brand

For Notify Me, colour and type come from the website's design system
(`nm-website/DESIGN-SYSTEM.md`, internal), already encoded in the two
`notify-me-*` themes. Do not sample new colours off a screenshot. If a deck
seems to need a colour the system does not have, that is a question for Sam,
not a decision to make in a stylesheet.

The strongest existing reference is the Nosto 2026 keynote in the website
repository under `public/nosto2026-presentation/`. The dark
theme in this kit is derived from it. Read it before a stage deck.

## What lives where

| Thing | Path |
|---|---|
| The kit (CSS, runtime, fonts, template) | `${CLAUDE_PLUGIN_ROOT}/kit/` |
| Every layout, worked, with comments | `${CLAUDE_PLUGIN_ROOT}/example/index.html` |
| One deck | `decks/<slug>/` |
| Built PDF, cover, per-slide PNGs | `decks/<slug>/dist/` |
| The tool | `${CLAUDE_PLUGIN_ROOT}/bin/deck.sh` |
| The listing | `deck.sh list` |

## Known and accepted

**The PDF is raster, not vector.** It is assembled from one screenshot per
slide. reveal.js 5 owns its own print pipeline and its paper stylesheet unpins
absolutely positioned slides; measured 2026-09-03, both
`chromium --print-to-pdf` and a CDP `Page.printToPDF` with an explicit
1920x1080 paper size returned two blank pages regardless of deck length. The
capture route costs selectable text and lands around 1 MB for 12 slides, and
buys an exact match with what the room saw. Do not "fix" this by switching
back to the print pipeline without re-measuring it.

**Chromium is the playwright build**, not the snap. The snap is confined and
writes its output inside its own private `/tmp` while reporting success, so a
build appears to work and produces no file.

## References

- `references/narrative.md` — which framework for which audience, and the spine for each
- `references/slide-craft.md` — action titles, word budgets, charts, tables, appendix
- `references/visual-system.md` — grid, type scale, colour roles, the kit's tokens
- `references/motion.md` — durations, easing, what makes motion look cheap
- `references/checklist.md` — the pass to run before anything is sent

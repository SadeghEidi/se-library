# The visual system

Encoded in `decks/_kit/css/kit.css` (structure and motion) and
`decks/_kit/css/themes/*.css` (colour and type). The kit knows no colours; the
themes set no layout. Keep it that way.

## Canvas and grid

- **1920 x 1080 fixed canvas.** reveal.js scales it to any screen, so a slide
  that is right here is right on a laptop, a 4K monitor and a projector.
- **12 columns, 120px outer margin, 32px gutter.**
- **Three rows on every content slide: head, stage, source.** The head (eyebrow,
  action title, one sentence) starts at a fixed 96px from the top on every
  slide. The stage takes everything left over and centres its content in it.
  The source line is pinned to the last row, so it is at the same height
  wherever it appears.

  This is worth understanding rather than copying, because the two obvious
  alternatives were both tried on 2026-09-03 and both look wrong. Centring the
  whole slide as one block puts the title at a different height on every slide
  and pools the leftover space at the bottom. Stretching content to fill the
  stage turns a row of three short cards into three 500px columns with dead
  lower halves. Fixed head, centred stage, and a `min-height` on the card is
  what holds it together.
- **Safe area:** nothing meaningful within 96px of the top or bottom, 110px of
  either side. Projectors crop and video calls put a toolbar over the bottom.
- Press **G** while presenting to overlay the column grid. Use it whenever a
  slide feels subtly wrong; it is usually an element a few pixels off a column.

## Type scale

One scale, on the 1920 canvas. Nothing below 18px ever, because the PDF gets
read on a phone.

| Role | Size | Used for |
|---|---|---|
| Display | 132px | The cover title, nothing else |
| H1 | 96px | Statement slides and section dividers |
| H2 | 68px | The action title on a normal slide |
| H3 | 36px | Card and column headings |
| Lead | 28px | The one supporting sentence, capped at 900px wide |
| Body | 24px | Card copy |
| Small | 19px | Captions, sources, axis labels |
| Label | 16px | Eyebrows, metric labels, footer, tracked 0.16 to 0.32em |
| Metric | 112px | The big number, always tabular figures |

These were all one step smaller until 2026-09-03. On a 1080 canvas the smaller
scale read as timid: a slide is seen from ten feet away and then again as a
thumbnail, and both readings want more weight than a screen layout does.

**Two typefaces, maximum.** Here that is TT Drugs (display) and Inter Tight
(everything else). TT Drugs ships no
500 weight: asking for 500 in display type silently renders Regular and the
emphasis vanishes, so display emphasis is 700 and body emphasis is 500.

**Line height 1.02 on headings**, 1.5 on body. Tight headings are most of what
makes display type look designed rather than typed.

## Colour roles

A theme sets tokens, and a slide only ever refers to the tokens.

- `--bg-0` the ground, `--surface` for a card
- `--ink-0` to `--ink-3`, darkest to lightest. `--ink-3` is for labels and
  captions only and must never carry a sentence.
- `--accent`, one, and one only per slide. `--accent-2` exists for the rare
  second series in a chart.
- `--signal-good` / `--signal-bad` for direction, never for decoration.

**Contrast:** on the light theme, ink-0 is 16:1 against the ground, ink-2 is
7.3:1 and is the lightest that may carry prose. On a projector with a tired lamp
you lose about a third of your contrast, which is why the light theme is the
default for anything you do not control.

**Light or dark:** `midnight` is the default. `daylight` is the one to reach
for when a deck will mostly be read as a PDF on a laptop
rather than presented, because a full-bleed near-black page prints as a heavy
slab and is hard to read on a phone in daylight. Say which one a deck is using
and why when there is a real choice to make.

**Any ambient background layer must be static.** The midnight theme's glow was a
drifting 22-second loop until 2026-09-03. Because that layer is fixed behind
all the slides rather than owned by one, every slide caught the animation at a
different phase, and the deck read as twelve different backgrounds. It also
competes with the content's own entrance motion, which is the only motion that
should pull the eye.

## Surfaces

One card style per deck. Radius 18px light, 22px dark. On dark, the glass
treatment (5% white fill, 14% white border, 18px backdrop blur, a large soft
shadow) is what stops a near-black slide reading as a flat rectangle. On light,
a hairline border and a barely-there shadow: a light deck with heavy shadows
looks like a 2014 template.

## Imagery

1. A real screenshot of the real product, cropped to the part being discussed.
   Never a full desktop with browser chrome and a dock in it. Capture at 2x.
2. A real photograph of a real person or place.
3. A diagram you drew, in the deck's own type and accent.

Stock illustration, generated imagery, icon sets with a house style that is not
yours, and "abstract tech" backgrounds are all the same tell: nothing real to
show. If a slide genuinely has no image, give it whitespace instead.

## What makes a deck look generic

- Every slide the same layout, usually title-plus-bullets
- More than two typefaces, or a display face used for body copy
- Colour used decoratively: coloured bullets, a gradient behind every card
- Icons on everything, one per bullet, from a set nobody chose
- Full-frame content with no margin
- Centre-aligned body copy that is more than one line
- Rounded corners at three different radii on one slide
- Stock photos of handshakes, cityscapes, or people pointing at a whiteboard
- A logo on every slide at full size and full opacity

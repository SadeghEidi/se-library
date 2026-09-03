# The pass before anything is sent

Run `bin/deck.sh shots <slug>` and read the images. Not the source.

## Argument

- [ ] The action titles, read alone in order, make the argument
- [ ] Every slide has exactly one idea
- [ ] The last slide is the ask, with a number and a date, not "Thank you"
- [ ] Evidence that is not argument has moved to the appendix
- [ ] Someone who reads only the first three slides still knows what is wanted

## Numbers

- [ ] Every figure says what it counts, in the sentence that quotes it
- [ ] Every figures slide has a `.source` line naming the table and the dates
- [ ] Bar charts start at zero
- [ ] The numbers agree with each other across slides, and with the appendix
- [ ] No placeholder survived: search the deck for TBD, lorem, XXX, and 1240

## Craft

- [ ] Nothing within 96px of the top or bottom, or 110px of either side
- [ ] No slide over about 40 words
- [ ] Two typefaces, one accent colour per slide
- [ ] Every image is a real screenshot, photograph or drawn diagram
- [ ] Card radii, gaps and shadows are identical across every slide
- [ ] Press G: elements sit on the columns
- [ ] No em dash or en dash anywhere in the deck

## Mechanics

- [ ] Footer, date and page numbers are right on every slide (the runtime
      stamps these, so a wrong one means a slide overrode it)
- [ ] The cover has no page number and no footer clutter
- [ ] It reads on a phone: open `dist/<slug>.pdf` and look at it small
- [ ] `deck.json` has the real status, and `presented` and `outcome` once it is
- [ ] The Workbench page does not say "edited since build"

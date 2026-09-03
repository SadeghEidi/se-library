# Fonts, and the one thing to check before sharing this

Two families ship in `decks/_kit/fonts/`.

**Inter Tight** is licensed under the SIL Open Font License. It can be
redistributed, bundled, and published without restriction, including in a
public repository.

**TT Drugs** is a commercial retail family from TypeType. Notify Me holds a
licence for it. A desktop or web licence of this kind normally permits internal
use and embedding in a published document, and does **not** permit
redistributing the font files themselves so that other people can install or
reuse them. Putting the `.otf` files in a public repository is redistribution.

So:

- **Private repository, internal colleagues:** fine as it stands. They are
  working under the same licence you already hold.
- **Public repository, or anyone outside the company:** delete
  `decks/_kit/fonts/TTDrugs-*.otf`, and either point `--font-display` at Inter
  Tight (which the `neutral` theme already does) or leave the `@font-face`
  rules in place with a line in the README telling a licensed user where to
  drop their own copies.

## Already public

Checked 2026-09-03: `SadeghEidi/notify-me-nosto-deck` is a public repository and
it contains all five TT Drugs cuts under `fonts/`. That is the same
redistribution question, live today, and it predates this kit. Worth either
making that repository private or stripping the font files from it.

# SE Library

Sam Eidi's Claude Code plugins: tools and judgement used on real work, packaged
so a colleague can install them in two commands.

```
/plugin marketplace add SadeghEidi/se-library
/plugin install deck-kit@se-library
```

## What is in it

| Plugin | What it does |
|---|---|
| [deck-kit](plugins/deck-kit) | Build a pitch deck as code: one shared kit, a PDF export, and the judgement that makes a deck land |

## Adding a plugin

A plugin is a directory under `plugins/` with a `.claude-plugin/plugin.json`,
plus whatever it provides: `skills/`, `commands/`, `agents/`, `hooks/`, an MCP
server. Claude Code finds those by convention, so nothing has to be registered
twice.

1. Write it under `plugins/<name>/`.
2. Add an entry to `.claude-plugin/marketplace.json` with
   `"source": "./plugins/<name>"`.
3. Add a row to the table above.
4. Test it before pushing: `claude plugin marketplace add .` then
   `claude plugin install <name>@se-library`, and use it.

Keep each plugin self-contained. A plugin that reaches into another one, or
into a path on one particular machine, breaks the moment someone else installs
it, and that failure is quiet.

## Where these come from

Most of these are developed somewhere else and published here rather than
edited here, because the working copy is the one that gets used every day and a
second editable copy always drifts. deck-kit is assembled from Sam's OpenClaw
workspace by `bin/deck-kit-publish.sh --push` there; its own publish step only
ever rewrites its own directory and its own line in the catalog, so the rest of
the library is safe. If a plugin here has a source elsewhere, its README says
so. Send changes as a pull request, or say something, rather than editing the
published copy and hoping.

## Private, and why

This repository carries commercial TT Drugs font files, licensed to Notify Me.
Internal use is covered; publishing them is redistribution and is not. See
[plugins/deck-kit/FONTS.md](plugins/deck-kit/FONTS.md) before making this
public.

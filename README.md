# SE Library

Claude Code plugins by [Sam Eidi](https://github.com/SadeghEidi): tools and
judgement used on real work, packaged so anyone can install them in two
commands.

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

These are developed in the working repositories where they get used every day,
and published here rather than edited here: a second editable copy always
drifts from the one doing the work. Each plugin's publish step rewrites only
its own directory and its own line in the catalog, so the rest of the library
is never touched by a sync.

Issues and pull requests are welcome. If you change a published copy directly
it will be overwritten by the next sync, so open a PR and it gets folded into
the source.

## Licensing

The code is MIT; see [LICENSE](LICENSE). Bundled third-party material keeps its
own terms, and one of the fonts in deck-kit is commercial rather than open:
read [plugins/deck-kit/NOTICE.md](plugins/deck-kit/NOTICE.md) before using the
branded themes commercially.

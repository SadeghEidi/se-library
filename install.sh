#!/usr/bin/env bash
# Install the skill so Claude Code and OpenClaw both see it.
#
# Both read the same AgentSkill format (a folder with a SKILL.md), and both
# accept a symlinked skill directory, so one copy serves both rather than two
# that drift apart.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="building-a-pitch-deck"

for root in "$HOME/.claude/skills" "$HOME/.openclaw/skills"; do
  [ -d "$(dirname "$root")" ] || continue
  mkdir -p "$root"
  ln -sfn "$HERE/skill" "$root/$NAME"
  echo "linked $root/$NAME"
done

command -v python3 >/dev/null || echo "warning: python3 is needed for the PDF export"
python3 -c "import PIL" 2>/dev/null || echo "warning: run 'pip install pillow' for the PDF export"
echo "done. try: $HERE/bin/deck.sh new my-first-deck --title 'My Deck'"

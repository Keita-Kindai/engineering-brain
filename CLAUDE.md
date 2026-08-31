# Engineering Brain adapter for Claude Code

この repository では [`BRAIN.md`](BRAIN.md) が Agent-neutral protocol の Source of Truth です。作業前に全文ではなく task に必要な section と該当 directory の index だけを読んでください。

- Memory retrieval は local-first / progressive disclosure で行う。
- 未登録 Project を勝手に登録しない。
- Public/private boundary と Knowledge ownership を守る。
- Memory publishingは`BRAIN.md`の境界に従う。Agent-authored `brain-learn` memoryだけが限定的な自動commit/push対象である。
- Canonical skills は `agent-tools/skills/`、Claude Code adapter は `.claude/skills/` にある。

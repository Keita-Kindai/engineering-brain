# Project registry

Public に保存できる登録済み Project の index です。未登録 Project を Agent が自動追加することは禁止します。Private Project は `.private/projects/`、machine-local path mapping は `.local/project-registry.tsv` に置きます。

| Project ID | Repository identity | Status | Overview |
| --- | --- | --- | --- |
| custom-contest | github.com/Keita-Kindai/custom-contest | active | [Overview](custom-contest/overview.md) |

Project lookup は exact local mapping、normalized Git remote、Project ID / directory basename の順で行い、候補が曖昧なら User に確認します。


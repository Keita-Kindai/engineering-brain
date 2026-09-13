---
project: custom-contest
updated: 2026-09-09
---

# Next actions

1. `fix/pin-ssl-mode` をmergeして再デプロイする（migration 0004 とカタログ4,764問のseedも同じデプロイで走る）
2. 公開範囲を別アカウントから実地で確かめる（非公開が開けないこと、限定公開がURLで開けること）
3. Googleを足すか決める。足すならprovider取り違えの案内をどうするか
4. 練習画面（`/practice/[setId]`）を設計する
5. Neonのusageを一度見て、CU-hoursの消費ペースを掴む
6. 対戦を戻す時期と、そのときのホスティングを決める（Room stateを外部storeへ移すか、常駐processへ払うか）
7. ICPC / Codeforcesの問題を入れるか。`problem_id` の名前空間が衝突する（DESIGN-099）

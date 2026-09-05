# 『Participation Capacity, Standards Blocs, and Inefficient International Standardization』数理解説

## 神戸大学経済学研究科 修士1年向け

## 0. この資料の目的

この資料は、論文

> *Participation Capacity, Standards Blocs, and Inefficient International Standardization*

の数理部分を、神戸大学経済学研究科の修士1年生が読めるように、日本語で順を追って説明するための補助ノートです。

目標は次の 3 点です。

1. この論文で何を数式化しているのかをつかむ。
2. Stage 4 の企業均衡、Stage 1-3 の政府の regime choice、Stage 0 の投資問題がどうつながるかを理解する。
3. 論文中の式番号や補題・命題を、「どの経済直観を数式で言っているのか」という形で読めるようになる。

この資料は、論文の数式を全部展開し直すというより、

- どの式が何を意味しているか
- どういう順番で導かれるか
- どこが難所か

を重視して解説します。

---

## 1. この論文は何をしたいのか

### 1.1 一言で言うと

この論文は、

- 国際標準がバラバラのままか
- 2 国だけで標準をそろえるか
- 3 国すべてで標準をそろえるか

を分析する理論モデルです。

ただしポイントは、単に「法的に標準を相互承認したかどうか」ではありません。  
論文は、**formal recognition（形式的な承認）** と **effective participation（実効的な参加）** を区別しています。

つまり、

- 形式上は共通標準に入っていても
- 実際には試験・認証・適合・実装能力が低いため
- 外国市場で十分に競争できない

という状況をモデル化しています。

この「実効的な参加能力」を論文は **participation capacity** と呼びます。

### 1.2 なぜ重要か

標準が統一されると、通常は

- 互換性が高まる
- 市場が広がる
- ネットワーク外部性が大きくなる

ので、世界全体では望ましそうに見えます。

しかし論文の主張は、

- 世界全体では 3 国統一が望ましくても
- 既存のメンバー国にとっては outsider を入れないほうが得

ということがありうる、という点です。

その原因が、低能力国の **participation capacity の低さ** にあります。

---

## 2. モデルの全体像

## 2.1 プレイヤーと市場

国は 3 つです。

- $A$
- $B$
- $C$

各国には 1 社ずつ企業があり、企業も同じ記号 $A,B,C$ で表されます。

各国市場は分断されていて、消費者は自国市場でのみ購入します。  
ただし企業は 3 市場すべてに輸出できます。

競争形態は **Cournot 競争**、つまり数量競争です。

## 2.2 3 つの標準化 regime

論文は 3 つの regime を考えます。

| 記号 | 名称 | 内容 |
| --- | --- | --- |
| $SW$ | Standards War | 各国が自国標準を維持し、相互承認しない |
| $SU$ | Standardization Union | $A,B$ だけが相互承認し、$C$ は外に残る |
| $IS$ | International Standardization | 3 国すべてが相互承認する |

ここでの直観は、

- $SW$ は完全分断
- $SU$ は 2 国ブロック
- $IS$ は全面統一

です。

## 2.3 ゲームのタイミング

論文では 5 段階ゲームになっています。

1. Stage 0: 各国政府が participation capacity 投資 $I_k$ を選ぶ
2. Stage 1: $A,B$ が 2 国 union を作るか決める
3. Stage 2: union ができたら $C$ が加盟申請するか決める
4. Stage 3: $C$ が申請したら $A,B$ が受け入れるか決める
5. Stage 4: 企業が数量競争する

解き方は **backward induction（後ろ向き帰納法）** です。

つまり、

- まず Stage 4 の企業均衡を解く
- それを使って政府の厚生を計算する
- そのうえで Stage 3, 2, 1, 0 を順に解く

という流れです。

---

## 3. 需要側の数理

## 3.1 効用関数

国 $k$ の代表的消費者の効用は

$$
U_k^r(\{q_{ik}^r\}_{i \in K})
=
\sum_{i \in K} \bigl(1 + v B_{G_r(i)}^r\bigr) q_{ik}^r
-
\frac{1}{2}(Q_k^r)^2
-
\sum_{i \in K} p_{ik}^r q_{ik}^r
$$

です。

ここで

- $q_{ik}^r$: regime $r$ の下で、企業 $i$ が市場 $k$ で売る数量
- $Q_k^r=\sum_i q_{ik}^r$: 市場 $k$ の総販売量
- $v \ge 0$: ネットワーク外部性の強さ
- $B_{G_r(i)}^r$: 企業 $i$ が属する認証グループの installed base

です。

### 3.1.1 この効用の読み方

効用の第 1 項は「各製品の基本価値 + ネットワーク便益」です。  
第 2 項の $-\frac12 Q^2$ は、総供給量が大きいほど限界効用が下がる通常の線形需要を生みます。  
第 3 項は支払いです。

## 3.2 installed base の定義

regime $r$ の下で、認識グループ $g$ の installed base は

$$
N_g^r \equiv \sum_{m \in K} \sum_{j \in g} q_{jm}^r
$$

です。

つまり、「その標準に属する企業たちが、全市場でどれだけ使われているか」の合計です。

ただし論文では、1 国だけの孤立標準にはネットワーク便益を与えません。  
そこで

$$
B_g^r =
\begin{cases}
N_g^r & \text{if } |g| \ge 2,\\
0 & \text{if } |g| = 1
\end{cases}
$$

と置きます。

これは、

- 共通標準として相互承認されているときだけ network benefit が生じる
- 1 国だけの孤立標準には「共通標準の外部性」はない

という modeling choice です。

## 3.3 逆需要の導出

消費者が $q_{ik}^r$ を選ぶときの一階条件は

$$
\frac{\partial U_k^r}{\partial q_{ik}^r}
=
1 + v B_{G_r(i)}^r - Q_k^r - p_{ik}^r = 0
$$

です。

したがって逆需要は

$$
p_{ik}^r = 1 - Q_k^r + v B_{G_r(i)}^r
$$

になります。

### 3.3.1 直観

この式は非常に重要です。

- $-Q_k^r$ は通常の Cournot 需要の「混雑効果」
- $+vB$ は compatibility による需要シフト

を表しています。

つまり、

- 同じ市場の総供給が増えると価格は下がる
- しかし共通標準の installed base が大きいと、その標準に属する製品の需要は上方シフトする

という構造です。

---

## 4. 費用側の数理

## 4.1 2 種類の国際取引コスト

論文の費用構造には 2 つの要素があります。

### 4.1.1 technology-gap cost $c$

外国市場が自国と互換的でない標準を使っているときの基礎的な適応コストです。

### 4.1.2 residual compliance cost $\tau_i$

これは輸出国 $i$ 固有の「参加能力の低さ」による残余的コストです。

論文では

$$
\tau_i = \mu(1-\theta_i), \qquad \mu>0
$$

と置きます。

ここで

- $\theta_i$: participation capacity
- $\theta_i$ が高いほど $\tau_i$ は低い

です。

## 4.2 対称性の置き方

論文は $A,B$ を高能力国として対称に扱います。

$$
\tau_A=\tau_B \equiv \tau
$$

一方、$C$ は低能力国なので

$$
\tau_C
$$

を別に持ちます。通常は $\tau_C > \tau$ を想定しています。

## 4.3 regime ごとの限界費用

企業 $i$ が市場 $k$ に売るときの限界費用は

$$
m_{ik}^r=
\begin{cases}
0 & \text{if } i=k,\\
\tau_i & \text{if } i\neq k \text{ and } k \in G_r(i),\\
c+\tau_i & \text{if } i\neq k \text{ and } k \notin G_r(i).
\end{cases}
$$

です。

意味は明快です。

- 自国市場ではコスト 0
- 相互承認の内部では technology-gap cost $c$ が消える
- それでも participation capacity の不足による $\tau_i$ は残る

ここがこの論文の新しさです。

---

## 5. Stage 4: 企業均衡

ここが論文の数理の中心です。

## 5.1 変数のまとめ方

対称性を使って、論文は各 regime の数量を

$$
q_{AA}^r=q_{BB}^r\equiv x^r,\qquad
q_{BA}^r=q_{AB}^r\equiv y^r,
$$

$$
q_{CA}^r=q_{CB}^r\equiv z^r,\qquad
q_{AC}^r=q_{BC}^r\equiv w^r,\qquad
q_{CC}^r\equiv t^r
$$

と置きます。

この意味を丁寧に読むと、

- $x^r$: 高能力国企業の自国市場販売
- $y^r$: 高能力国企業のもう一方の高能力国市場への輸出
- $z^r$: $C$ の $A,B$ 市場への輸出
- $w^r$: $A,B$ の $C$ 市場への輸出
- $t^r$: $C$ の自国市場販売

です。

この置き換えにより、9 変数の問題が 5 変数に縮約されます。

---

## 6. $SW$ の企業均衡

## 6.1 $SW$ では何が起こるか

$SW$ では相互承認がありません。  
したがって network benefit は生じず、各市場は通常の非対称 Cournot 三占になります。

市場 $A$ と $B$ では費用は

$$
(0,\; c+\tau,\; c+\tau_C)
$$

市場 $C$ では

$$
(c+\tau,\; c+\tau,\; 0)
$$

です。

## 6.2 一階条件

論文の一階条件は

$$
1-2x^{SW}-y^{SW}-z^{SW} =0
$$

$$
1-x^{SW}-2y^{SW}-z^{SW}-(c+\tau) =0
$$

$$
1-x^{SW}-y^{SW}-2z^{SW}-(c+\tau_C) =0
$$

$$
1-3w^{SW}-t^{SW}-(c+\tau) =0
$$

$$
1-2w^{SW}-2t^{SW} =0
$$

です。

## 6.3 どうやって解くか

### 6.3.1 市場 $A$ の 3 本から $x,y,z$ を解く

最初の式から 2 番目の式を引くと

$$
(-2x-y-z)-(-x-2y-z-(c+\tau))=0
$$

より

$$
-x+y+(c+\tau)=0
\quad \Longrightarrow \quad
y = x-c-\tau.
$$

同様に、最初の式から 3 番目の式を引くと

$$
z = x-c-\tau_C.
$$

これを最初の式に代入すると

$$
1-2x-(x-c-\tau)-(x-c-\tau_C)=0
$$

なので

$$
1-4x+2c+\tau+\tau_C=0.
$$

したがって

$$
x^{SW} = \frac{1+2c+\tau+\tau_C}{4}.
$$

これを戻せば

$$
y^{SW} = \frac{1-2c-3\tau+\tau_C}{4},
$$

$$
z^{SW} = \frac{1-2c+\tau-3\tau_C}{4}.
$$

### 6.3.2 市場 $C$ の 2 本から $w,t$ を解く

最後の式から

$$
w+t=\frac12.
$$

したがって

$$
t=\frac12-w.
$$

これを 4 本目の式に代入すると

$$
1-3w-\left(\frac12-w\right)-(c+\tau)=0,
$$

つまり

$$
\frac12-2w-(c+\tau)=0.
$$

したがって

$$
w^{SW}=\frac{1-2c-2\tau}{4},
\qquad
t^{SW}=\frac{1+2c+2\tau}{4}.
$$

## 6.4 経済学的な意味

$SW$ では

- $c$ が大きいほど外国企業は不利
- $\tau$ や $\tau_C$ が大きいほど、その国の企業は輸出が不利

です。

特に

$$
z^{SW}=\frac{1-2c+\tau-3\tau_C}{4}
$$

を見ると、$C$ の参加能力が低くて $\tau_C$ が高いほど、$A,B$ 市場への輸出が急激に減ることが分かります。

---

## 7. $SU$ の企業均衡

## 7.1 何が $SW$ と違うか

$SU$ では $A,B$ が相互承認しているので、$A,B$ の企業は同じ標準圏に属します。  
そのため、両者は共通の installed base から便益を受けます。

論文は

$$
X^{SU} \equiv x^{SU}+y^{SU}+w^{SU}
$$

と置き、

$$
S^{SU}=2X^{SU}
$$

を union standard の installed base とします。

## 7.2 一階条件の見方

論文の一階条件は

$$
1-2x^{SU}-y^{SU}-z^{SU}+v(S^{SU}+x^{SU}) =0
$$

$$
1-x^{SU}-2y^{SU}-z^{SU}-\tau+v(S^{SU}+y^{SU}) =0
$$

$$
1-3w^{SU}-t^{SU}-(c+\tau)+v(S^{SU}+w^{SU}) =0
$$

$$
1-x^{SU}-y^{SU}-2z^{SU}-(c+\tau_C) =0
$$

$$
1-2w^{SU}-2t^{SU} =0
$$

です。

これを読むポイントは次の通りです。

### 7.2.1 member firm には $v$ が入る

$A,B$ 企業は union standard の便益を受けるので、需要側に $v$ が入ります。

### 7.2.2 outsider の $C$ には $v$ が入らない

$C$ は bloc の外なので、singleton standard です。  
したがって市場 $A,B$ での $C$ の一階条件には $v$ が入りません。

### 7.2.3 $A,B$ 間輸出では $c$ が消える

相互承認の内部では technology-gap cost が消えるので、$y^{SU}$ の式には $c$ がありません。  
その代わり residual compliance cost $\tau$ だけが残ります。

## 7.3 線形連立として解く

この 5 本の式は $x,y,z,w,t$ に関する線形連立方程式です。  
論文では解を

$$
x^{SU} = \frac{\Xi_x^{SU}}{2(1-v)d_{SU}},\qquad
y^{SU} = \frac{\Xi_y^{SU}}{2(1-v)d_{SU}},
$$

$$
z^{SU} = \frac{\Xi_z^{SU}}{2d_{SU}},\qquad
w^{SU} = \frac{\Xi_w^{SU}}{2d_{SU}},\qquad
t^{SU} = \frac{\Xi_t^{SU}}{2d_{SU}}
$$

という形で書いています。

ここで

$$
d_{SU}=(2-v)(2-7v).
$$

です。

### 7.3.1 $d_{SU}>0$ の意味

$d_{SU}$ は連立方程式の「解きやすさ」を支える分母です。  
これが正であれば、解が一意に存在し、しかも符号条件の確認がしやすくなります。

特に論文が

$$
0 \le v < \frac{2}{7}
$$

を重視するのは、

$$
2-7v>0
$$

を保証するためです。

言い換えると、network effect が強すぎると、反応関数系が不安定になりうるので、その手前にパラメータを制限しているわけです。

## 7.4 $SU$ の経済学的意味

$SU$ では、$A,B$ は

- bloc 内輸出で $c$ を回避できる
- 共通 installed base の便益を受ける

ので有利になります。

一方 $C$ は

- bloc 外に残るため network benefit を受けず
- $A,B$ 市場への輸出では依然として $c+\tau_C$ を払う

ことになります。

したがって $SU$ は、低能力 outsider に不利な構造です。

---

## 8. $IS$ の企業均衡

## 8.1 $IS$ では何が起こるか

$IS$ では 3 国すべてが同じ標準圏に入ります。  
よって technology-gap cost $c$ はすべての外国市場で消えます。

これは重要です。  
$IS$ では「外国市場だからコストが高い」のではなく、「輸出国の participation capacity が低いからコストが残る」という構造になります。

## 8.2 共通 installed base

論文は

$$
N^{IS}\equiv 2x^{IS}+2y^{IS}+2w^{IS}+2z^{IS}+t^{IS}
$$

を共通 installed base と置きます。

すべての企業が同じ標準圏に属するので、すべての企業がこの $N^{IS}$ から便益を受けます。

## 8.3 一階条件

論文の一階条件は

$$
1-2x^{IS}-y^{IS}-z^{IS}+v(N^{IS}+x^{IS}) =0
$$

$$
1-x^{IS}-2y^{IS}-z^{IS}-\tau+v(N^{IS}+y^{IS}) =0
$$

$$
1-3w^{IS}-t^{IS}-\tau+v(N^{IS}+w^{IS}) =0
$$

$$
1-x^{IS}-y^{IS}-2z^{IS}-\tau_C+v(N^{IS}+z^{IS}) =0
$$

$$
1-2w^{IS}-2t^{IS}+v(N^{IS}+t^{IS}) =0
$$

です。

ここでは全企業が network benefit を受けるので、すべての式に $v$ が入っています。

## 8.4 解の形

論文は解を

$$
x^{IS} = \frac{\Xi_x^{IS}}{2(1-v)d_{IS}},\qquad
y^{IS} = \frac{\Xi_y^{IS}}{2(1-v)d_{IS}},
$$

$$
z^{IS} = \frac{\Xi_z^{IS}}{2(1-v)d_{IS}},\qquad
w^{IS} = \frac{\Xi_w^{IS}}{2(1-v)d_{IS}},\qquad
t^{IS} = \frac{\Xi_t^{IS}}{2(1-v)d_{IS}}
$$

と書いています。

ここで

$$
d_{IS}=(4-v)(2-5v).
$$

## 8.5 $IS$ の直観

$IS$ では outsider が消えるので、形式上は最も統合的です。  
しかしこの論文では、$C$ の $\tau_C$ が大きいと、3 国統一しても $C$ は十分に competitive ではありません。

つまり

- $c$ は消える
- だが $\tau_C$ は消えない

ので、「加盟したのに弱いまま」ということが起こります。

これがこの論文の核です。

---

## 9. admissible parameter region の意味

論文は

$$
\mathcal P
$$

という admissible parameter region を置いています。

これは要するに、

- 3 regime すべてで
- 企業の数量が正
- 線形系の分母が正

となる範囲です。

なぜこれが必要かというと、境界解や退出を避けて、比較をすべて interior solution で統一したいからです。

修士レベルでは、

- まず interior Cournot をきれいに解く
- そのうえで welfare comparison をする

というのが標準的な進め方です。

---

## 10. 利潤・消費者余剰・厚生

## 10.1 利潤

企業 $i$ の利潤は

$$
\pi_i^r=\sum_{k \in K}(p_{ik}^r-m_{ik}^r)q_{ik}^r
$$

です。

## 10.2 消費者余剰がきれいに落ちる理由

論文では

$$
CS_k^r=\frac{(Q_k^r)^2}{2}
$$

になります。

これは一見すると不思議ですが、逆需要

$$
p_{ik}^r = 1-Q_k^r+vB_{G_r(i)}^r
$$

を使えば確認できます。

消費者余剰の定義は

$$
CS_k^r=
\sum_i (1+vB_{G_r(i)}^r)q_{ik}^r
-
\frac12(Q_k^r)^2
-
\sum_i p_{ik}^r q_{ik}^r.
$$

ここで

$$
\sum_i p_{ik}^r q_{ik}^r
=
\sum_i (1+vB_{G_r(i)}^r)q_{ik}^r - Q_k^r\sum_i q_{ik}^r
$$

であり、$\sum_i q_{ik}^r = Q_k^r$ なので

$$
\sum_i p_{ik}^r q_{ik}^r
=
\sum_i (1+vB_{G_r(i)}^r)q_{ik}^r - (Q_k^r)^2.
$$

これを代入すると

$$
CS_k^r=\frac{(Q_k^r)^2}{2}
$$

が出ます。

### 10.2.1 大事な点

network benefit があるのに最終的に $CS=\frac12Q^2$ になるのは、network term が逆需要にも効用にも同じ形で入っているからです。  
このため、消費者余剰は総供給量だけの関数としてきれいに整理されます。

## 10.3 利潤 identity

論文では一階条件を使って、利潤をきれいな二乗和で書き直します。

### 10.3.1 $SW$

$$
\pi_A^{SW} = (x^{SW})^2+(y^{SW})^2+(w^{SW})^2
$$

$$
\pi_C^{SW} = 2(z^{SW})^2+(t^{SW})^2
$$

### 10.3.2 $SU$

$$
\pi_A^{SU} = (1-v)\Big[(x^{SU})^2+(y^{SU})^2+(w^{SU})^2\Big]
$$

$$
\pi_C^{SU} = 2(z^{SU})^2+(t^{SU})^2
$$

### 10.3.3 $IS$

$$
\pi_A^{IS} = (1-v)\Big[(x^{IS})^2+(y^{IS})^2+(w^{IS})^2\Big]
$$

$$
\pi_C^{IS} = (1-v)\Big[2(z^{IS})^2+(t^{IS})^2\Big]
$$

### 10.3.4 なぜ $(1-v)$ が出るのか

network benefit を受ける企業では、一階条件が

$$
p-m=(1-v)q
$$

という形に並べ替えられます。  
したがって利潤 $(p-m)q$ は $(1-v)q^2$ になります。

この identity は後の厚生比較で非常に便利です。

## 10.4 国別厚生と世界厚生

政府 $k$ の厚生は

$$
W_k^r = CS_k^r + \pi_k^r - \frac{\eta}{2}I_k^2
$$

です。

世界厚生は

$$
W^r=\sum_k W_k^r.
$$

ただし Stage 1-3 の regime choice では投資費用はすでに sunk なので、論文は

$$
\widehat W_k^r \equiv CS_k^r+\pi_k^r
$$

という **continuation welfare** を使います。

これは backward induction では自然です。

---

## 11. 政府の regime choice

## 11.1 4 つの差分

論文は次の 4 つの差分を置きます。

$$
\Delta_A^I \equiv \widehat W_A^{IS}-\widehat W_A^{SU}
$$

$$
\Delta_C^I \equiv \widehat W_C^{IS}-\widehat W_C^{SU}
$$

$$
\Delta_A^{SU} \equiv \widehat W_A^{SU}-\widehat W_A^{SW}
$$

$$
\Delta_A^{IS} \equiv \widehat W_A^{IS}-\widehat W_A^{SW}
$$

それぞれの意味は、

- $\Delta_A^I$: union member から見て、$SU$ に outsider を入れて $IS$ にする価値
- $\Delta_C^I$: outsider から見て、bloc に加盟して $IS$ になる価値
- $\Delta_A^{SU}$: $SW$ から 2 国 bloc を作る価値
- $\Delta_A^{IS}$: $SW$ から最終的に全面統一へ進む価値

です。

## 11.2 Stage 3: $C$ を受け入れるか

$A,B$ は対称なので、member 国は

$$
\Delta_A^I \ge 0
$$

なら $C$ を受け入れます。

意味は、

- $IS$ にすると installed base は広がる
- しかし $C$ との競争も増える

ので、その差し引きがプラスかどうかを見ている、ということです。

## 11.3 Stage 2: $C$ は加盟申請するか

$C$ は

$$
\Delta_C^I \ge 0
$$

なら加盟申請します。

つまり outsider にとって、bloc 外に残るよりも $IS$ に入るほうが得かどうかです。

## 11.4 Stage 1: そもそも $A,B$ は union を作るか

ここが backward induction の面白いところです。

### 11.4.1 accession が成功する場合

もし

$$
\Delta_C^I \ge 0
\qquad \text{and} \qquad
\Delta_A^I \ge 0
$$

なら、union を作ると最終的には $IS$ に進みます。  
したがって Stage 1 では

$$
\Delta_A^{IS} \ge 0
$$

なら union を作ります。

### 11.4.2 accession が失敗する場合

もし

$$
\Delta_C^I < 0
\qquad \text{or} \qquad
\Delta_A^I < 0
$$

なら、union を作っても最終的には $SU$ のままです。  
したがって Stage 1 では

$$
\Delta_A^{SU} \ge 0
$$

なら union を作ります。

## 11.5 Proposition 1 の読み方

論文の Proposition 1 は、以上をまとめたものです。

### 11.5.1 $IS$ になる条件

$$
\Delta_C^I \ge 0,\qquad
\Delta_A^I \ge 0,\qquad
\Delta_A^{IS} \ge 0
$$

が同時に必要です。

つまり

1. outsider が入りたがる
2. member が受け入れたがる
3. そもそも bloc 形成の最初の一歩が profitable

という 3 段階が全部クリアされないといけません。

### 11.5.2 $SU$ になる条件

$$
\bigl(\Delta_C^I<0 \ \text{or}\ \Delta_A^I<0\bigr)
\quad \text{and} \quad
\Delta_A^{SU}\ge 0
$$

です。

つまり accession はどこかで止まるが、2 国 bloc 自体は作る価値があるケースです。

### 11.5.3 $SW$ になる条件

それ以外です。  
つまり bloc 形成の出発点すら魅力がないケースです。

---

## 12. なぜ世界最適と均衡がずれるのか

この論文の主要結果の 1 つは、

- 世界厚生では $IS$ が一番高い
- でも均衡では $SU$

が起こりうる、という点です。

## 12.1 直観

$C$ が low-capacity で $\tau_C$ が高いと、

- $IS$ にしても $C$ の競争力はあまり強くならない
- したがって installed base の拡大効果は小さい
- しかし member 国にとっては競争圧力だけは増える

ということが起きます。

このとき世界全体では market integration の利益が勝っても、member 国の私的 incentives では outsider を入れないほうが得になります。

これが

$$
\widehat W^{IS} > \widehat W^{SU}
\quad \text{なのに} \quad
\Delta_A^I<0
$$

というずれです。

## 12.2 修士レベルでの理解ポイント

これは貿易政策論や産業組織論でよく出てくる

- private incentive と social optimum の乖離
- insider-outsider problem
- coalition formation の非効率性

の標準テーマです。

この論文は、それを「標準化」と「参加能力」の文脈で書き直しています。

---

## 13. Stage 0: participation capacity 投資

ここから Section 5 の話です。

## 13.1 投資が $\tau$ を下げる

論文では

$$
\theta_k=\bar\theta_k+I_k
$$

なので

$$
\tau_k=\mu(1-\theta_k)
=\bar\tau_k-\mu I_k,
\qquad
\bar\tau_k\equiv \mu(1-\bar\theta_k).
$$

高能力国については対称性から

$$
I_A=I_B\equiv I_H,\qquad \bar\tau_A=\bar\tau_B\equiv \bar\tau
$$

とし、

$$
\tau=\bar\tau-\mu I_H,\qquad
\tau_C=\bar\tau_C-\mu I_C
$$

と書きます。

## 13.2 投資の経済学的意味

$I_H$ は bloc member 側の capacity building、  
$I_C$ は outsider 側の capacity building です。

どちらも $\tau$ を下げますが、効く場所が違います。

- $I_H$ は「bloc を作る価値」や「全面統一に進む価値」に効く
- $I_C$ は「outsider が effective accession できるか」に効く

ここが Figure 4 の意味です。

---

## 14. 固定 regime のもとでの投資条件

regime map が固定されていると仮定すると、Stage 0 の問題は滑らかな最適化になります。

政府の payoff は

$$
\Omega_H(I_H,I_C)
=
\widehat W_A^{R(\tau,\tau_C)}(\tau,\tau_C)-\frac{\eta}{2}I_H^2
$$

$$
\Omega_C(I_H,I_C)
=
\widehat W_C^{R(\tau,\tau_C)}(\tau,\tau_C)-\frac{\eta}{2}I_C^2
$$

です。

regime が固定されて $r$ のままだとすると、一階条件は

$$
\eta I_H = -\mu \frac{\partial \widehat W_A^r}{\partial \tau},
$$

$$
\eta I_C = -\mu \frac{\partial \widehat W_C^r}{\partial \tau_C}
$$

になります。

### 14.1 読み方

右辺は「残余コストを 1 単位下げたときの厚生増分」を、投資 1 単位が $\mu$ だけ $\tau$ を下げることを通じて換算したものです。

したがって一階条件は

> 限界投資費用 ＝ 残余コスト低下による限界便益

という通常の形です。

---

## 15. しきい値分析

## 15.1 なぜ threshold が必要か

この論文の Stage 0 では、投資が単に厚生を滑らかに変えるだけではありません。  
投資によって

- $SW \to SU$
- $SU \to IS$

という regime switch が起こりえます。

だから Section 5 では、投資を **threshold** として読むのが自然です。

## 15.2 主要な monotonicity

論文が使うのは

$$
\frac{\partial \Delta_A^I}{\partial \tau_C}<0,\qquad
\frac{\partial \Delta_C^I}{\partial \tau_C}<0,
$$

$$
\frac{\partial \Delta_A^{SU}}{\partial \tau}<0,\qquad
\frac{\partial \Delta_A^{IS}}{\partial \tau}<0
$$

です。

意味は

- outsider の $\tau_C$ が高いほど accession は通りにくい
- member の $\tau$ が高いほど bloc 形成や全面統一は起こりにくい

ということです。

これは直観的ですが、解析式が長すぎるため、論文は Appendix B で **数値的に sign を検証** しています。

## 15.3 一般的 threshold lemma

Appendix B の Lemma は、要するに

- ある関数 $F(u,z)$ が $z$ について単調減少
- 区間の端で符号が正から負に変わる

なら

- $F(u,z)=0$ を満たす閾値 $z^*(u)$ が一意に存在する

という中間値の定理 + 陰関数定理です。

これは修士 1 年で非常に重要な道具です。

## 15.4 この論文での threshold

### 15.4.1 outsider accession threshold

$$
\Delta_A^I(\tau,\tau_C^A(\tau))=0,
\qquad
\Delta_C^I(\tau,\tau_C^C(\tau))=0
$$

で定義し、

$$
\tau_C^I(\tau)=\min\{\tau_C^A(\tau),\tau_C^C(\tau)\}
$$

とします。

これは

> outsider の残余コストがこの水準以下なら accession が feasible

という意味です。

### 15.4.2 投資空間での閾値

$\tau_C=\bar\tau_C-\mu I_C$ を使えば、

$$
I_C^I(I_H)
=
\max\left\{
0,\,
\frac{\bar\tau_C-\tau_C^I(\bar\tau-\mu I_H)}{\mu}
\right\}
$$

が得られます。

これは

> member 側投資 $I_H$ が与えられたとき、outsider が accession 可能になるために最低限必要な投資

です。

## 15.5 Figure 4 の読み方

Figure 4 は $(I_H,I_C)$ 平面に regime map を描いたものです。

この図の読み方は、

- $I_C$ を増やすと outsider の accession constraint が緩む
- $I_H$ を増やすと member 側の harmonization/formation margin が変わる

という 2 方向の政策効果を見る、ということです。

---

## 16. 条件付き transfer policy

論文はさらに、$IS$ が実現したときだけ発動する transfer $s$ を考えます。

このとき outsider の実効的残余コストは

$$
\tau_C^{IS}(s)=\tau_C-s
$$

になります。

## 16.1 なぜ conditional が重要か

もし transfer が accession を実現しない水準なら、実際には何も起きません。  
したがって重要なのは、最低限必要な

$$
s^{acc}(\tau,\tau_C)
=
\max\{0,\tau_C-\tau_C^I(\tau)\}
$$

です。

## 16.2 planner の問題

planner は

$$
\max_{s\ge 0}
\left\{
\widehat W^{IS}(\tau,\tau_C-s)-G(s)
\right\}
$$

subject to $s\ge s^{acc}(\tau,\tau_C)$ を解きます。

ここで

$$
G(s)=\frac{\kappa}{2}s^2
$$

です。

### 16.2.1 内点解の一階条件

もし内点解なら

$$
-\frac{\partial \widehat W^{IS}(\tau,\tau_C-s)}{\partial \tau_C}=G'(s)
$$

です。

これは

> transfer によって outsider の実効コストを少し下げたときの限界世界厚生増加

と

> transfer の限界資源費用

を一致させる通常の条件です。

---

## 17. この論文の数理の核心を 5 行でまとめると

1. compatibility は需要を $v \times$ installed base だけ押し上げる。
2. mutual recognition は technology-gap cost $c$ を消すが、participation capacity 由来の $\tau_i$ は残る。
3. そのため outsider は「加盟しても弱い」ことがある。
4. member 国は installed-base gain と competition loss を比べて accession を判断する。
5. だから世界最適の $IS$ が、私的 incentives では実現しないことがある。

---

## 18. 修士1年生として、どこまで追えれば十分か

この論文の数理を読むとき、全部の巨大な多項式を自力で展開できる必要はありません。  
むしろ以下ができれば十分です。

## 18.1 必須

### 18.1.1 需要導出

効用関数から

$$
p=1-Q+vB
$$

を出せること。

### 18.1.2 $SW$ の Cournot 解

5 本の一階条件から $x,y,z,w,t$ を解けること。

### 18.1.3 backward induction

Stage 3, 2, 1 の論理を $\Delta$ の符号で説明できること。

### 18.1.4 threshold lemma

単調性 + crossing condition から一意的 threshold が出ることを理解していること。

## 18.2 できると強い

### 18.2.1 $SU,IS$ の線形系を行列で書く

未知数ベクトルを

$$
(x,y,z,w,t)'
$$

として係数行列を書く練習はかなり有益です。

### 18.2.2 profit identity を自力で確認する

一階条件から $(p-m)q$ を二乗項に落とし直せると、論文の Appendix A がかなり読みやすくなります。

### 18.2.3 比較静学の符号を見る

「$\partial \Delta/\partial \tau_C <0$ の意味は何か」を言葉で説明できるようになると、Section 5 の理解が安定します。

---

## 19. 読み進める順番

この論文は、実際には次の順番で読むのがいちばん楽です。

1. Section 2 で記号を覚える
2. Section 3 の $SW$ を自力で解く
3. Section 3 の $SU,IS$ は「線形系である」と理解する
4. Appendix A で $\widehat W$ の作り方を確認する
5. Section 4 の $\Delta$ の符号条件を backward induction で読む
6. Section 5 と Appendix B で threshold の議論を読む

巨大な分子多項式 $\Xi$ や $\Psi$ を最初から追うと疲れます。  
先に「構造」をつかむほうが大切です。

---

## 20. 練習問題

### 問題 1

$SW$ の一階条件から $x^{SW},y^{SW},z^{SW}$ を自力で導出しなさい。

### 問題 2

なぜ $IS$ では $c$ が消えるのに、$\tau_C$ は消えないのか、経済学的に説明しなさい。

### 問題 3

$\Delta_A^I<0$ で $\Delta_C^I>0$ のとき、何が起こるかを backward induction で説明しなさい。

### 問題 4

$\partial \Delta_C^I/\partial \tau_C<0$ が outsider accession threshold の存在にどう関係するか、Appendix B の Lemma を使って説明しなさい。

### 問題 5

この論文で「world welfare では $IS$ が望ましいのに、equilibrium では $SU$ になる」理由を、installed base と competition の言葉で説明しなさい。

---

## 21. 最後に

この論文の数学は、一見すると多項式が長くて複雑ですが、骨格はかなり標準的です。

- 需要は線形
- 競争は Cournot
- 政府の意思決定は厚生差分の符号比較
- 投資の議論は比較静学と threshold

です。

したがって、修士 1 年の段階では

- 線形 Cournot
- 消費者余剰の計算
- backward induction
- 陰関数定理による threshold

という 4 つの道具として読むのが最も良いです。

この論文の独自性は、難しい数学そのものよりも、

> 「標準に形式上参加すること」と「実際にその標準の市場で強く競争できること」は違う

という経済的発想を、既存の network/compatibility モデルにうまく埋め込んだ点にあります。

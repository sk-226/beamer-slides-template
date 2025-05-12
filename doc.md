# 最小構成 Beamer テンプレート ― 使いかたガイド

> :white_check_mark: **AI-used**  
> 一通り確認してますが、間違ってるかもしれないので注意。

> **対象**  
> - macOS（MacTeX 2024 以上）  
> - LuaLaTeX を使った日本語スライド  
> - 既に LaTeX 自体の文法（数式・表・図の書き方など）は理解している

## 1. 準備とディレクトリ構成

```text
my_presentation/
├─ img/              ← 画像ファイル
├─ main.tex          ← テンプレート本体（先ほどの `main.tex`）
└─ references.bib    ← 参考文献ファイル（自動生成済み）
```

**必須ツール**

|**ツール**|**入手方法**|**用途**|
|---|---|---|
|MacTeX|[https://tug.org/mactex/](https://tug.org/mactex/)|LuaLaTeX, biber 等一式|
|Pygments|brew install pygments|minted のコードハイライト|
|latexmk|MacTeX 同梱|自動コンパイル|
|Git (任意)|brew install git|バージョン管理|

## 2. コンパイル

普通にやる文には `make / make clean` でOK

```
cd my_presentation
latexmk -lualatex -shell-escape main.tex
```

- **-lualatex** … エンジン指定
    
- **-shell-escape** … minted が外部コマンド pygmentize を呼ぶため必須
    
- **-outdir=build** … 生成物を build/ に分離（任意）

```
latexmk -C # 中間ファイルだけ削除。
```

## 3. テンプレート構成の読みかた

|**セクション**|**役割**|**触る場所**|
|---|---|---|
|**メタデータ**|タイトル・著者など|\title{}, \author{}|
|**UI 設定**|余計なヘッダ削除＋ページ番号だけ残す|\setbeamertemplate{footline}{…}|
|**色＆フォント**|見出し黒・太字、ブロック青|\setbeamercolor{}, \setbeamerfont{}|
|**ユーティリティ**|\secframe{} で扉スライド|本文最上部付近|
|**パッケージ**|graphicx, minted, biblatex など|プリアンブル中央|

## 4. スライドの作り方

> [!check] 数式
> `\symbf{}, \sumbfit{}` を使うように！！ for unicode-8
> not `\mathbf{}, \boldsymbol{}`！！

### 4.1 基本スライド

```
\begin{frame}{タイトル}
  文章や図表を書く。
  \begin{itemize}
    \item 箇条書きも黒ビュレット
    \item \blue{青字 macro} や \alert{赤字 macro} で強調
  \end{itemize}
\end{frame}
```

### 4.2 扉スライド（章／節区切り）

```
\section{アルゴリズム}
\secframe{アルゴリズム}
```

- \secframe はフッターもヘッダーも無い真っ白なスライドが 1 枚入る。

### 4.3 コードハイライト

```
\begin{frame}[fragile]{Python 例}
\begin{minted}[fontsize=\footnotesize,linenos]{python}
import numpy as np
print(np.linalg.norm([1, 2, 3]))
\end{minted}
\end{frame}
```

- **コンパイル時**に -shell-escape を忘れない。

### 4.4 定理・証明ブロック

```
\begin{frame}{定理と証明}
  \begin{theorem}[ピタゴラスの定理]
    $c^{2}=a^{2}+b^{2}$。
  \end{theorem}
  \begin{proof}
    幾何学的証明を簡潔に書く。 \qedhere
  \end{proof}
\end{frame}
```

- 色はプレアンブルで一括指定済み。

## 5. 参考文献の付けかた

### 5.1 .bib ファイルの更新

references.bib に文献を追加するだけ。たとえば：

```
@article{smith2023,
  author  = {Smith, John},
  title   = {Efficient ABC Method},
  journal = {Journal of Awesome Research},
  year    = {2023},
}
```

### 5.2 本文で引用

```
先行研究として \textcite{smith2023} を参照。
```

- \textcite{} … 著者名を文中に含める
- \parencite{} … 括弧内に [Smith 2023]

### 5.3 参考文献スライド

テンプレに既に用意済み：

```
\begin{frame}[allowframebreaks]{参考文献}
  \printbibliography
\end{frame}
```

- allowframebreaks を付けると文献が多い場合に自動改ページ。

> **biber が走らない場合**
> TeXShop や VS Code の場合は一度 latexmk を止めて手動で biber build/main を実行→再度 latexmk。

## 6. 表と数式のサンプル

- **表**：booktabs 済み三線表 → \begin{tabular}...\end{tabular}
- **数式**：通常の 内で OK。特に Beamer 固有の制限なし。

```
\begin{frame}{数式例}
  正規方程式：$A^{\mathsf T}A\,\boldsymbol{x}=A^{\mathsf T}\boldsymbol{b}$
\end{frame}
```

## 7. カスタマイズのヒント

|**やりたいこと**|**方法**|
|---|---|
|**ダークモード風**|\setbeamercolor{background canvas}{bg=black} と文字色を白系へ|
|**ページ番号＋企業ロゴ**|\setbeamertemplate{footline}{\insertframenumber\hfill\includegraphics[height=8pt]{logo.pdf}}|
|**テーマ変更**|例：\usetheme{Madrid}。消したい帯は同じ 3 行で空テンプレにする|
|**スライド毎に画像全面背景**|\begin{frame}[plain] \includegraphics[width=\paperwidth]{bg.pdf} \end{frame}|

## 8. トラブルシューティング

|**症状**|**原因**|**対処**|
|---|---|---|
|Undefined control sequence \captionof|caption パッケージ未読込|テンプレでは読み込済み。自前で削った場合は復活させる|
|minted が動かない|-shell-escape or pygmentize 未インストール|ターミナルで pygmentize -V を確認|
|Package biblatex Error: Biber reported warnings|biber 未インストール or パス不整合|which biber で確認、MacTeX を再インストール|

## 9. よくある運用フロー

1. **main.tex** のメタデータ・章立てだけ編集
2. 画像を img/ などに追加 → \includegraphics
3. コード片を minted で挿入
4. .bib を Zotero などで書き出し、latexmk -lualatex -shell-escape main.tex
5. PDF をチェック、Git にコミット

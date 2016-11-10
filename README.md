# Financial Condition Visualizer

企業の財務状況(バランスシート、損益計算書の代表指標の具合)を可視化するプログラムです。

## Description

売上、営業利益、純利益、流動比率、レバレッジ比率、ROAを可視化するものです。

***DEMO:***
まずはJTの状況を表す、こちらの動画をご覧ください。
![test.gif](https://qiita-image-store.s3.amazonaws.com/0/108483/44704291-87e0-d18f-246a-bcda7564b4cc.gif)

雑に解説すると、

- 一番外側の大きな球が売上を、2番目に大きな球が営業利益を、そして一番小さい球が純利益を、その体積で表しています。
    - (JTの営業利益と純利益はかなり近いため、内側の2つの球はほとんど重なって見えます
- 全体の色が赤いほど借金体質です。(流動比率)
    - JTはかなり青くて、これは返済が近い借金に対して、お金を十分に持っているってことです。返済能力高い。
- 球の回転スピードは勝負体質的なものを表しています。(レバレッジ比率)
    - JTは結構遅め。つまり保守的というか、身の丈にあった投資をしているというか、十分な資金があるので投資のために借り入れをする必要が少ないというか、そういう感じです。
- ドットの密度は、どれだけ効率良く会社の資産を売上に変えているか、を表しています。(ROA)
    - JTはけっこう効率いいんじゃないかな。(雑)

## Requirement
- Processing 3

- FinAnalysis_JT_2015
    - GifAnimeWriter
        - http://3846masa.hatenablog.jp/entry/oldmt-processing-animationgif
        - こちらで公開されているものを使わせていただきました！

## Usage

1. Usage
2. Usage
3. Usage

## Installation

## Author

[@lucas29](https://github.com/lucas29)

## License

# NASDAQ100CSV作成

イザナミで取り込める形式の NASDAQ100 基準価額CSVを作成する PowerShell スクリプトです。

三菱UFJアセットマネジメントの eMAXIS シリーズ基準価額CSVを取得し、`ｅＭＡＸＩＳ ＮＡＳＤＡＱ１００インデックス` の基準価額をイザナミ向けの日足CSVに変換します。

## 対象ユーザー

- イザナミで NASDAQ100 の基準価額データを使いたい方
- 手元でCSVを更新して、イザナミに取り込みたい方

## 必要なもの

- Windows
- PowerShell
- インターネット接続

## 使い方

PowerShell でこのフォルダに移動して実行します。

```powershell
.\NASDAQ100CSV作成.ps1
```

実行すると、同じフォルダに次のファイルが作成されます。

| ファイル | 内容 |
| --- | --- |
| `emaxis_all.csv` | 取得した元CSV |
| `nasdaq100_raw.csv` | 日付と基準価額だけの確認用CSV |
| `nasdaq100_izanami.csv` | イザナミ取り込み用CSV |

## イザナミへの取り込み

`nasdaq100_izanami.csv` をイザナミの外部CSVデータとして取り込んでください。

CSV形式は次の通りです。

```csv
Date,Open,High,Low,Close,Volume
2021/01/29,10000,10000,10000,10000,0
```

基準価額のため、`Open`、`High`、`Low`、`Close` は同じ値を出力します。`Volume` は `0` です。

## 注意

- `nasdaq100_raw.csv` や `nasdaq100_izanami.csv` を Excel などで開いたまま実行すると、ファイルロックで書き込みに失敗します。
- 取得元CSVの列構成が変わった場合、正しく変換できないことがあります。
- 投資判断はご自身の責任で行ってください。
- このスクリプトはイザナミ公式ツールではありません。

## ライセンス

CC0 1.0 Universal

自由にコピー、改変、再配布、商用利用できます。

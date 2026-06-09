$ErrorActionPreference = "Stop"

$allFile = "emaxis_all.csv"
$rawFile = "nasdaq100_raw.csv"
$outFile = "nasdaq100_izanami.csv"

$url = "https://emaxis.am.mufg.jp/fund_file/setteirai/emaxis.csv"
$fundName = "ｅＭＡＸＩＳ ＮＡＳＤＡＱ１００インデックス"

try {
    [void][Text.Encoding]::RegisterProvider([Text.CodePagesEncodingProvider]::Instance)
} catch {
}

$encoding = [Text.Encoding]::GetEncoding(932)

Invoke-WebRequest `
    -Uri $url `
    -OutFile $allFile `
    -Headers @{ "User-Agent" = "Mozilla/5.0" }

$lines = [IO.File]::ReadAllLines((Resolve-Path $allFile), $encoding)

if ($lines.Count -lt 3) {
    throw "取得CSVの行数が不足しています。"
}

$headers = $lines[0].Split(",")
$dateCol = [Array]::IndexOf($headers, $fundName)

if ($dateCol -lt 0) {
    throw "対象ファンドが見つかりません: $fundName"
}

$priceCol = $dateCol + 1

$raw = @()
$raw += "Date,Price"

$out = @()
$out += "Date,Open,High,Low,Close,Volume"

$count = 0

for ($i = 2; $i -lt $lines.Count; $i++) {
    $cols = $lines[$i].Split(",")

    if ($cols.Count -le $priceCol) {
        continue
    }

    $date = $cols[$dateCol].Trim()
    $price = $cols[$priceCol].Trim()

    if ($date -notmatch "^\d{4}/\d{2}/\d{2}$") {
        continue
    }

    if ($price -notmatch "^\d+$") {
        continue
    }

    $raw += ("{0},{1}" -f $date, $price)
    $out += ("{0},{1},{1},{1},{1},0" -f $date, $price)

    $count++
}

if ($count -eq 0) {
    throw "有効な時系列データが見つかりません。"
}

[IO.File]::WriteAllLines((Join-Path (Get-Location) $rawFile), $raw, $encoding)
[IO.File]::WriteAllLines((Join-Path (Get-Location) $outFile), $out, $encoding)

Write-Host "Done."
Write-Host ("Fund: {0}" -f $fundName)
Write-Host ("Count: {0}" -f $count)
Write-Host $rawFile
Write-Host $outFile

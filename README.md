# PNGファイルをDDSに変換するスクリプト(BveTs向け)
テクスチャのpngファイルをdds形式に変換して、ロード時間とメモリ削減をしよう！
windowsにも対応しました！
## 事前準備
- [Bat] imagemagickを[こちら](https://www.imagemagick.org/script/download.php#windows)からダウンロードして、インストールしてください
- [Bash] imagemagickをbrew等でインストールしてください
## 使い方(Windows)
png2dds.batをdds化したいシナリオファイルに設置してください。
Scenarios直下に置くと車両ファイルまで変換されるので注意してください。

1. コマンドプロンプトを起動してpng2dds.batのある場所まで移動します
``` cmd
$ cd /d D:\User\USERNEME\GAMES\BveTs6\Scenarios\Tn_E235\ROUTENAME\
```
2. オプションを引数として与えて起動します
``` cmd
$ png2dds.bat /c /d /r
```
|  オプション  |  説明  |
| ---- | ---- |
|  /c  |  pngをddsに変換する  |
|  /d  |  ddsに変換後,pngファイルを削除する  |
|  /r  |  .xファイルのpngをddsに置換する  |
おしまい

---
## 使い方(Linux)
png2dds.shを任意の場所にコピーしてください．例としてDesktopに配置します．
路線データ内のストラクチャをDDS化します．この際に，車両データもDDS化しないように注意してください．
1. bashコマンドでpng2dds.shを実行します．第一引数に，ストラクチャファイルのパスを指定します．
```shell
$ bash png2dds.sh ../Documents/BveTs/Scenarios/Data/Route/Stractures
```
2. 変換するか選択します．
```shell
Convert PNG to DDS? (Y/n)
Y
```
3. DDSの圧縮形式を指定します．未指定の場合はdxt5が選択されます．
```shell
Option Select
Selection 　 Compression
-----------------------
  0           none
  1           dxt1
* 2           dxt5
Press <enter> to keep the current choice[*], or type selection number:
2
```
4. PNGファイルを削除するか選択します．
```shell
Remove PNG images? (Y/n)
n
```
5. xファイル内のpng画像指定をdds画像指定に変更するか選択します．
```shell
Replace PNG to X in .X file? (Y/n)
Y
```
おしまい

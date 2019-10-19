# PNGファイルをDDSに変換するスクリプト(BveTs向け)
#### これはLinuxコマンドが使える環境向けです．標準のwindowsでは動作させることができません．WSLを使うなどしてください．WSL使うぐらいならWindowsで動くやつ使うだろうけどね．
事前準備
- imagemagickをbrew等でインストールしてください
## 使い方
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

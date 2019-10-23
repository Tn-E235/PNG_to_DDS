#!/bin/sh
if [ $# -lt 1 ]; then
    echo "[ERROR]Argument error"
    exit 1
fi

cd -- "$1"
if [ $? -gt 0 ]; then
    echo "[ERROR]Illegal path"
    exit 1
fi
find ./ -iname '*.png' > list.txt
pwd

echo "Convert PNG to DDS? (Y/n)"
read ans
case $ans in
    "y") echo "Convert" ;;
    "Y") echo "Convert" ;;
    *) echo "End"
    exit 1
esac

echo "Option Select"
echo "Selection 　 Compression"
echo "-----------------------"
echo "  0           none"
echo "  1           dxt1"
echo "* 2           dxt5"
echo "Press <enter> to keep the current choice[*], or type selection number:"
read ans

case $ans in
    "0") echo "Compression:none"
         Comp="none" ;;
    "1") echo "Compression:dxt1"
         Comp="dxt1" ;;
    "2") echo "Compression:dxt5"
         Comp="dxt5" ;;
    *)   echo "Compression:dxt5"
         Comp="none" ;;
esac

File=list.txt
IFS='
'
for i in $(cat $File)
do
    echo "---------------------"
    echo "Target File: ${i}"
    filename=${i%.png}
    echo "${filename}";
    convert "${filename}.png" -define dds:compression="$Comp",dds:cluster-fit=true,dds:weight-by-alpha=true,dds:fast-mipmaps=true "${filename}.dds"
done

echo "Remove PNG images? (Y/n)"
read ans
case $ans in
    "y") echo "Remove."
        find ./ -iname '*.png' -exec rm -- {} + ;;
    "Y") echo "Remove."
        find ./ -iname '*.png' -exec rm -- {} + ;;
    *) echo "" ;;
esac

echo "Replace PNG to X in .X file? (Y/n)"
read ans
case $ans in
    "y") echo "Replace."
        find ./ -type f -exec sed -i 's/.png/.dds/ig' -- {} \;
        ;;
    "Y") echo "Replace."
        find ./ -type f -exec sed -i 's/.png/.dds/ig' -- {} \;
        ;;
    *) echo "" ;;
esac
rm list.txt
echo "FINISHED!!!"

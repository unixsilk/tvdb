#!/usr/bin/sh

i=0
r=0

echo "enter tvdbid"
read -r tvdbid
mkdir tmp
curl -Ls -o /dev/null -w %{url_effective} https://www.thetvdb.com/dereferrer/series/"$tvdbid" | sed 's,$,\/allseasons\/official,' | xargs curl -s | grep -o "S[0-99][0-99]E[0-9999][0-9999]" > tmp/data.txt
curl -Ls -o /dev/null -w %{url_effective} https://www.thetvdb.com/dereferrer/series/"$tvdbid" | sed 's,$,\/allseasons\/official,' > tmp/url.txt

python << END

import re
import sys
with open('tmp/url.txt') as f:
    x = f.readlines()
s = ('"{}"'.format(x)) 
regex = re.findall("(?s)series\/(.*)\/allseasons\/official", s)

sys.stdout = open('tmp/finalname.txt', "w")
for i in range(len(regex)):
 a = (regex[i])
 a = (a.title()).replace("-", " ")
 print(a)
 sys.stdout.close()

END

cw=$(wc -l < tmp/data.txt)
while [ "$i" -lt "$cw" ]
do
	echo "-" "$(cat tmp/finalname.txt)" "-" "tvdbid-""$tvdbid" >> tmp/names.txt   
		i=$((i+1))
done

paste -d " " tmp/data.txt tmp/names.txt > tmp/com.txt
echo "$(cat tmp/finalname.txt)" "-" "tvdbid-""$tvdbid" > tmp/bass.txt

find "$(cd "$1"; pwd)" | grep -i '.webm\|.mkv\|.flv\|.vob\|.ogv\|.ogg\|.mng\|.mov\|.avi\|.wmv\|.yuv\|.asf\|.amv\|.mp4\|.m4p\|.m4v\|.mpg\|.mp2\|.mpeg\|.mpe\|.mpv\|.m4v\|.svi\|.3gp\|.3g2\|.nsv\|.flv\|.f4v\|.f4p\|.f4a\|.f4b' | grep -i "$1" | sort -V > tmp/tokyo.txt 
xw=$(wc -l < tmp/tokyo.txt)
if [ "$cw" -ne "$xw" ]
then
	echo "Your Mediathek's episodes count doesnt match thetvdb.com."
	echo You have "$xw" episodes, but should have "$cw"
	echo "Exit."	
	exit
fi

sed 's/.*\.//' tmp/tokyo.txt  > tmp/extension.txt
paste -d "." tmp/com.txt tmp/extension.txt > tmp/mari.txt 
mkdir "$(cat tmp/bass.txt)"
danger="$(cat tmp/bass.txt)"

while [ "$r" -lt "$cw" ]
do
 readlink -f "$danger" >> tmp/tell.txt
 r=$((r+1))
done

sed 's/\..*//g' tmp/mari.txt | sed 's/E...[0-999]//g' | sed 's/E..[0-999]//g' | sed 's/E[0-999][0-999]//g' | sed '/^$/d' > tmp/more.txt
paste -d "/" tmp/tell.txt tmp/more.txt > tmp/kissme.txt 
paste -d "/" tmp/kissme.txt tmp/mari.txt > tmp/oxi.txt
paste -d "@" tmp/tokyo.txt tmp/oxi.txt > tmp/titan.txt 
try=$(grep -c "^S*E01" tmp/data.txt)

#vicky=$(cat tmp/bass.txt)
#export vicky

export vicky=$(cat tmp/bass.txt)


seq -w 01 "$try" > tmp/scream.txt
cd "$vicky" || exit
<../tmp/scream.txt xargs -I{} -P1 bash -c 'mkdir S"{}"\ "-"\ "$vicky"'
cd .. || exit

while IFS=@ read -r orig target; do
    mv "$orig" "$target"
done < tmp/titan.txt

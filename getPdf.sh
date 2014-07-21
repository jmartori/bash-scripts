#!/bin/bash



current=$(date +%s)
www="$1"
mkdir "slides-$current/"
page=1

wget --quiet -O slides-$current/file.tmp $www
cat slides-$current/file.tmp | sed 's/data-url/\n/g'| grep image.slidesharecdn  | awk -F"\"" '{print $6}' | grep "http://" | awk -F"?" '{print $1}'  > slides-$current/image.list

while read wwwp
do
	wget --quiet -O slides-$current/page-$page.jpg $wwwp
	echo $page
	let page=$page+1
	sleep 0.01
done < slides-$current/image.list

rm slides-$current/file.tmp slides-$current/image.list
convert slides-$current/* output-$current.pdf


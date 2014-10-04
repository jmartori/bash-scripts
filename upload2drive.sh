#!/bin/bash

LOCAL_FOLDER="/srv/torrent/complete/"

find $LOCAL_FOLDER -name "*.mp4" -o -name "*.avi" -o -name "*.mkv" -o -name "*.srt" > /tmp/movies.lst

while read var
do
        tmp=$( echo "$var" | awk -F '.' '{$NF="";print $0}' | sed 's/ /_/g' )
        tmp2=$(echo ${tmp%?})
        name=$(echo $tmp2 | awk -F "/" '{print $NF}')
        ext=$(echo $var | awk -F '.' '{print $NF}')

        mv "$var" "/tmp/$name.$ext"


        google docs upload "/tmp/$name.$ext"
        #echo "$name.$ext"

        echo "$(date): $name.$ext - $(sha1sum "/tmp/$name.$ext" | awk '{print $1}')"
      	rm "/tmp/$name.$ext"

done < /tmp/movies.lst


rm /tmp/movies.lst
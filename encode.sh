#!/bin/bash

savefolder=/opt/files/converted

for i in *.cue; do
cue_file=$i
ntrack=$(cueprint -d '%N' "$cue_file")
trackno=1

file=`basename "$i" .cue`

if ! [ -d "$file" ]; then
    mkdir "$file"
fi

ntrack=$(cueprint -d '%N' "$cue_file")
trackno=1
tracknow=`ls "$file"|wc -l`

if [ $tracknow -ne $ntrack ]; then
    cuebreakpoints "$cue_file" | shnsplit -O always -a "$file/" -o ape "$file.ape"
fi

j=1

    for j in `ls "$file"`; do
        title=`cueprint -n $j -t "%t" "$cue_file"|tr -d "\'"`
        album=`cueprint -n $j -t "%T" "$cue_file"`
        artist=`cueprint -n $j -t "%p" "$cue_file"`
        genre=`cueprint -n $j -t "%g" "$cue_file"`
        tracknumber=`cueprint -n $j -t "%n" "$cue_file"`/`cueprint -n $j -t "%N" "$cue_file"`

        ffmpeg -i "$file/$j" -strict -2 -acodec libfaac -metadata title=\""$title"\" -metadata album=\""$album"\" -metadata artist=\""$artist"\" -metadata genre=\""$genre"\" -metadata track=\""$tracknumber"\" -ac 2 -ar 44100 -ab 256k "$savefolder/$artist/$artist - $title.mp4"
    done
done
#!/bin/bash
# parameter 1: video $1
# parameter 2: .ass $2
# parameter 3: name of the output file

set -e

#change this please :-)
crc_calc="crc32"

file="$3_first.mkv"

mkvmerge -i "$1"
read -p "Video track ID: " var_vidid
read -p "Audio track ID: " var_audioid
#hope there's only one
read -p "Subtitle track ID: " var_subid

read -p "Audio track language: " -e -i jpn var_audiolanguage

mkvmerge -o "$file" --default-track $var_vidid:yes --forced-track $var_vidid:no --language $var_audioid:$var_audiolanguage --default-track $var_audioid:yes --forced-track $var_audioid:no --audio-tracks $var_audioid --video-tracks $var_vidid --no-subtitles --no-track-tags --no-global-tags "$1" --no-video --no-audio --no-track-tags --no-global-tags --no-chapters "$2"

mkvmerge -i "$file"
read -p "Video track ID: " var_vidid
read -p "Audio track ID: " var_audioid
#hope there's only one
read -p "Subtitle track ID: " var_subid

read -p "Subtitle track name: " -e -i Français var_subname
read -p "Subtitle track language: " -e -i fre var_sublanguage

var_vidid=$((var_vidid+1))
var_audioid=$((var_audioid+1))
var_subid=$((var_subid+1))

mkvpropedit "$file" --edit track:@$var_audioid --set language=$var_audiolanguage --edit track:@$var_subid --set name=$var_subname --set language=$var_sublanguage --set flag-default=1

read -p "Do you have a file chapters.xml [y/N] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    mkvpropedit --chapters "chapters.xml" "$file"
fi

read -p "Resolution of the video: " var_videoreso
read -p "Subtitle group: " fansub_name
read -p "Subtitle Language: " -e -i VOSTFR language_name
if [ -n "$language_name" ]; then
    language_name="$language_name "
fi

read -p "Translated by $fansub_name [y/N] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    read -p "Translated by: " var_tslt
    fansub_name="$var_tslt & $fansub_name"
fi

var_title="[$fansub_name] $3"
mkvpropedit "$file" --edit info --set "title=$var_title" --edit track:a1

$crc_calc "$file"
read -p "CRC is: " var_crc

file_end="[$fansub_name] $3 $language_name[$var_videoreso] [$var_crc].mkv"
mv "$file" "$file_end"

echo "END!"

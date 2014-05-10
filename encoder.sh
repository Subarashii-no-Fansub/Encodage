#!/bin/sh
# paramètre 1 : video $1
# paramètre 2 : .ass $2
# paramètre 3 : nom du fichier de sorti

set -e

file="$3_first.mkv"
file_end="$3.mkv"

chmod 644 "$1"

mkvmerge -i "$1"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

mkvmerge -o "$file"  --default-track $var_idvid:yes --forced-track $var_idvid:no --language $var_idson:jpn --default-track $var_idson:yes --forced-track $var_idson:no --audio-tracks $var_idson --video-tracks $var_idvid --no-subtitles --no-track-tags --no-global-tags "$1" --forced-track $var_idvid:no --subtitle-tracks $var_idvid --no-video --no-audio --no-track-tags --no-global-tags --no-chapters "$2"

mkvmerge -i "$file"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

chmod 644 "$file"
mkvmerge -o "$file_end" --default-track $var_idvid:yes --forced-track $var_idvid:no --language $var_idson:jpn --default-track $var_idson:yes --forced-track $var_idson:no --language $var_idss:fre --track-name $var_idss:"Subarashii no Fansub" --default-track $var_idss:yes --forced-track $var_idss:no --audio-tracks $var_idson --video-tracks $var_idvid --subtitle-tracks $var_idss  --no-track-tags --no-global-tags "$file"
chmod 644 "$file_end"
rm "$file"

echo "Le CRC de ce fichier est : " && crc32 "$file_end"

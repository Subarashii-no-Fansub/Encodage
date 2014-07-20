#!/bin/bash
# paramètre 1 : video $1
# paramètre 2 : sous-titre $2
# paramètre 3 : police $3…

set -e

fullfilename=$(basename "$1")
filename=${fullfilename%.*}

file="$filename first.mkv"

#change this please :-)
crc_calc="crc32"

chmod 644 "$1"

mkvmerge -i "$1"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson

mkvmerge -o "$file" --default-track $var_idvid:yes --forced-track $var_idvid:no --language $var_idson:jpn --default-track $var_idson:yes --forced-track $var_idson:no --audio-tracks $var_idson --video-tracks $var_idvid --no-subtitles --no-track-tags --no-global-tags "$1" --no-video --no-audio --no-track-tags --no-global-tags --no-chapters "$2"

mkvmerge -i "$file"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

nombrearg="$#"

commande=""

for ((i=3 ; $nombrearg+1-$i ; i++))
do
	fullfilename=$(basename "${!i}")
	attachemine=$(file --brief --mime-type "${!i}")
	mkvpropedit "$file" --attachment-name "$fullfilename" --attachment-mime-type "$attachemine" --add-attachment "${!i}"

done


$crc_calc "$file"
read -p "Le CRC de ce fichier est : " var_crc

fullfilename=$(basename "$1")
filename=${fullfilename%.*}

file_end="$filename [$var_crc].mkv"
mv "$file" "$file_end"

read -p "Créer un .torrent ? [O/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Oo]$ ]]
then
    transmission-create --tracker http://open.nyaatorrents.info:6544/announce "$file_end"
    chmod 644 "$file_end.torrent"
fi

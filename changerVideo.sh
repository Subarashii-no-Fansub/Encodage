#!/bin/bash
# paramètre 1 : video $1
# paramètre 2 : vidéo $2
# paramètre 3 : titre $3

set -e

file="$3_fin.mkv"

chmod 644 "$1"
echo "FICHIER de fin ${basename $1}"
mkvmerge -i "$1"

read -p "Numéro de la vidéo : " var_idvid_un
read -p "Numéro du son : " var_idson_un
read -p "Numéro des sous-titres : " var_idss_un

chmod 644 "$2"
echo "FICHIER dans lequel récupérer vidéo ${basename $2}"
mkvmerge -i "$2"

read -p "Numéro de la vidéo : " var_idvid_deux
read -p "Numéro du son : " var_idson_deux
read -p "Numéro des sous-titres : " var_idss_deux

mkvmerge -o "$file" --default-track $var_idss_un:yes --forced-track $var_idss_un:no --subtitle-tracks $var_idss_un --no-video --no-audio --no-global-tags --no-chapters "$1" --forced-track $var_idvid_deux:no --forced-track $var_idson_deux:no --audio-tracks $var_idson_deux --video-tracks $var_idvid_deux --no-attachments --no-subtitles --no-track-tags -no-global-tags "$2"

echo "FINI !"

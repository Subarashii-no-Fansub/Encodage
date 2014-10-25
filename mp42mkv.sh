#!/bin/sh
# paramètre 1 : video $1
# paramètre 2 : .ass $2
# paramètre 3 : nom du fichier de sorti

set -e

file="$3_first.mkv"

#change this please :-)
crc_calc="crc32"

chmod 644 "$1"

mkvmerge -i "$1"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

mkvmerge -o "$file" --forced-track $var_idvid:no --forced-track $var_idson:no --audio-tracks $var_idson --video-tracks $var_idvid --no-subtitles --no-track-tags --no-global-tags --no-chapters "$1" --forced-track $var_idvid:no --subtitle-tracks 0 --no-video --no-audio --no-track-tags --no-global-tags --no-chapters "$2"

mkvmerge -i "$file"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

chmod 644 "$file"

var_idvid=$((var_idvid+1))
var_idson=$((var_idson+1))
var_idss=$((var_idss+1))

mkvpropedit "$file" --edit track:@$var_idson --set language=jpn --edit track:@$var_idss --set name="Français" --set language=fre --set flag-default=1

$crc_calc "$file"
read -p "Le CRC de ce fichier est : " var_crc
read -p "Qualité de la vidéo : " var_qual
read -p "Fansub : " fansub_name
read -p "Traduit par $fansub_name [O/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Oo]$ ]]
then
    read -p "Traducteur : " var_tslt
    fansub_name="$var_tslt & $fansub_name"
fi

file_end="[$fansub_name] $3 VOSTFR [$var_qual][$var_crc].mkv"
mv "$file" "$file_end"

echo "FINI !"

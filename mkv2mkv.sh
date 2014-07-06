#!/bin/sh
# paramètre 1 : video $1
# paramètre 2 : .ass $2
# paramètre 3 : nom du fichier de sorti

set -e

file="$3_first.mkv"
file_end="$3.mkv"

#change this please :-)
crc_calc="crc32"
fansub_name="SnF"

chmod 644 "$1"

mkvmerge -i "$1"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

mkvmerge -o "$file" --default-track $var_idvid:yes --forced-track $var_idvid:no --language $var_idson:jpn --default-track $var_idson:yes --forced-track $var_idson:no --audio-tracks $var_idson --video-tracks $var_idvid --no-subtitles --no-track-tags --no-global-tags "$1" --no-video --no-audio --no-track-tags --no-global-tags --no-chapters "$2"

mkvmerge -i "$file"
read -p "Numéro de la vidéo : " var_idvid
read -p "Numéro du son : " var_idson
read -p "Numéro des sous-titres : " var_idss

chmod 644 "$file"
mkvmerge -o "$file_end" --default-track $var_idvid:yes --forced-track $var_idvid:no --language $var_idson:jpn --default-track $var_idson:yes --forced-track $var_idson:no --language $var_idss:fre --track-name $var_idss:"Français" --default-track $var_idss:yes --forced-track $var_idss:no --audio-tracks $var_idson --video-tracks $var_idvid --subtitle-tracks $var_idss  --no-track-tags --no-global-tags "$file"
chmod 644 "$file_end"
rm "$file"

$crc_calc "$file_end"
read -p "Le CRC de ce fichier est : " var_crc
read -p "Qualité de la vidéo : " var_qual
read -p "Traduit par $fansub_name [O/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Oo]$ ]]
then
    read -p "Traducteur : " var_tslt
    fansub_name="$var_tslt-$fansub_name"
fi

file="[$fansub_name] $3 VOSTFR [$var_qual][$var_crc].mkv"
mv "$file_end" "$file"

read -p "Créer un .torrent ? [O/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Oo]$ ]]
then
    transmission-create -t http://open.nyaatorrents.info:6544/announce "$file"
    chmod 644 "$file.torrent"
fi

echo "FINI !"

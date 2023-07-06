#!/bin/bash

####################################
##   Script made by Raymii.org    ##
####################################


padself=`pwd`/`basename $0`

function catch_errors() {
   zenity --question --text="There is something wrong. Do you want to quit or restart the app?" --cancel-label="Quit" --ok-label="Restart";
   [ "$?" = "0" ] && ( bash -c $padself & );
   exit 0;
}

function func_error2() {
    echo `date +%h:%m:%s`
}

trap catch_errors ERR;

mapvraag=0
titel="EasyConverter v0.3a"

zenity --info --text="Hi, I'm <b>$titel</b> \nI will help you with converting audio files to another format. \n \nIn the next window, please select the folder which has the audio files." --title="$titel"

mapvraag=$(zenity --file-selection --directory --title="$titel");
 

mapcheck=$(zenity  --question --cancel-label="Nope" --ok-label="Yeah" --text="Is <b>$mapvraag</b> the correct folder?" --title="$titel");
 

vanform=$(zenity  --list  --text "Which filetype do you want to convert?" --radiolist  --column "Choose" --column "Original Format" TRUE flac FALSE ogg FALSE wav FALSE mp3);

formaat=$(zenity  --list  --text "And what should they become?" --radiolist  --column "Choose" --column "Converted Format" TRUE mp3 FALSE ogg FALSE wav FALSE flac);
if [ $vanform = $formaat ]; then
    zenity --error --text="You choose the same input and output format \nI can't convert the files if you do that. \nLets restart." --title="$titel"
    #bash -c $padself &
    return 1;
    exit
fi

finalcheck=$(zenity --question --cancel-label="Don't" --ok-label="Lets Rock Baby!" --text="We're going to convert all files in: <b>$mapvraag</b> to <b><i>$formaat</i></b>. Last check, Do or Don't?" --title="$titel")

trap func_error2 ERR;

pushd "$mapvraag"
for i in *.$vanform; do
        mkdir -p "$mapvraag/converted/$formaat/"
    ffmpeg -y -i "$i" "$mapvraag/converted/$formaat/$i.$formaat" 2>&1 | zenity --progress --text="Converting: <b>$i</b>" --title="$titel" --auto-close --pulsate
        echo $i gedaan
done

zenity --info --text="Done! \nI've saved the converted files in this folder: <b>$mapvraag/converted/$formaat</b> \nThis little script is made by: <b>Raymii.org</b>" --title="$titel";
popd
echo Done

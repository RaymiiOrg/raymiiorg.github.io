#!/bin/bash

####################################
##   Script made by Raymii.org    ##
####################################

# V0.4 new features:
# Extension select before folder.
# Filter on extension
# Check if files exist in folder.
# Added .flv to input format
# Added .aac to input/output format
# Quality selector for ffmpeg
# rename addes to remove the original extension.
# removed folder check.
# added nautilus open when converting finished.


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
titel="EasyConverter v0.4e"
KBs=128;
FGOED=1;

zenity --info --text="Hi, I'm <b>$titel</b> \nI will help you with converting files to another format. \n \nIn the next window, please select the format of the files. After that please select the folder which has the audio files." --title="$titel"

vanform=$(zenity  --list --title="Select a file extension" --height=270 --text "Which filetype do you want to convert?" --radiolist  --column "Choose" --column "Original Format" TRUE flac FALSE ogg FALSE wav FALSE mp3 FALSE aac FALSE flv);

mapvraag=$(zenity --file-selection --directory --title="Please select a folder with $vanform files." --file-filter="*.$vanform" );

pushd "$mapvraag"
for f in ./*.$vanform; do
        test -f "$f" || continue
        echo "$f bestaat, mooi zo.";
        FGOED=2;
    done    
popd

if [ $FGOED == 1 ]; then
	zenity --error --text="Oops, the filetype you selected is not found in the folder you selected. \nPlease try again." --title="$titel";
	return 1;
fi

formaat=$(zenity  --list --height=270 --text "And what should they become?" --radiolist  --column "Choose" --column "Converted Format" TRUE mp3 FALSE ogg FALSE wav FALSE flac FALSE aac);
if [ $vanform = $formaat ]; then
    zenity --error --text="You choose the same input and output format \nI can't convert the files if you do that. \nLets restart." --title="$titel"
    return 1;
    exit
fi

KBs=$(zenity  --list --height=380 --text "What output quality you want me to tell ffmpeg?\n \n<i>64k</i>: \nSmall files\nLow quality \n<i>320k</i>: \nBig files\nHigh quality.)" --radiolist  --column "Choose" --column "kbps" TRUE 64 FALSE 96 FALSE 128 FALSE 196 FALSE 256 FALSE 320);

finalcheck=$(zenity --question --cancel-label="Don't" --ok-label="Lets Rock Baby!" --text="We're going to convert all files in: <b>$mapvraag</b> to <b><i>$formaat</i></b> at <i><b>$KBs</b> kb/s</i>. Last check, Do or Don't?" --title="$titel")

trap func_error2 ERR;

pushd "$mapvraag"
for i in *.$vanform; do
        mkdir -p "$mapvraag/converted/$formaat/"
        ffmpeg -ab $KBs"k" -y -i "$i" "$mapvraag/converted/$formaat/$i.$formaat" 2>&1 | zenity --progress --text="Converting: <b>$i</b> from <b>$vanform</b> to <b>$formaat</b> at <b>$KBs</b> kb/s" --title="$titel" --auto-close --pulsate
        rename .$vanform.$formaat .$formaat "$mapvraag/converted/$formaat/"*.$vanform.$formaat 
        echo $i gedaan

done

zenity --question --cancel-label="Nope, just quit." --ok-label="Yes, open it." --text="Done! \nI've saved the converted files in this folder: <b>$mapvraag/converted/$formaat</b>. \n \n Would you like me to try and open Nautilus in the output folder? \n \n \nThis little script is made by: <b>Raymii.org</b>." --title="$titel";
[ "$?" = "0" ] && nautilus --no-desktop "./converted/$formaat";
popd
echo Done

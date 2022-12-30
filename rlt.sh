#!/bin/sh
# WIP
# Provides an interface to manipulate TeX files
srcDir="./src"
skelDir="./skel"
skelSubfile="$skelDir/subfile"

numOfFolder=$(find ./src/* -maxdepth 0 -type d | wc -l)
newSrcDirs=$(($numOfFolder + 1))

new_subfile() {
    temp="$newSrcDirs"
    temp="${temp}-$1"
    escapedDir="\.\/${temp}\/$1"
    cp -r "$skelSubfile" "./src"
    mv "$srcDir/subfile" "$srcDir/$temp"
    mv "$srcDir/$temp/subfile.tex" "$srcDir/$temp/$1.tex"
    # https://stackoverflow.com/questions/37909388/append-line-after-last-match-with-sed
    sed -i '/\\subfile[^\n]*/,$!b;//{x;//p;g};//!H;$!d;x;s//&\n\\subfile{{'"$escapedDir"'}}/' "$srcDir/document.tex"
    echo "New subfile with name $3 has been created in $srcDir/$temp and the subfile has been added to your document.tex"
}
remove_subfile() {
    target="./$srcDir/$1"
    escapedTarget="\.\/$srcDir\/$1"
    echo "Deleting..."
    rm -r "$target"
    sed -i '/\\subfile{{'"$escapedTarget"'}}/d' "$srcDir/document.tex"
    echo "The subfile $2 has been successfully removed from 'document.tex' and deleted from $srcDir"
}
###
#   Main script
###
if [ "$1" = "new" ]; then
    if [ -z "$2" ] || [ -z "$3" ]; then
        echo "No sub-command provided. Usage is 'new subfile <name>'"
    fi

    if [ "$2" = "subfile" ] && [ -n "$3" ]; then
        new_subfile "$3"
    fi

elif [ "$1" = "rm" ]; then
    if [ -n "$2" ]; then
        echo "Directory ./src/$2 not found, neither was ./src/$2.tex"
    else
        remove_subfile "$2"
    fi
    # rm -r "./${srcDir:?}/$2"
elif [ "$1" = "build" ]; then
    nix build
fi

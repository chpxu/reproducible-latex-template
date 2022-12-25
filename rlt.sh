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
    temp="${temp}-$3"
    escapedDir="\.\/${temp}\/$3"
    cp -r "$skelSubfile" "./src"
    mv "$srcDir/subfile" "$srcDir/$temp"
    mv "$srcDir/$temp/subfile.tex" "$srcDir/$temp/$3.tex"
    # https://stackoverflow.com/questions/37909388/append-line-after-last-match-with-sed
    sed -i '/\\subfile[^\n]*/,$!b;//{x;//p;g};//!H;$!d;x;s//&\n\\subfile{{'"$escapedDir"'}}/' "$srcDir/document.tex"
    echo "New subfile with name $3 has been created in $srcDir/$temp and the subfile has been added to your document.tex"
}

###
#   Main script
###
if [ "$1" = "new" ]; then
    if [ "$2" = "subfile" ]; then
        new_subfile "$3"
    else
        echo "No sub-command provided. Usage is 'new subfile|file'"
    fi

elif [ "$1" = "rm" ]; then
    if [ -n "$2" ]; then
        echo "Directory ./src/$2 not found, neither was ./src/$2.tex"
    fi
    rm -r "./${srcDir:?}/$2"
elif [ "$1" = "build" ]; then
    nix build
fi

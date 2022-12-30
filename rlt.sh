#!/bin/sh
# WIP
# Provides an interface to manipulate TeX (sub)files
srcDir="./src"
skelDir="./skel"
skelSubfile="$skelDir/subfile"

numOfFolder=$(find ./src/* -maxdepth 0 -type d | wc -l)
# echo "$numOfFolder"
newSrcDirs=$(($numOfFolder + 1))

new_subfile() {
    # Function to generate a new subfile and add it to document.tex
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
    target="./${srcDir:?}/$1"
    escapedTarget="\.\/$srcDir\/$1"
    echo "Deleting..."
    rm -r "$target"
    sed -i '/\\subfile{{'"$escapedTarget"'}}/d' "$srcDir/document.tex"
    echo "The subfile $1 has been successfully removed from 'document.tex' and deleted from $srcDir"
}
usesNix() {
    systemInfo=$(uname --all)
    lcase=$(echo "$systemInfo" | tr "[:upper:]" "[:lower:]")
    if [ -z "${lcase##*nix*}" ]; then
        echo "Uses Nix"
        return 0
    fi
    echo "No Nix"
    return 1
}
checkAlphanumeric() {
    input=$(echo "$1" | grep -qE '^[[:alnum:]]+$' && echo "Y")
    if [ "$input" != "Y" ]; then
        return 1
    fi
    return 0
}
###
#   Main script
# Just a bunch of nested if statements (ouch) but it works
###

case $1 in
"new")
    # Checks if option "subfile" or empty string was provided 
    if [ -z "$2" ] || [ -z "$3" ]; then
        echo "No sub-command provided. Usage is 'new subfile <name>'"
    fi
    # Checks string for subfile is non-empty and alphanumeric - causes issues for subfile/LaTeX to resolve paths
    if [ "$2" = "subfile" ] && [ -n "$3" ] && checkAlphanumeric "$3"; then
        new_subfile "$3"
        echo "Created new subfile $3 at $srcDir/$3 and added it to document.tex"
    else
        echo "Name provided was not an alphanumeric string"
    fi
;;
"rm")
    # Checks subfile exists in the first 
    if [ -n "$2" ]; then
        echo "Directory ./src/$2 not found, none of your files were changed"
    else
        remove_subfile "$2"
    fi
;;
"build")
    # Really dumb check for nix installled
    if ! usesNix ; then
        echo "User does not use nix"
        latexmk -pdflatex=lualatex -interaction=nonstopmode -pdf "$srcDir/document.tex"
    fi
    echo "Detected nix, running nix build"
    nix build
;;
esac

echo "Finished executing"
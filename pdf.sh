#!/bin/bash

PDFSH_NAME=$(echo $0 | awk -F"/" '{print $NF}')

func_pdf_join ()
{
	outputName=$1
	shift
	gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE="$outputName" -dBATCH $*

}

func_pdf_gray () 
{
	# Gray conversion 1 -> 1, but we could do N -> 1 if changed the $2 for $*, and added a shift before.
	gs -sOutputFile="$1" -sDEVICE=pdfwrite -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH "$2"
}

func_pdf_version ()
{
	echo "###########################"
	echo "# Script: pdf.sh          #"
	echo "# Author: Jordi Martori   #"
	echo "# Version: 1              #"
	echo "###########################"
}

help()
{
	func_pdf_version
	echo ""
	echo "Usage: $PDFSH_NAME <join|gray> <output file> <input files>"
	echo "       $PDFSH_NAME <help|version>"
	echo ""
	echo ""
}

if [ $# -lt 1 ]; then
	help
	exit 1
fi

case $1 in 
	"help")
		help
	;;
	"join")
		shift
		func_pdf_join $*	
	;;
	"gray")
		shift
		func_pdf_gray $*	
	;;
	"version")
		func_pdf_version
	;;
esac

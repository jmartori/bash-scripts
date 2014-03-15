#!/bin/bash

help()
{
	echo "Usage: $0 <join|gray> <output file> <input files>"
}

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

if [ $# -lt 1 ]; then
	help
	exit 1
fi

case $1 in 
	"--help")
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
esac

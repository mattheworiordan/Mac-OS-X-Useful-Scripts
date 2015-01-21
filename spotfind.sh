#!/bin/bash
# Handy utility to use Spotlight from the command line using a simpler command set 
# Author: Matthew O'Riordan, http://mattheworiordan.com/
# First version 2009-11-24
######

param1=$1
if [ -z "$1" ]; then 
	param1="?"
fi

if [ "$param1" = "?" ] || [ "$param1" = "--help" ] || [ "$param1" = "-h" ]; then
	echo "usage: spotfind [-fpc] [restrict_search_to_folder] file_wildcards
	Default usage searches for a file with the name containing the first parameter
	
	Param: -f or --folder -> search for folder name 
	Param: -p or --phrase -> search for a phrase within a file (with optional folder path)
	Param: -c or --configure -> configures standard Mac OS X folders to be included in Spotlight searches (/Library, /usr) or 
			optionally you can pass in any folder
			
	Usage examples
	--------------
	spotfind terminal
		Finds all files with the name terminal anywhere on the local file system indexed by Spotlight
		
	spotfind *terminal
		Finds all files with the word terminal in the file name anywhere on the local file system
		
	spotfind -f /Applications terminal
		Finds all files with the name terminal in the /Applications folder
		
	spotfind -p /Applications terminal
	
	spotfind -p terminal
		
	** Note all searches are case insensitive, and kMDItemDisplayName is used as opposed to kMDItemFSName for performance reasons.
	   Searching with kMDItemDisplayName can sometimes omit expected results i.e. a search for Terminal.app will not return 
	   a result, where as Terminal would.
"
else
	if [ "$1" = "-c" ] || [ "$1" = "--configure" ]; then
		if [ -z "$2" ]; then
			echo "Adding /Library folder to the Spotlight search indexes, please wait..."
			mdimport /Library
			echo "Adding /usr folder to the Spotlight search indexes, please wait..."
			mdimport /usr
		else
			echo "Adding $ folder to the Spotlight search indexes, please wait..."
			mdimport $2
		fi
		echo "
		Folder(s) have been added to Spotlight search index.
		
		If you would like to expand the types of files that Spotlight indexes (such as text within source code files), then go to http://www.macosxtips.co.uk/index_files/terminal-commands-for-improving-spotlight.html and follow the instructions under 'Make Spotlight index source code'
		If you need to rebuild the indexes, execute the command: sudo mdutil -E /"
	elif [ "$1" = "-f" ] || [ "$1" = "--folder" ]; then
		mdfind "kMDItemKind == 'Folder' && kMDItemDisplayName == '$2'c"
	elif [ "$1" = "-p" ] || [ "$1" = "--phrase" ]; then
		if [ -z $3 ]; then
			mdfind "$2" 
		else
			mdfind -onlyin "$2" "$3"
		fi
	elif [ -z "$2" ]; then
		mdfind "kMDItemDisplayName == '$1'c"
	else
		mdfind -onlyin $1 "kMDItemDisplayName == '$2'c"
	fi
fi

exit 0
#!/bin/bash

export PATH=.:"$PATH"

result=false
if stdout="$(../spotfind.sh "thing" 2>&1)"
then
	if [[ "$stdout" == "RAN_MDFIND kMDItemDisplayName == 'thing'c" ]]
	then
		result=true
	else
		echo "$stdout"
	fi
fi

if $result
then
	echo "Pass"
else
	echo "FAIL"
fi

# return the test status as exit status
$result

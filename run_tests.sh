#!/bin/bash

cd test
all_passed=true
for test in t*.sh
do
	echo ==================== Run Test $test
	./$test || all_passed=false
done
echo ==================== 
echo Result:

if $all_passed
then
	echo Pass
else
	echo FAIL
fi

# return status to caller
$all_passed

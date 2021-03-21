#!/bin/bash

#------------------------------------------------------------------------------
# 
#   OOP Lan Party Checker, 2020-2021
#
#   Authors: Rusu Gabriel & Tudose Ionut
#
#------------------------------------------------------------------------------

# Exec name
EXEC_NAME=lanParty

# Teste Normale
FILE_TEST_DATE_1="date/t%d/d.in"
FILE_TEST_CERINTE="date/t%d/c.in"
FILE_TEST_REF="rezultate/r%d.out"
FILE_TEST_OUT="out/out%d.out"
NUM_TESTS=15

# Format: "x=a,y=b,z=c..."
# x, y, z are test indexes
# Each test with an index less or equal to x gets a points.
# Each test with an index less or equal to y gets b points.
POINTS_TEST="1=5,2=7,3=8,4=5,5=5,6=10,7=6,8=9,9=15,15=5"

# Total score
SCORE_TESTS=0

# Delimitor
DELIM="-------------------------------------------------------------"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


points=0

function run_test {
	points=0
	msg=""
	color=$RED

	# Convert from Points string to array
	p_text=`echo $6 | tr ',' ' '`
	p_arr=($p_text)

	for x in "${p_arr[@]}";
	do
	        tidx=`echo $x | cut -d'=' -f1`
	        tpts=`echo $x | cut -d'=' -f2`
	
        	if (( $1 <= $tidx ));
        	then
			points=$tpts
        	        break
        	fi
	done

	# Okay, so this test will get $points if passed.
	./$EXEC_NAME $2 $3 $4  2>&1 | cat
	
	diff -Z -q $4 $5 > /dev/null 2>&1
	if [ $? -eq 0 ];
	then
		msg="PASSED"
		color=$GREEN
	else
		msg="FAILED"
		color=$RED
		points=0
	fi

	printf "Test %2d ................................. ${color}%6s${NC} (+%2dpt)\n" $i $msg $points
}

function run_tests {
	for i in `seq 1 1 $1`
	do
		printf -v file_cerinte $2 $i
		printf -v file_date_1 $3 $i
		printf -v file_out $4 $i
		printf -v file_ref $5 $i
		run_test $i $file_cerinte $file_date_1 $file_out $file_ref $6
		
		SCORE_TESTS=$(($SCORE_TESTS+$points))
	done
}

function run_normal_tests {
	echo $DELIM
	echo "[TESTE NORMALE]"
	run_tests $NUM_TESTS $FILE_TEST_CERINTE $FILE_TEST_DATE_1 $FILE_TEST_OUT $FILE_TEST_REF "$POINTS_TEST"

	echo
	printf "TOTAL ........................................... %3spt\n" $SCORE_TESTS 
	echo
}

function show_total {
	echo $DELIM
	echo "[NOTA FINALA]"
	
	echo
	printf "NOTA FINALA ..................................... %3spt\n" $(($SCORE_TESTS))
	echo	
}
# Clean
make clean
# Prepare output directory
rm -rf out/
mkdir out

# Build
make

# Run normal tests
echo $DELIM
echo "Executabil = '$EXEC_NAME'"

run_normal_tests
show_total


#!/bin/sh

MY_GNL="../"

new_diffs_entry() {
	echo "" >> diffs.txt
	echo "Test Set: $(date '+%d/%m/%Y %H:%M:%S')" >> diffs.txt
}

compare() {
	./test_mine tests/test_$TEST_NUM.txt > out1.txt
	tail -n 2 out1.txt >> time1.txt
	sed -i '' -e '$ d' out1.txt
	./test_abaudot tests/test_$TEST_NUM.txt > out2.txt
	tail -n 2 out2.txt >> time2.txt
	sed -i '' -e '$ d' out2.txt
	DIFF=`diff out1.txt out2.txt`
	NUM_DIFFS=${#DIFF}
	if [ $NUM_DIFFS -gt 0 ]
	then
		if [ $NUM_DIFFS -eq 0 ]
		then
			new_diffs_entry
		fi
		echo "Diff detected:" >> diffs.txt
		echo "Test information:" >> diffs.txt
		cat tests/test_$TEST_NUM.txt.info > diffs.txt
		echo "My output:" >> diffs.txt
		cat out1.txt >> diffs.txt
		echo "abaudot's output:" >> diffs.txt
		cat out2.txt >> diffs.txt
		echo "" >> diffs.txt
		echo "Test $TEST_NUM: Discrepancy logged. See diffs.txt for details."
		NUM_DIFFS=$(($NUM_DIFFS + 1))
	else
		echo "Test $TEST_NUM: ok"
	fi
}


MAX_TEST=100
MIN_TEST=0
NUM_DIFFS=0
NUM_ARGS=$#
BUFF=42

# Get custom arguments for BUFFER_SIZE and Numbers of tests to run
if [ $NUM_ARGS -eq 1 ]
then
	BUFF=$1
fi
if [ $NUM_ARGS -eq 2 ]
then
	MAX_TEST=$2
	BUFF=$1
fi
TEST_NUM=$MIN_TEST

# Make executables
echo ""
echo "Making executables..."
#make mine > /dev/null
    clang -Wall -Wextra -Werror -I $MY_GNL -o get_next_line.o -c ../get_next_line.c -D BUFFER_SIZE=$BUFF
    clang -Wall -Wextra -Werror -IMY_GNL -o get_next_line_utils.o -c ../get_next_line_utils.c
    clang -Wall -Wextra -Werror -IMY_GNL -o file-printer.o -c file-printer.c
    clang -o test_mine get_next_line_utils.o get_next_line.o file-printer.o -I ../
#make abau > /dev/null 
    clang -Wall -Wextra -Werror -I validated-gnls/abaudot/ -o get_next_line.o -c validated-gnls/abaudot/get_next_line.c -D BUFFER_SIZE=$BUFF
    clang -Wall -Wextra -Werror -I validated-gnls/abaudot/ -o get_next_line_utils.o -c validated-gnls/abaudot/get_next_line_utils.c
    clang -Wall -Wextra -Werror -I validated-gnls/abaudot/ -o file-printer.o -c file-printer.c
    clang -o test_abaudot file-printer.o get_next_line.o get_next_line_utils.o -I validated-gnls/abaudot/
#make filegen > /dev/null
		clang -I file_generator/  -o generate_test file_generator/filegen.c file_generator/main.c file_generator/strjoin.c
rm -f *.o
echo "Generating files.."
mkdir -p tests
echo "----------please wait----------"
./generate_test $MIN_TEST $MAX_TEST

# Run tests
echo ""
echo "Time is now $(date '+%d/%m/%Y %H:%M:%S')"
echo ""
echo "Running tests..."
while [ $TEST_NUM -lt $MAX_TEST ]
do
	compare
	TEST_NUM=$(($TEST_NUM + 1))
done

TIME_1=$(awk '{s+=$1}END{print s}' time1.txt)
TIME_2=$(awk '{s+=$1}END{print s}' time2.txt)
TIME_DIFF=`echo "scale=1; $TIME_1 - $TIME_2 " | bc`

#clean
rm time1.txt time2.txt test_mine test_abaudot out1.txt out2.txt
rm generate_test

echo ""
echo "-------------------------------------------------------------------"
echo "-------------- BENCH TIME -----------------------------------------"
echo "-------------------------------------------------------------------"
echo ""
echo ""
if [ 1 -eq "$(echo "${TIME_DIFF} > 0.1" | bc)" ]
then 
	echo "You lose !! :( :( (try again ?)"
	echo "your time = $TIME_1"
	echo "abaudot time = $TIME_2"
	echo "diff = $TIME_DIFF"
elif [ 1 -eq "$(echo "${TIME_DIFF} < -0.1" | bc)" ]
then
	echo "You WIN OMG !!!!!"
	echo ""
	echo "your time = $TIME_1"
	echo "abaudot time = $TIME_2"
	echo "diff = $TIME_DIFF"
	echo ""
	echo "---------------------------------------------"
	echo "please send me a mail whit your code \o/"
	echo "aimebaudot@gmail.com"
else
	echo "great job, no one win this time"
	echo "your time = $TIME_1"
	echo "abaudot time = $TIME_2"
	echo "diff = $TIME_DIFF"
	echo ""	
	echo "the diff is not significative (aleas)"
fi

# add some space in diffs for the next set of tests
if [ $NUM_DIFFS -gt 0 ]
then
	echo "" >> diffs.txt
	echo "" >> diffs.txt
	echo "" >> diffs.txt
	echo "" >> diffs.txt
fi

#!/bin/bash

size=0
while [ $size -le 1048576 ] # Writes to a file until it reaches the size of 1MiB(i.e. 1048576 bytes)
do
	# Using awk, generates a random number between 1 and 15 
	# to specify the string length of each line
	n=$(awk -v min=1 -v max=15 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
	
	# Uses /dev/urandom to generate a random string including charachters A-Z, a-z, and 0-9
        # pipes head -c to choose the first charachters (15 or less) of the resulting string
	# appends it to the 'random_str' file	
	tr -dc A-Za-z0-9 </dev/urandom | head -c $n >> random_str
	
	# Breaks the line after each string
	echo "" >> random_str
	
	# Checks the size of the file using the -c (--bytes) option of wc
	size=$(wc -c random_str | cut -d " " -f1)
done

# Sorts the file using the 'sort' tool.
# I chose this method because it is the most commonly used tool for searching 
# and is very easy to use.
# Without any options sort command sorts the file in an ascending order, i.e. 0-9a-z, 
# and prints the output on the terminal.
# I added -o option to save the output in the same file.
sort -o random_str random_str

# Uses sed to delete all the lines that start with a or A 
# and writes the output to a new file 'no_a_random_str'
sed '/^[aA]/d' random_str > no_a_random_str

# Uses wc to get the number of the lines in the 'random_str', which is the original file,
# and the 'no_a_random', which was created after specified lines were deleted.
before=$(wc -l random_str | cut -d " " -f1) after=$(wc -l no_a_random_str | cut -d " " -f1)

# Calculates the number of lines deleted and prints the output.
echo "$(expr $before - $after) lines were deleted"

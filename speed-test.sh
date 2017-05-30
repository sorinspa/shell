#!/bin/bash

MAX_REQUESTS=100 #also this is the max parallel processes, so you might encounter process-forking issues
LOOPS=1
WAIT_FOR_LOOP=false

#command to be executed
CMD="curl -s http://localhost"

# used term colors
GRAY="\033[0;90m"  
GREEN="\033[0;92m"
YELLOW="\033[0;93m"
RESET="\033[0;0m"

COLOR=$GREEN

if [ $WAIT_FOR_LOOP = true ]; then
	MAX_REQUESTS=$MAX_REQUESTS*$LOOPS
	LOOPS=1 
fi

# capture start time
s0=$(date +"%s")
t0=$(date +"%T")

printf "\n\n\n"
printf "\n${GRAY}+---< ${RESET}${t0}${GRAY} >---${YELLOW} started ${GRAY}-----------------------------------------+${RESET}\n"
printf "Running in ${YELLOW}sequencial${RESET} mode"

for ((i=1;i<=$LOOPS;i++))
	do
		for ((j=1;j<=$MAX_REQUESTS;j++))
			do 
				$CMD  > /dev/null
			done
	done

# compute time diff
s1=$(date +"%s")
t1=$(date +"%T")
secs=$(expr $s1 - $s0)

printf "\n${GRAY}+---<${COLOR} $t1 ${GRAY}>---${COLOR} finished ${GRAY}----------------------------------------+"
printf "\n${GRAY}+------------------------------------ elapsed time --<${COLOR} $secs ${GRAY}seconds >---+${RESET}"
printf "\n\n\n"

printf "\n${GRAY}+---< ${RESET}${t0}${GRAY} >---${YELLOW} started ${GRAY}-----------------------------------------+${RESET}\n"
printf "Running in ${YELLOW}parallel${RESET} mode"

# capture start time
s0=$(date +"%s")
t0=$(date +"%T")

for ((i=1;i<=$LOOPS;i++))
	do 
		for ((j=1;j<=$MAX_REQUESTS;j++))
			do
			    $CMD  > /dev/null &
			done
		if [ $WAIT_FOR_LOOP = true ]; then
			wait
		fi
	done
wait
s1=$(date +"%s")

# compute time diff
t1=$(date +"%T")
secs=$(expr $s1 - $s0)

printf "\n${GRAY}+---<${COLOR} $t1 ${GRAY}>---${COLOR} finished ${GRAY}----------------------------------------+"
printf "\n${GRAY}+------------------------------------ elapsed time --<${COLOR} $secs ${GRAY}seconds >---+${RESET}"
printf "\n\n\n"

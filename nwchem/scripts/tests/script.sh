#/bin/bash
if [[ $1 == 'serial' ]] 
then
	proc=1
	sjob="serial"
	echo $proc $sjob
elif [[ $1 == 'test' ]]
then
	proc=16
	sjob="test"
	echo $proc $sjob
elif [[ $1 == 'single' ]]
then
	proc=32
	sjob="single"
	echo $proc $sjob
else
	echo "No type found, please give the suitable job type"
fi

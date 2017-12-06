#!/bin/sh

if [ $# != 1 ]
then
	echo "USAGE: $0 libraf_fw"
	echo " e.g.: $0 libraf_fw_uart_custom_170918_1.hex"
	exit 1
else	
	input_file="$1"
fi

file_name=`echo $input_file | grep "libraf_fw_uart_custom.*\.hex"`
if [ "$file_name" == "" ]
then
	echo "input file_name error"
	exit 1
else
	echo "input file_name success"
fi

times=0
update_times=10
update_status=-1

while [[ $times -lt $update_times && $update_status -ne 0 ]]
do
	#for gpio operater
	echo 20  > /sys/class/gpio/export
	echo 24  > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio20/direction
	echo out > /sys/class/gpio/gpio24/direction
	echo 1   > /sys/class/gpio/gpio24/value
	echo 0   > /sys/class/gpio/gpio20/value
	sleep 1
	echo 1   > /sys/class/gpio/gpio20/value
	usleep 200000
	echo 0   > /sys/class/gpio/gpio24/value
	echo 20  > /sys/class/gpio/unexport
	echo 24  > /sys/class/gpio/unexport
	#for flash update
	./stm32flash -w $input_file -v -g 0x0
	update_status=$?
	times=$(($times+1))
	echo "update_status:"$update_status
	echo "times:"$times
done

exit $update_status
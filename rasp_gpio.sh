#!/bin/bash
ports="1 2 3 4 5 6 7 8"

# Guarrada per cridar una funcio enlloc de l'altre
mode="debug"

GPIO_FS="/tmp/gpio"
#GPIO_FS="/sys/class/gpio"


debug_gpio_init()
{
	for port in $ports
	do
		mkdir -p $GPIO_FS/gpio$port
		echo "out" > $GPIO_FS/gpio$port/direction
		echo "0" > $GPIO_FS/gpio$port/value
		echo "?" > $GPIO_FS/gpio$port/uevent
		echo "?" > $GPIO_FS/gpio$port/subsystem
		echo "?" > $GPIO_FS/gpio$port/power
	done
}

gpio_config_check()
{ 
	[ ! $(whoami) == root ] && echo "Error: You should be root." >&2 && return 1
	[ ! -d $GPIO_FS ] && echo "Error: $GPIO_FS is not a directory." >&2 && return 1
	[ ! -f $GPIO_FS/export ] && echo "Error: $GPIO_FS/export is not a file." >&2 && return 1	
	[ $( echo $ports | tr ' ' '\n') -ne $(echo $ports | tr ' ' '\n' | sort | uniq) ] && echo "Error: wrong port config." >&2 
}

gpio_init()
{
	ports="$*"
	for port in $ports
	do
		[ ! -d $GPIO_FS/gpio$port ] && echo "port" >> $GPIO_FS/export
	done
}

help_gpio_set()
{
	echo "$0 <pin> set <attr> <value>"
}

help_gpio_get()
{
	echo "$0 <pin> get <attr>"
}

help_gpio()
{
	help_gpio_set
	help_gpio_get
	echo "<pin> = $ports"
	echo -n "<attr> = "
	echo $(ls $GPIO_FS/$(ls $GPIO_FS | grep "gpio[0-9]" | head -n1 ))	
}

gpio_set()
{
	# gpio.sh <pin> set <attr> <value>
	pin=$1
	attr=$3
	value=$4

	[ $# -lt 4 ] && help_gpio_set && return 1
	[ ! -d $GPIO_FS/gpio$pin/ ] && echo "Error: Pin not exported yet." && return 2
	[ ! $(ls $GPIO_FS/gpio$pin | grep "$attr") == "$attr" ] && echo "Error: Invalid option." && return 3

	echo "$value" >> $GPIO_FS/gpio$pin/$attr
}

gpio_get()
{
	# gpio.sh <pin> set <attr>
	pin=$1
	attr=$3

	[ $# -lt 3 ] && help_gpio_get && return 1
	[ ! -r $GPIO_FS/gpio$pin/$attr ] && echo "Error: Does not exist or you do not have permission." && return 2
	cat "$GPIO_FS/gpio$pin/$attr"
}

[ $# -lt 1 ] && help_gpio && exit 1
[ ! "$2" == "set" ] && [ ! "$2" == "get" ] && help_gpio && exit 1

[ "$mode" == "debug" ] && rm -rf $GPIO_FS && debug_gpio_init && gpio_$2 $* && exit 127 

# sha de fer el init normal
[ "$1" == init ] && shift && gpio_init $* && exit 0

gpio_$2 $*
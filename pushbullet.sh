#debug="echo "

## Load Config file
# PB_API_*
[ -r ~/.pushbullet/basic.conf ] && . ~/.pushbullet/basic.conf

# Falta un else, que si no hi ha la config surti o avisi!

func_push()
{
	[ $# -lt 3 ] && echo "Error: I need more parameters." && exit 1
	PB_API_FUN="pushes"
	
	PB_EMAIL="$1"
	PB_TITLE="$2"
	PB_BODY="$3"
	CMD_OUTPUT="$4"

	DATA_PAYLOAD=" -d email=$PB_EMAIL -d type=note -d title=\"$PB_TITLE\" -d body=\"$PB_BODY\" "

	cmd="curl --silent -u $PB_ACCESS_KEY: $PB_API_BASE_WEB/$PB_API_VERSION/$PB_API_FUN $DATA_PAYLOAD "
	$debug $cmd

	echo "$CMD_OUTPUT"

}

func_contact()
{
	PB_API_FUN="contacts"
	#DATA_PAYLOAD=" -d email='$PB_EMAIL' -d type=note -d title='$PB_TITLE' -d body='$PB_BODY' "

	cmd="curl --silent -u $PB_ACCESS_KEY: $PB_API_BASE_WEB/$PB_API_VERSION/$PB_API_FUN $DATA_PAYLOAD"
	$debug $cmd
}

func_devices()
{
	PB_API_FUN="devices"
	#DATA_PAYLOAD=" -d email='$PB_EMAIL' -d type=note -d title='$PB_TITLE' -d body='$PB_BODY' "

	cmd="curl --silent -u $PB_ACCESS_KEY: $PB_API_BASE_WEB/$PB_API_VERSION/$PB_API_FUN $DATA_PAYLOAD"
	$debug $cmd
}

func_install()
{

	[ ! -d "~/.pushbullet" ] && mkdir ~/.pushbullet
	if [ ! -f "~/.pushbullet/basic.conf" ]; then
		echo "PB_ACCESS_KEY=\"<Enter Your Access Key>\" ">> ~/.pushbullet/basic.conf
		echo "PB_API_BASE_WEB=\"https://api.pushbullet.com\" " >> ~/.pushbullet/basic.conf
		echo "PB_API_VERSION=\"v2\"" >> ~/.pushbullet/basic.conf
	fi
	

}

[ $# -lt 1 ] && echo "Error: I need more parameters." && exit 1

case $1 in
	"push")
		shift
		func_push "$1" "$2" "$3"
	;;
	"contacts")
		shift
		func_contact $*
	;;
	"devices")
		shift
		func_devices $*	
	;;
	"install")
		shift
		func_install $*
	;;
	*)
		echo "Input error"
esac
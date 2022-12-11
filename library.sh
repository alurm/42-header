# shellcheck disable=SC2154 # Variable referenced, but not assigned.
# shellcheck disable=SC2034 # Variable unused.

prog=$(basename "$0")

dateFormat='+%Y/%m/%d %T'

statBirthFlags='-f %B'
dateEpochFlagsPrefix='-r ' # Space is significant.
if [ "$(uname)" = Linux ]; then
	statBirthFlags='-c %W'
	dateEpochFlagsPrefix='-d @'
fi

usage () {
	echo "Usage: $prog path ..."
	exit 1
}

len () {
	printf %s "$1" | wc -c
}

nBlanks () {
	printf '%*s' "$1" ' '
}

padding () {
	nBlanks=$(len "$1"); shift
	for arg; do
		nBlanks=$((nBlanks - $(len "$arg")))
	done
	if [ "$nBlanks" -lt 0 ]; then
		echo "$prog": padding: not enough space >&2
		exit 1
	fi
	nBlanks "$nBlanks"
}

hasHeader () { # The test is not fully correct for the sake of simplicity.
	sed 1q "$1" | grep -qF "$firstLineContent"
}

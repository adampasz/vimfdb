#FDB

reset() {
	echo -e "run\ncontinue" > $1
}

unsetBreakPoint() {
	grep -v "b $2:$3" $1 > tmp && mv tmp $1
}

setBreakPoint() {
	awk -v line="b $2:$3" '/run/{print; print line; next}1' $1 > tmp && mv tmp $1
}

loadBreakPoints() {
	awk -v filename=$2 'BEGIN {count=0} $1 ~/b/ $2 ~filename {split($2, a, ":"); ORS=","; count++; print a[2]} END {if (count < 1) print -1}' $1
}

# call arguments verbatim:
$@

# $1 is fdbInitPath
# $2+ are the ... rest args

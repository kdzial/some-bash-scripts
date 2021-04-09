#/bin/bash
# Script which summarize date about disk space and display result in consintent and clean format

tempfile="/tmp/available.$$"

trap "rm -f $tempfile" EXIT

cat << 'EOF' > $tempfile

	{ sum += $4}
END	{ mb = sum / 1024
	  gb = mb / 1024
	 printf "%.0f MB (%.2fGB) disk space available on disks\n", mb, gb
	}
EOF

df -k | awk -f $tempfile

exit 0

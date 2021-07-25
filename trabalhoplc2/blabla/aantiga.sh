#!/usr/bin/awk -f

BEGIN {FS = ";"; RS = ";;;;;;;*\r\n(\r\n)?";
	ORS = "\r\n"
}
NR >=0 && !/^;*$/ {

gsub("\r\n", " ", $0)


for(i=NF;i>1; i--)
	if ($i =="")
		NF=NF-1
	else break

if ($1=="")
	$1= "NIL"

for (i=1; i<=NF; i++)
	$i=$i";"

print $0

}

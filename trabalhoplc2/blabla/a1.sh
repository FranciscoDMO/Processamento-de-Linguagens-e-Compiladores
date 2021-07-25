#!/usr/bin/awk -f

BEGIN {FS = "\"*;\"*"; RS = ";\r\n(\r\n)?";
	ORS = "\n"
}
x=0
NR >=0 && !/^;*$/ {
if(NR==1){
	x=NF
}



if ($1=="")
	$1= "NIL"

for (i=1; i<=x; i++)
	if ($i!= "")
		$i="\""$i"\""";"

print x

}

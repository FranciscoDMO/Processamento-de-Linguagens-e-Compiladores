#!/usr/bin/awk -f

BEGIN {FS = ";"}
NR >=0{
	print $1

}

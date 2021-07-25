#!/usr/bin/awk -f

BEGIN {FS = "\"*;\"*"; RS = ";\r\n(\r\n)?";
	OFS = "\";\""; ORS = "\n"
}
NR >0 {
print $0
}


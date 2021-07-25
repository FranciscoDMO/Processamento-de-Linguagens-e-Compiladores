BEGIN {FS = ";" ; }
NR >1 {
	if ($10 != " " && $10!= "")
		tipo[$10]++
}
END {
	for(i in tipo){
		print i ":" tipo [i]
	}
}
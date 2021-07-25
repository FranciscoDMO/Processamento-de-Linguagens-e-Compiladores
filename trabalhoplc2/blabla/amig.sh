#!/usr/bin/awk -f

BEGIN {FS = ";"; RS = ";\r\n(\r\n)+";
	ORS = "\r\n"
}

NR >= 1 {

gsub("\r\n", " ", $0)
vazio = 1;
for (i=1; i<=NF; i++)
{
	if($i != "" && $i != " ")
	{
		vazio = 0;
		break;
	}
}

if(vazio != 1)
{
	if ($1=="")
		$1= "NIL"

	for (i=1; i<=NF; i++)
		if(i != NF)
			$i=$i";"

	print $0
}
}
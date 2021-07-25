BEGIN {FS = ";"; RS = ";\r\n(\r\n)+";
	ORS = "\r\n"
}

NR >= 1 {

gsub("\r\n", " ", $0)
vazio = 1;

for(i=NF;i>1; i--)
	if ($i =="")
		NF=NF-1
	else break


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
		$i=$i";"

	print $0
}
}
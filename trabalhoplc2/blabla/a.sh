#!/usr/bin/awk -f

BEGIN {FS = ";"; RS = ";\r\n(\r\n)+";
	ORS = "\r\n"
}

NR >= 1 {

 
gsub("\r\n", " ", $0)
vazio = 1;

# remove pontos e virgulas a mais no final 
for(i=NF;i>1; i--)
	if ($i =="")
		NF=NF-1
	else break

#retorna 1 se todos os fields forem vazios e 0 se não
for (i=1; i<=NF; i++)
{
	if($i != "" && $i != " ")
	{
		vazio = 0;
		break;
	}
}
# coloca nil se o primeiro field for vazio e coloca ";" no final de cada field
if(vazio != 1)
{
	if ($1=="")
		$1= "NIL"

	for (i=1; i<=NF; i++)
		$i=$i";"

	print $0
}
}
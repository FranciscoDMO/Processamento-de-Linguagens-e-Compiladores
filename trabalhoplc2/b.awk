BEGIN { FS = ";"; count = 0; }

$2 ~ /^[ ]*([0-9]+(\.[0-9]+)*)[ ]*$/ { 
	if(!seen[$2]++)
	{
		count++;
		print "Código: " $2;
		print "Titulo: " $3;
		if($4 != "" && $4 != " ")
		{
			print "Descrição: " $4;
		}
		
		if($5 != "" && $5 != " ")
		{
			print "Notas: " $5;
		}
	}
}

END { print "Número total de códigos: " count; }
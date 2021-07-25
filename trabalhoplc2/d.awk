BEGIN{
	FS=";";
	dot = "grafo.dot";
    print "digraph{" > dot;
    print "rankdir=LR" > dot;
}
NR>2
{ 	
	gsub("\"", "\\\"", $8);
	i++;
	print "DC" i "[label=" "\"" $9 "\"" "]" > dot;
	print "DR" i "[label=" "\"" $8 "\"" "]" > dot; 
	print "E" i "[label=" "\"" $2 "\"" "]" > dot; 
	print "DC" i "->" "E" i "[label=\"Diploma complementar\"]" > dot;
	print "DR" i "->" "E" i "[label=\"Diploma REF\"]"> dot;
	
}
END{
	print "}" > dot;
}



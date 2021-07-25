start : 
	awk -f a.awk formacao.csv > formacao_processado.csv
	awk -f b.awk formacao_processado.csv > resultadoB.txt
	awk -f c.awk formacao_processado.csv > resultadoC.txt
	awk -f d.awk formacao_processado.csv >resultadoD.txt
	dot -Tpng grafo.dot -o grafo.png
	rm -f resultadoD.txt
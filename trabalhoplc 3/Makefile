start:
	flex scanner.l
	yacc -d -v grammar.y
	gcc `pkg-config --cflags --libs glib-2.0` -o tradutor y.tab.c -l glib-2.0

clear:
	rm -f *.html
	rm -f tradutor
	rm -f y.tab.c
	rm -f lex.yy.c
	rm -f y.output
	rm -f y.tab.h

import:
	python importar.py > OrgGeo.txt

generate:
	./tradutor < OrgGeo.txt > index.html

%{
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <glib.h>

/* Declaracoes C diversas */

int endr(char *id);


/* Criar a hash table */

GHashTable* hash_table;
int localidade_id;

char* homepage_html;


typedef struct {
	char* locais_html;
	char* id_concelho;
} Concelho_info;

typedef struct {
	int loc_id;
	char* localidade_nome;
	char* concelho_nome;
	char* distrito_nome;
} Localidade_Info;


int yyerror(const char *s);
void print_distrito_file(const char* distrito_name, const char* conteudo);
void generate_distrito(char** destination, const char* conteudo);
void generate_concelho(char* destination, const char* conteudo);
int register_localidade(Localidade_Info loc);
void preencher_localidades_distrito(char* distrito);
void preencher_localidades_concelho(char* concelho);
void print_localidade(gpointer key, gpointer value, gpointer str);
int print_localidade_table(char** destination);
void add_homepage_distrito(const char* distrito);

%}

%union {
	char* texto; 
	Concelho_info conselho;
}

%token <texto>TID_DISTRITO
%token <texto>TID_CONCELHO
%token <texto>TID_LOCAL
%token <texto>ID
%token <texto>LINK

%type <texto>DescD 
%type <texto>IdD
%type <texto>Concelhos
%type <texto>Locais
%type <texto>IdC
%type <conselho>Concelho
%type <texto>Local
%type <texto>IdL
%type <texto>LstIds
%type <texto>LocalHyperlink

%%

OrgGeo      : Distritos { }
			;
Distritos   : IdD DescD '.' { 
				preencher_localidades_distrito($1);
				asprintf(&$2, 
					"%s<a href='index.html#%s'>Voltar à Pagina Inicial</a>", 
					$2, $1);
				print_distrito_file($1, $2); 
				add_homepage_distrito($1);
			}

		    | Distritos IdD DescD '.' { 
				preencher_localidades_distrito($2);
				add_homepage_distrito($2);
				asprintf(&$3, 
					"%s<a href='index.html#%s'>Voltar à Pagina Inicial</a>", 
					$3, $2);
				print_distrito_file($2, $3); 
			}
		    ;

DescD       : Concelhos { generate_distrito(&$$, $1); }
			;
Concelhos   : Concelho { 
				asprintf(&$$, "<h2>%s</h2>\n%s", $1.id_concelho, $1.locais_html);
			}
            | Concelhos ';' Concelho { 
				asprintf(&$$, "%s\n<h2>%s</h2>\n%s", $1, $3.id_concelho, $3.locais_html);
			}
			;
Concelho    : Locais ':' IdC { 
	asprintf(&$$.id_concelho, "%s", $3);
	preencher_localidades_concelho($3);
	asprintf(&$$.locais_html, "<ol>%s</ol>", $1);
}
			;
Locais 		: Local LstIds { 
				if($2 != NULL)
				{
					asprintf(&$$, "%s<li>%s</li>", $2, $1); 
				} else {
					asprintf(&$$, "<li>%s</li>", $1); 
				}
			}
LstIds 		: { $$ = ""; }
			| ',' Locais { asprintf(&$$, "%s", $2); }
IdD : ID
IdC : ID
Local : IdL '=' LocalHyperlink {
			Localidade_Info info;
			asprintf(&info.localidade_nome, "%s", $1);
			register_localidade(info);
			if($3 != NULL)
			{
				asprintf(&$$, "<a target='_blank' href=%s>%s</a>", $3, $1);
			}
		 }
		| IdL {
			Localidade_Info info;
			asprintf(&info.localidade_nome, "%s", $1);
			register_localidade(info);
		}
IdL : ID
LocalHyperlink : LINK { $$ = strdup($1); }

%%

#include "lex.yy.c"

int endr(char *id) { 
    return 0; 
}

void print_distrito_file(const char* distrito_name, const char* conteudo)
{
	char szFileName[256];
	sprintf(szFileName, "%s.html", distrito_name);
	FILE* f = fopen(szFileName, "w+");
	fprintf(f, "%s", conteudo);
	fclose(f);
}

void generate_distrito(char** destination, const char* conteudo)
{
	asprintf(destination,
	 "<html>\n" 
	 "<head>\n"
	 "</head>\n"
	 "<body>\n"
	 "%s\n"
	 "</body>\n"
	 "</html>", conteudo);
}

int yyerror(const char *s) {
    fprintf(stderr, "ERRO: %s \n", s);
    return 0;
}

int register_localidade(Localidade_Info loc)
{
	Localidade_Info* locinfo_dynamic = malloc(sizeof(Localidade_Info));
	asprintf(&locinfo_dynamic->localidade_nome, "%s", loc.localidade_nome);
	locinfo_dynamic->concelho_nome = NULL;
	locinfo_dynamic->distrito_nome = NULL;
	//asprintf(&locinfo_dynamic->concelho_nome, "%s", loc.concelho_nome);
	//asprintf(&locinfo_dynamic->distrito_nome, "%s", loc.distrito_nome);
	locinfo_dynamic->loc_id = localidade_id++;
	g_hash_table_insert(hash_table, 
		(gpointer)&locinfo_dynamic->loc_id, 
		locinfo_dynamic);
}

void preencher_localidade_concelho(gpointer key, gpointer value, gpointer user)
{
	const char* concelho = (const char*)user;
	Localidade_Info* loc_info = (Localidade_Info*)value;
	if(loc_info->concelho_nome == NULL)
	{
		asprintf(&loc_info->concelho_nome, "%s", concelho);
	}
}


void preencher_localidades_concelho(char* concelho)
{
	g_hash_table_foreach(hash_table, preencher_localidade_concelho, concelho);
}

void preencher_localidade_distrito(gpointer key, gpointer value, gpointer user)
{
	const char* distrito = (const char*)user;
	Localidade_Info* loc_info = (Localidade_Info*)value;
	if(loc_info->distrito_nome == NULL)
	{
		asprintf(&loc_info->distrito_nome, "%s", distrito);
	}
}

void preencher_localidades_distrito(char* distrito)
{
	g_hash_table_foreach(hash_table, preencher_localidade_distrito, distrito);
}

void print_localidade(gpointer key, gpointer value, gpointer str)
{
	Localidade_Info* loc_info = (Localidade_Info*)value;
	char** destination = (char**)str;
	asprintf(destination, "%s\n<li><b>%s</b> - Concelho: %s Distrito: %s\n", 
	*destination, loc_info->localidade_nome, 
	loc_info->concelho_nome, loc_info->distrito_nome);
}

void add_homepage_distrito(const char* distrito)
{
	asprintf(&homepage_html, "%s<li><a id='%s' href='%s.html'>%s</a></li>\n",
	homepage_html, distrito, distrito, distrito);
}

int build_localidade_table(char** destination)
{
	char* localidade_string;
	asprintf(&localidade_string, "<ul>");
	g_hash_table_foreach(hash_table, print_localidade, &localidade_string);
	asprintf(destination, "%s</ul>", localidade_string);
}

int main() 
{    
	hash_table = g_hash_table_new(g_int_hash, g_int_equal);
	localidade_id = 0;
	asprintf(&homepage_html, "<html>\n"
			"<head><title>OrgGeo</title></head>\n"
			"<body>\n"
			"<h1> Distritos </h1>\n"
			"<ul>");

    yyparse();
	asprintf(&homepage_html, "%s\n"
		"</ul>\n", homepage_html);
	
	char* localidades_table = NULL;
	build_localidade_table(&localidades_table);

	// Falta construir página inicial

	asprintf(&homepage_html, "%s\n<h2>Tabela de Localidades</h2>\n%s\n", 
	homepage_html, localidades_table);
	asprintf(&homepage_html, "%s\n</body>\n</html>", homepage_html);
	puts(homepage_html);
	free(localidades_table);
    return(0);
}



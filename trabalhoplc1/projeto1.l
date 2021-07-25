%{
#include <string.h>
#include <stdlib.h>
%}


%s UNOREDERED_LIST ORDERED_LIST CENTER
%option stack


%%
\\n {printf("\\textbf");}

\\ul {printf("\\underline"); }

\\it {printf("\\textit"); }

^\\sec {printf("\\section"); }

^\\ssec {printf("\\subsection"); }

^\\chap {printf("\\chapter"); }

\\newp {printf("\\newpage");}

\* {printf("  \\item %s", yytext + 1);}

\\ol[  | \n]*\{ {printf("\\begin{enumerate}");yy_push_state(ORDERED_LIST);}
\\ul[  | \n]*\{ {printf("\\begin{itemize}");yy_push_state(UNOREDERED_LIST);}

<UNOREDERED_LIST>\}"/ul" {printf("\\end{itemize}");yy_pop_state();}
<ORDERED_LIST>\}"/ol" {printf("\\end{enumerate}");yy_pop_state();}

\\c[  | \n]*\{ {printf("\\begin{center}");yy_push_state(CENTER);}
<CENTER>\}"/c" {printf("\\end{center}");yy_pop_state();}


(.|\n) { ECHO; }

%%

int yywrap(){
	return 1;
}

int main(){
	yylex();
	return 0;
}

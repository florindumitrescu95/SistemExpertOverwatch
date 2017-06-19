:-use_module(library(sockets)).
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(file_systems)).
:-op(900,fy,not).
:-dynamic fapt/3.
:-dynamic interogat/1.
:-dynamic scop/1.
:-dynamic interogabil/3.
:-dynamic regula/3.
:-dynamic intrebare_curenta/3.


close_all:-current_stream(_,_,S),close(S),fail;true.

curata_bc:-current_predicate(P), abolish(P,[force(true)]), fail;true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tab(Stream,N):-N>0,write(Stream,' '),N1 is N-1, tab(Stream,N1).
tab(_,0).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

not(P):-P,!,fail.
not(_).

scrie_lista([]):-nl.
scrie_lista([H|T]) :-
write(H), tab(1),
scrie_lista(T).
             
			 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%aici
scrie_lista(Stream,[]):-nl(Stream),flush_output(Stream).

scrie_lista(Stream,[H|T]) :-
write(Stream,H), tab(Stream,1),
scrie_lista(Stream,T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			 
afiseaza_fapte :-
write('Fapte existente �n baza de cunostinte:'),
nl,nl, write(' (Atribut,valoare) '), nl,nl,
listeaza_fapte,nl.

listeaza_fapte:-  
fapt(av(Atr,Val),FC,_), 
write('('),write(Atr),write(','),
write(Val), write(')'),
write(','), write(' certitudine '),
FC1 is integer(FC),write(FC1),
nl,fail.
listeaza_fapte.

lista_float_int([],[]).
lista_float_int([Regula|Reguli],[Regula1|Reguli1]):-
(Regula \== utiliz,
Regula1 is integer(Regula);
Regula ==utiliz, Regula1=Regula),
lista_float_int(Reguli,Reguli1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
un_pas(Rasp,OptiuniUrm,MesajUrm):-scop(Atr),(Rasp \== null,intreaba_acum(Rasp) ; true),
								determina1(Atr,OptiuniUrm,MesajUrm), afiseaza_scop(Atr).

intreaba_acum(Rasp):-intrebare_curenta(Atr,OptiuniV,MesajV),interogheaza1(Rasp,Atr,MesajV,OptiuniV,Istorie),nl,
asserta( interogat(av(Atr,_)) ).

interogheaza1(X,Atr,Mesaj,[da,nu],Istorie) :-
!,de_la_utiliz1(X,Istorie,[da,nu]),
det_val_fc(X,Val,FC),
asserta( fapt(av(Atr,Val),FC,[utiliz]) ).

interogheaza1(VLista,Atr,Mesaj,Optiuni,Istorie) :-
de_la_utiliz1(VLista,Optiuni,Istorie),
assert_fapt(Atr,VLista).


%de_la_utiliz1(+Rasp,?Istorie,+Lista_opt)
de_la_utiliz1(X,Istorie,Lista_opt) :-
proceseaza_raspuns([X],Istorie,Lista_opt).


determina1(Atr,OptiuniUrm,MesajUrm) :-
realizare_scop1(av(Atr,_),_,[scop(Atr)],OptiuniUrm,MesajUrm),!.
determina1(_,_,_).

realizare_scop1(not Scop,Not_FC,Istorie,OptiuniUrm,MesajUrm) :-
realizare_scop1(Scop,FC,Istorie,OptiuniUrm,MesajUrm),
Not_FC is - FC, !.
realizare_scop1(Scop,FC,_,_,_) :-
fapt(Scop,FC,_), !.
realizare_scop1(Scop,FC,Istorie,OptiuniUrm,MesajUrm) :-
pot_interoga1(Scop,Istorie,OptiuniUrm,MesajUrm),
!.

%realizare_scop1(Scop,FC,Istorie,OptiuniUrm,MesajUrm).

realizare_scop1(Scop,FC_curent,Istorie,OptiuniUrm,MesajUrm) :-
fg1(Scop,FC_curent,Istorie,OptiuniUrm,MesajUrm).


pot_interoga1(av(Atr,_),Istorie, Optiuni, Mesaj) :-
not interogat(av(Atr,_)),
interogabil(Atr,Optiuni,Mesaj),
retractall(intrebare_curenta(_,_,_)),
assert(intrebare_curenta(Atr, Optiuni,Mesaj)), !.


pornire1:-retractall(interogat(_)),
retractall(fapt(_,_,_)),
retractall(intrebare_curenta(_,_,_)),
retractall(scop(_)),
retractall(interogabil(_)),
retractall(regula(_,_,_)),
incarca('OverwatchReguli.txt').


fg1(Scop,FC_curent,Istorie,OptiuniUrm,MesajUrm) :-
regula(N, premise(Lista), concluzie(Scop,FC)),
demonstreaza1(N,Lista,FC_premise,Istorie,OptiuniUrm,MesajUrm),
(nonvar(FC), nonvar(FC_premise),ajusteaza(FC,FC_premise,FC_nou),
actualizeaza(Scop,FC_nou,FC_curent,N),
FC_curent == 100; true),!.
fg1(Scop,FC,_,_,_) :- fapt(Scop,FC,_).



demonstreaza1(N,ListaPremise,Val_finala,Istorie,OptiuniUrm,MesajUrm) :-
dem1(ListaPremise,100,Val_finala,[N|Istorie],OptiuniUrm,MesajUrm),!.

dem1([],Val_finala,Val_finala,_,_,_).
dem1([H|T],Val_actuala,Val_finala,Istorie,OptiuniUrm,MesajUrm) :-
realizare_scop1(H,FC,Istorie,OptiuniUrm,MesajUrm),
(nonvar(FC),
Val_interm is min(Val_actuala,FC),
Val_interm >= 20,
dem1(T,Val_interm,Val_finala,Istorie,OptiuniUrm,MesajUrm) ;true).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pornire :-
retractall(interogat(_)),
retractall(fapt(_,_,_)),
retractall(intrebare_curenta(_,_,_)),
repeat,
write('Introduceti una din urmatoarele optiuni: '),
nl,nl,
write(' (Incarca Consulta Reinitiaza  Afisare_fapte  Cum   Iesire) '),
nl,nl,write('|: '),citeste_linie([H|T]),
executa([H|T]), H == iesire.

executa([incarca]) :- 
incarca,!,nl,
write('Fisierul dorit a fost incarcat'),nl.
executa([consulta]) :- 
scopuri_princ,!.
executa([reinitiaza]) :- 
retractall(interogat(_)),
retractall(fapt(_,_,_)),!.
executa([afisare_fapte]) :-
afiseaza_fapte,!.
executa([cum|L]) :- cum(L),!.
executa([iesire]):-!.
executa([_|_]) :-
write('Comanda incorecta! '),nl.

nume_fisier(NumeFisier,Val,FC) :-
atom_concat('demonstratie_solutie_pt_',Val,Rez),
atom_concat(Rez,'[',Rez1),
number_chars(FC,N),
atom_chars(NR,N),
atom_concat(Rez1,NR,Rez2),
atom_concat(Rez2,']',Rez3),
atom_concat(Rez3,'.txt',NumeFisier).

%f) creem directorul in care se salveaza fisierele cu demonstratiile
creare_director :-
(\+directory_exists('output_overwatch')->make_directory('output_overwatch');true).

%f)crearea fisierelor
afiseaza_demonstratii :- 
scop(Atr),
telling(Vechi),
(fapt(av(Atr,Val),FC,_),
nume_fisier(NumeFisier,Val,FC),
atom_concat('output_overwatch/',NumeFisier,DirFisier),
tell(DirFisier),
cum(av(Atr,Val)),
told,fail ; true),
tell(Vechi).


scopuri_princ :-
scop(Atr),determina(Atr), afiseaza_scop(Atr),fail.
scopuri_princ:- creare_director, afiseaza_demonstratii.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scopuri_princ(Stream) :-
scop(Atr),determina(Stream,Atr), afiseaza_scop(Stream,Atr),fail.

scopuri_princ(_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
determina(Atr) :-
realizare_scop(av(Atr,_),_,[scop(Atr)]),!.
determina(_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
determina(Stream,Atr) :-
realizare_scop(Stream,av(Atr,_),_,[scop(Atr)]),!.

determina(_,_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
afiseaza_scop(Atr) :-
nl,fapt(av(Atr,Val),FC,_),
FC >= 20,scrie_scop(av(Atr,Val),FC),
nl,fail.
afiseaza_scop(_):-nl,nl.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
afiseaza_scop(Stream, Atr) :-
nl,fapt(av(Atr,Val),FC,_),
FC >= 20,format(Stream,"s(~p ^ ~p :: fact_cert ^ ~p)",[Atr,Val, FC]),
nl(Stream),flush_output(Stream),fail.

afiseaza_scop(_,_):-write('Terminat'),nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scrie_scop(av(Atr,Val),FC) :-
transformare(av(Atr,Val), X),
scrie_lista(X),tab(2),
write(' '),
write('factorul de certitudine este '),
FC1 is integer(FC),write(FC1).

realizare_scop(not Scop,Not_FC,Istorie) :-
realizare_scop(Scop,FC,Istorie),
Not_FC is - FC, !.
realizare_scop(av(Atr,_),FC,_) :-
fapt(av(Atr,'nu_conteaza'),FC,_), !.
realizare_scop(Scop,FC,_) :-
fapt(Scop,FC,_), !.


realizare_scop(Scop,FC,Istorie) :-
pot_interoga(Scop,Istorie),
!,realizare_scop(Scop,FC,Istorie).
realizare_scop(Scop,FC_curent,Istorie) :-
fg(Scop,FC_curent,Istorie).
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		realizare_scop(Stream,av(Atr,_),FC,_) :-
	fapt(av(Atr,'nu_conteaza'),FC,_), !.	
realizare_scop(Stream,not Scop,Not_FC,Istorie) :-
realizare_scop(Stream,Scop,FC,Istorie),
Not_FC is - FC, !.

realizare_scop(_,Scop,FC,_) :-
fapt(Scop,FC,_), !.

realizare_scop(Stream,Scop,FC,Istorie) :-
pot_interoga(Stream,Scop,Istorie),write('Am intrebat'),
!,realizare_scop(Stream,Scop,FC,Istorie).

realizare_scop(Stream,Scop,FC_curent,Istorie) :-
fg(Stream,Scop,FC_curent,Istorie).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg(Scop,FC_curent,Istorie) :-
regula(N, premise(Lista), concluzie(Scop,FC)),
demonstreaza(N,Lista,FC_premise,Istorie),
ajusteaza(FC,FC_premise,FC_nou),
actualizeaza(Scop,FC_nou,FC_curent,N),
FC_curent == 100,!.
fg(Scop,FC,_) :- fapt(Scop,FC,_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fg(Stream,Scop,FC_curent,Istorie) :-
regula(N, premise(Lista), concluzie(Scop,FC)),
demonstreaza(Stream,N,Lista,FC_premise,Istorie),
ajusteaza(FC,FC_premise,FC_nou),
actualizeaza(Scop,FC_nou,FC_curent,N),
FC_curent == 100,!.

fg(_,Scop,FC,_) :- fapt(Scop,FC,_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pot_interoga(av(Atr,_),Istorie) :-
not interogat(av(Atr,_)),
interogabil(Atr,Optiuni,Mesaj),
interogheaza(Atr,Mesaj,Optiuni,Istorie),nl,
asserta( interogat(av(Atr,_)) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pot_interoga(Stream,av(Atr,_),Istorie) :-
not interogat(av(Atr,_)),
interogabil(Atr,Optiuni,Mesaj),
interogheaza(Stream,Atr,Mesaj,Optiuni,Istorie),nl,write('Am interogat'),nl,
asserta( interogat(av(Atr,_)) ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cum([]) :- write('Scop? '),nl,
write('|:'),citeste_linie(Linie),nl,
transformare(Scop,Linie), cum(Scop).
cum(L) :- 
transformare(Scop,L),nl, cum(Scop).
cum(not Scop) :- 
fapt(Scop,FC,Reguli),
lista_float_int(Reguli,Reguli1),
FC < -20,transformare(not Scop,PG),
append(PG,[a,fost,derivat,cu, ajutorul, 'regulilor: '|Reguli1],LL),
scrie_lista(LL),nl,afis_reguli(Reguli),fail.
cum(Scop) :-
fapt(Scop,FC,Reguli),
lista_float_int(Reguli,Reguli1),
FC > 20,transformare(Scop,PG),
append(PG,[a,fost,derivat,cu, ajutorul, 'regulilor: '|Reguli1],LL),
scrie_lista(LL),nl,afis_reguli(Reguli),
fail.
cum(_).

afis_reguli([]).
afis_reguli([N|X]) :-
afis_regula(N),
premisele(N),
afis_reguli(X).
afis_regula(N) :-
regula(N, premise(Lista_premise),
concluzie(Scop,FC)),NN is integer(N),
scrie_lista(['R','-','-','>',NN,'\n','{']),
transformare2(Scop,Scop_tr),
append(['   '],Scop_tr,L1),
FC1 is integer(FC),append(L1,[FC1],LL),
scrie_lista(LL),nl,scrie_lista(['\n','premise',' ^ ','\n','{']),
scrie_lista_premise(Lista_premise),!,scrie_lista(['}','\n','}']),nl.

scrie_lista_premise([]).
scrie_lista_premise([H|T]) :-
transformare(H,H_tr),
tab(5),
scrie_lista(H_tr),scrie_lista(['&','&']),
scrie_lista_premise(T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scrie_lista_premise(_,[]).

scrie_lista_premise(Stream,[H|T]) :-
	transformare(H,H_tr),
	tab(Stream,5),scrie_lista(Stream,H_tr),scrie_lista(['&','&']),
	scrie_lista_premise(Stream,T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
transformare(av(A,da),[A]) :- !.
transformare(not av(A,da), ['/','/',A]) :- !.
transformare(av(A,nu),['/','/',A]) :- !.
transformare(av(A,V),[A,':','=','=',':',V]).

transformare2(av(A,V),[A,'^',V,':',':','fact_cert','^']).



premisele(N) :-
regula(N, premise(Lista_premise), _),
!, cum_premise(Lista_premise).
        
cum_premise([]).
cum_premise([Scop|X]) :-
cum(Scop),
cum_premise(X).
        
interogheaza(Atr,Mesaj,[da,nu],Istorie) :-
!,write(Mesaj),nl,write('(da '),write('nu '),write('nu_stiu '),write('nu_conteaza)'),
de_la_utiliz(X,Istorie,[da,nu,nu_stiu,nu_conteaza]),
det_val_fc(X,Val,FC),
asserta( fapt(av(Atr,Val),FC,[utiliz]) ).
interogheaza(Atr,Mesaj,Optiuni,Istorie) :-
write(Mesaj),nl,append(Optiuni,[nu_stiu,nu_conteaza],OptiuniNoi),
citeste_opt(VLista,OptiuniNoi,Istorie),
assert_fapt(Atr,VLista).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interogheaza(Stream,Atr,Mesaj,[da,nu],Istorie) :-!,
	write(Stream,i(Mesaj)),nl(Stream),flush_output(Stream),write(Stream,'(da nu nu_stiu nu_conteaza)'),nl(Stream),flush_output(Stream),
	de_la_utiliz(Stream,X,Istorie,[da,nu,nu_stiu,nu_conteaza]),
	det_val_fc(X,Val,FC),
	asserta( fapt(av(Atr,Val),FC,[utiliz]) ).
interogheaza(Stream,Atr,Mesaj,Optiuni,Istorie) :-
	write('\n Intrebare atr val multiple\n'),
	write(Stream,i(Mesaj)),nl(Stream),flush_output(Stream),append(Optiuni,[nu_stiu,nu_conteaza],OptiuniNoi),
	citeste_opt(Stream,VLista,OptiuniNoi,Istorie),write('Adaug fapt'),
	assert_fapt(Atr,VLista).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

citeste_opt(X,Optiuni,Istorie) :-
append(['('],Optiuni,Opt1),
append(Opt1,[')'],Opt),
scrie_lista(Opt),
de_la_utiliz(X,Istorie,Optiuni).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
citeste_opt(Stream,X,Optiuni,Istorie) :-
	append(['('],Optiuni,Opt1),
	append(Opt1,[')'],Opt),
	scrie_lista(Stream,Opt),
	de_la_utiliz(Stream,X,Istorie,Optiuni).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
de_la_utiliz(X,Istorie,Lista_opt) :-
repeat,write(': '),citeste_linie(X),
proceseaza_raspuns(X,Istorie,Lista_opt).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%aici
de_la_utiliz(Stream,X,Istorie,Lista_opt) :-
	repeat,write('astept raspuns\n'),citeste_linie(Stream,X),format('Am citit ~p din optiunile ~p\n',[X,Lista_opt]),
	proceseaza_raspuns(X,Istorie,Lista_opt), write('gata de la utiliz\n').
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

proceseaza_raspuns([de_ce],Istorie,_) :-                         nl,afis_istorie(Istorie),!,fail.

proceseaza_raspuns([X],_,Lista_opt):-
member(X,Lista_opt).
proceseaza_raspuns([X,fc,FC],_,Lista_opt):-
member(X,Lista_opt),float(FC).

assert_fapt(Atr,[Val,fc,FC]) :-
!,asserta( fapt(av(Atr,Val),FC,[utiliz]) ).
assert_fapt(Atr,[Val]) :-
asserta( fapt(av(Atr,Val),100,[utiliz])).

det_val_fc([nu],da,-100).
det_val_fc([nu,FC],da,NFC) :- NFC is -FC.
det_val_fc([nu,fc,FC],da,NFC) :- NFC is -FC.
det_val_fc([Val,FC],Val,FC).
det_val_fc([Val,fc,FC],Val,FC).
det_val_fc([Val],Val,100).
        
afis_istorie([]) :- nl.
afis_istorie([scop(X)|T]) :-
scrie_lista([scop,X]),!,
afis_istorie(T).
afis_istorie([N|T]) :-
afis_regula(N),!,afis_istorie(T).

demonstreaza(N,ListaPremise,Val_finala,Istorie) :-
dem(ListaPremise,100,Val_finala,[N|Istorie]),!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
demonstreaza(Stream,N,ListaPremise,Val_finala,Istorie) :-
dem(Stream,ListaPremise,100,Val_finala,[N|Istorie]),!.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dem([],Val_finala,Val_finala,_).
dem([H|T],Val_actuala,Val_finala,Istorie) :-
realizare_scop(H,FC,Istorie),
Val_interm is min(Val_actuala,FC),
Val_interm >= 20,
dem(T,Val_interm,Val_finala,Istorie).
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dem(_,[],Val_finala,Val_finala,_).

dem(Stream,[H|T],Val_actuala,Val_finala,Istorie) :-
realizare_scop(Stream,H,FC,Istorie),
Val_interm is min(Val_actuala,FC),
Val_interm >= 20,
dem(Stream,T,Val_interm,Val_finala,Istorie).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
actualizeaza(Scop,FC_nou,FC,RegulaN) :-
fapt(Scop,FC_vechi,_),
combina(FC_nou,FC_vechi,FC),
retract( fapt(Scop,FC_vechi,Reguli_vechi) ),
asserta( fapt(Scop,FC,[RegulaN | Reguli_vechi]) ),!.
actualizeaza(Scop,FC,FC,RegulaN) :-
asserta( fapt(Scop,FC,[RegulaN]) ).

ajusteaza(FC1,FC2,FC) :-
X is FC1 * FC2 / 100,
FC is round(X).
combina(FC1,FC2,FC) :-
FC1 >= 0,FC2 >= 0,
X is FC2*(100 - FC1)/100 + FC1,
FC is round(X).
combina(FC1,FC2,FC) :-
FC1 < 0,FC2 < 0,
X is - ( -FC1 -FC2 * (100 + FC1)/100),
FC is round(X).
combina(FC1,FC2,FC) :-
(FC1 < 0; FC2 < 0),
(FC1 > 0; FC2 > 0),
FCM1 is abs(FC1),FCM2 is abs(FC2),
MFC is min(FCM1,FCM2),
X is 100 * (FC1 + FC2) / (100 - MFC),
FC is round(X).

incarca :-
write('Introduceti numele fisierului care doriti sa fie incarcat: '),nl, write('|:'),read(F),
file_exists(F),!,incarca(F).
incarca:-write('Nume incorect de fisier! '),nl,fail.

/*incarca(F) :-
retractall(interogat(_)),retractall(fapt(_,_,_)),
retractall(scop(_)),retractall(interogabil(_,_,_)),
retractall(regula(_,_,_)),
see(F),incarca_reguli,seen,!.*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
incarca(F) :-
retractall(interogat(_)),retractall(fapt(_,_,_)),
retractall(scop(_)),retractall(interogabil(_,_,_)),
retractall(regula(_,_,_)),
open(F,read,StreamR),incarca_reguli(StreamR),close(StreamR),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
incarca_reguli :-
repeat,citeste_propozitie(L),
proceseaza(L),L == [end_of_file],nl.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
incarca_reguli(StreamR) :-

repeat,citeste_propozitie(StreamR, L),write(L),
proceseaza(L),L == [end_of_file],nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
proceseaza([end_of_file]):-!.
proceseaza(L) :-
trad(R,L,[]),assertz(R), !.
trad(scop(X)) --> [scop,'^',X].

trad(interogabil(Atr,M,P)) --> 
[intrebare,'-','-','>',Atr],afiseaza(Atr,P),lista_optiuni(M).
trad(regula(N,premise(Daca),concluzie(Atunci,F))) --> identificator(N),['{'],atunci(Atunci,F),daca(Daca),['}'].
trad('Eroare la parsare'-L,L,_).

lista_optiuni(M) --> [opt,'{'],lista_de_optiuni(M).
lista_de_optiuni([Element]) -->  [Element,'}'].
lista_de_optiuni([Element|T]) --> [Element,'|'],lista_de_optiuni(T).

afiseaza(_,P) -->  [text,'^',P].
afiseaza(P,P) -->  [].
identificator(N) --> [r,'-','-','>',N].

daca(Daca) --> [premise,'^','{'],lista_premise(Daca).

lista_premise([Daca]) --> propoz(Daca),['}'].
lista_premise([Prima|Celalalte]) --> propoz(Prima),['&','&'],lista_premise(Celalalte).


atunci(av(Atr,Val),FC) --> [Atr,'^',Val,':',':',fact_cert,'^',FC].
atunci(av(Atr,Val),100) --> [Atr,'^',Val].

propoz(not av(Atr,da)) --> ['/','/',Atr].
propoz(av(Atr,Val)) --> [Atr,':','=','=',':',Val].
propoz(av(Atr,da)) --> [Atr].

citeste_linie([Cuv|Lista_cuv]) :-
get_code(Car),
citeste_cuvant(Car, Cuv, Car1), 
rest_cuvinte_linie(Car1, Lista_cuv). 
      
% -1 este codul ASCII pt EOF

rest_cuvinte_linie(-1, []):-!.    
rest_cuvinte_linie(Car,[]) :-(Car==13;Car==10), !.
rest_cuvinte_linie(Car,[Cuv1|Lista_cuv]) :-
citeste_cuvant(Car,Cuv1,Car1),      
rest_cuvinte_linie(Car1,Lista_cuv).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%stream%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
citeste_linie(Stream,[Cuv|Lista_cuv]) :-
get_code(Stream,Car),
citeste_cuvant(Stream,Car, Cuv, Car1), 
rest_cuvinte_linie(Stream,Car1, Lista_cuv).
 
      
% -1 este codul ASCII pt EOF

rest_cuvinte_linie(_,-1, []):-!.
    
rest_cuvinte_linie(_,Car,[]) :-(Car==13;Car==10), !.

rest_cuvinte_linie(Stream,Car,[Cuv1|Lista_cuv]) :-
citeste_cuvant(Stream,Car,Cuv1,Car1),      
rest_cuvinte_linie(Stream,Car1,Lista_cuv).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
citeste_propozitie([Cuv|Lista_cuv]) :-
get_code(Car),citeste_cuvant(Car, Cuv, Car1), 
rest_cuvinte_propozitie(Car1, Lista_cuv). 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

citeste_propozitie(Stream, [Cuv|Lista_cuv]) :-
get_code(Stream, Car),citeste_cuvant(Stream, Car, Cuv, Car1), 
rest_cuvinte_propozitie(Stream, Car1, Lista_cuv).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
rest_cuvinte_propozitie(-1, []):-!.    
rest_cuvinte_propozitie(Car,[]) :-Car==46, !.
rest_cuvinte_propozitie(Car,[Cuv1|Lista_cuv]) :-
citeste_cuvant(Car,Cuv1,Car1),      
rest_cuvinte_propozitie(Car1,Lista_cuv).

citeste_cuvant(-1,end_of_file,-1):-!.
citeste_cuvant(Caracter,Cuvant,Caracter1) :-   
caracter_cuvant(Caracter),!, 
name(Cuvant, [Caracter]),get_code(Caracter1).
citeste_cuvant(Caracter, Numar, Caracter1) :-
caracter_numar(Caracter),!,
citeste_tot_numarul(Caracter, Numar, Caracter1). 

citeste_tot_numarul(Caracter,Numar,Caracter1):-
determina_lista(Lista1,Caracter1),
append([Caracter],Lista1,Lista),
transforma_lista_numar(Lista,Numar).

determina_lista(Lista,Caracter1):-
get_code(Caracter), 
(caracter_numar(Caracter),
determina_lista(Lista1,Caracter1),
append([Caracter],Lista1,Lista); 
\+(caracter_numar(Caracter)),
Lista=[],Caracter1=Caracter). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rest_cuvinte_propozitie(_,-1, []):-!.
    
rest_cuvinte_propozitie(_,Car,[]) :-Car==46, !.

rest_cuvinte_propozitie(Stream,Car,[Cuv1|Lista_cuv]) :-
citeste_cuvant(Stream,Car,Cuv1,Car1),      
rest_cuvinte_propozitie(Stream,Car1,Lista_cuv).


citeste_cuvant(_,-1,end_of_file,-1):-!.

citeste_cuvant(Stream,Caracter,Cuvant,Caracter1) :-   
caracter_cuvant(Caracter),!, 
name(Cuvant, [Caracter]),get_code(Stream,Caracter1).

citeste_cuvant(Stream,Caracter, Numar, Caracter1) :-
caracter_numar(Caracter),!,
citeste_tot_numarul(Stream,Caracter, Numar, Caracter1).
 

citeste_tot_numarul(Stream,Caracter,Numar,Caracter1):-
determina_lista(Stream,Lista1,Caracter1),
append([Caracter],Lista1,Lista),
transforma_lista_numar(Lista,Numar).


determina_lista(Stream,Lista,Caracter1):-
get_code(Stream,Caracter), 
(caracter_numar(Caracter),
determina_lista(Stream,Lista1,Caracter1),
append([Caracter],Lista1,Lista); 
\+(caracter_numar(Caracter)),
Lista=[],Caracter1=Caracter).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
transforma_lista_numar([],0).
transforma_lista_numar([H|T],N):-
transforma_lista_numar(T,NN), 
lungime(T,L), Aux is exp(10,L),
HH is H-48,N is HH*Aux+NN.

lungime([],0).
lungime([_|T],L):-
lungime(T,L1),
L is L1+1.

tab(N):-N>0,write(' '), N1 is N-1, tab(N1).
tab(0).

% 39 este codul ASCII pt '


citeste_cuvant(Caracter,Cuvant,Caracter1) :-
Caracter==39,!,
pana_la_urmatorul_apostrof(Lista_caractere),
L=[Caracter|Lista_caractere],
name(Cuvant, L),get_code(Caracter1).        

pana_la_urmatorul_apostrof(Lista_caractere):-
get_code(Caracter),
(Caracter == 39,Lista_caractere=[Caracter];
Caracter\==39,
pana_la_urmatorul_apostrof(Lista_caractere1),
Lista_caractere=[Caracter|Lista_caractere1]).

citeste_cuvant(Caracter,Cuvant,Caracter1) :-          
caractere_in_interiorul_unui_cuvant(Caracter),!,              
((Caracter>64,Caracter<91),!,
Caracter_modificat is Caracter+32;
Caracter_modificat is Caracter),                              
citeste_intreg_cuvantul(Caractere,Caracter1),
name(Cuvant,[Caracter_modificat|Caractere]).        

citeste_intreg_cuvantul(Lista_Caractere,Caracter1) :-
get_code(Caracter),
(caractere_in_interiorul_unui_cuvant(Caracter),
((Caracter>64,Caracter<91),!, 
Caracter_modificat is Caracter+32;
Caracter_modificat is Caracter),
citeste_intreg_cuvantul(Lista_Caractere1, Caracter1),
Lista_Caractere=[Caracter_modificat|Lista_Caractere1]; \+(caractere_in_interiorul_unui_cuvant(Caracter)),
Lista_Caractere=[], Caracter1=Caracter).

citeste_cuvant(_,Cuvant,Caracter1) :-                
get_code(Caracter),       
citeste_cuvant(Caracter,Cuvant,Caracter1). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
citeste_cuvant(Stream,Caracter,Cuvant,Caracter1) :-
Caracter==39,!,
pana_la_urmatorul_apostrof(Stream,Lista_caractere),
L=[Caracter|Lista_caractere],
name(Cuvant, L),get_code(Stream,Caracter1).
        

pana_la_urmatorul_apostrof(Stream,Lista_caractere):-
get_code(Stream,Caracter),
(Caracter == 39,Lista_caractere=[Caracter];
Caracter\==39,
pana_la_urmatorul_apostrof(Stream,Lista_caractere1),
Lista_caractere=[Caracter|Lista_caractere1]).


citeste_cuvant(Stream,Caracter,Cuvant,Caracter1) :-          
caractere_in_interiorul_unui_cuvant(Caracter),!,              
((Caracter>64,Caracter<91),!,
Caracter_modificat is Caracter+32;
Caracter_modificat is Caracter),                              
citeste_intreg_cuvantul(Stream,Caractere,Caracter1),
name(Cuvant,[Caracter_modificat|Caractere]).
        

citeste_intreg_cuvantul(Stream,Lista_Caractere,Caracter1) :-
get_code(Stream,Caracter),
(caractere_in_interiorul_unui_cuvant(Caracter),
((Caracter>64,Caracter<91),!, 
Caracter_modificat is Caracter+32;
Caracter_modificat is Caracter),
citeste_intreg_cuvantul(Stream,Lista_Caractere1, Caracter1),
Lista_Caractere=[Caracter_modificat|Lista_Caractere1]; \+(caractere_in_interiorul_unui_cuvant(Caracter)),
Lista_Caractere=[], Caracter1=Caracter).


citeste_cuvant(Stream,_,Cuvant,Caracter1) :-                
get_code(Stream,Caracter),       
citeste_cuvant(Stream,Caracter,Cuvant,Caracter1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
caracter_cuvant(C):-member(C,[38,45,61,62,92,94,123,124,125,44,59,58,63,33,46,41,40,95,47]). %de adaugat caracter

% am specificat codurile ASCII pentru , ; : ? ! . ) (

caractere_in_interiorul_unui_cuvant(C):-
C>64,C<91;C>47,C<58;
C==45;C==95;C>96,C<123.
caracter_numar(C):-C<58,C>=48.

inceput:-format('Salutare\n',[]),	flush_output,
				prolog_flag(argv, [PortSocket|_]), %preiau numarul portului, dat ca argument cu -a
				%portul este atom, nu constanta numerica, asa ca trebuie sa il convertim la numar
				atom_chars(PortSocket,LCifre),
				number_chars(Port,LCifre),%transforma lista de cifre in numarul din 
				socket_client_open(localhost: Port, Stream, [type(text)]),
				proceseaza_text_primit(Stream,0).
				
				
proceseaza_text_primit(Stream,C):-
				write(inainte_de_citire),
				read(Stream,CevaCitit),
				write(dupa_citire),
				write(CevaCitit),nl,
				proceseaza_termen_citit(Stream,CevaCitit,C).
				
proceseaza_termen_citit(Stream,salut,C):-
				write(Stream,'salut, bre!\n'),
				flush_output(Stream),
				C1 is C+1,
				proceseaza_text_primit(Stream,C1).
				
proceseaza_termen_citit(Stream,'I hate you!',C):-
				write(Stream,'I hate you too!!'),
				flush_output(Stream),
				C1 is C+1,
				proceseaza_text_primit(Stream,C1).
				

proceseaza_termen_citit(Stream,director(D),C):- %pentru a seta directorul curent
				format(Stream,'Locatia curenta de lucru s-a deplasat la adresa ~p.',[D]),
				format('Locatia curenta de lucru s-a deplasat la adresa ~p',[D]),
				
				X=current_directory(_,D),
				write(X),
				call(X),
				nl(Stream),
				flush_output(Stream),
				C1 is C+1,
				proceseaza_text_primit(Stream,C1).				
				
				
proceseaza_termen_citit(Stream, incarca(X),C):-
				write(Stream,'Se incearca incarcarea fisierului\n'),
				flush_output(Stream),
				incarca(X),
				C1 is C+1,
				proceseaza_text_primit(Stream,C1).
				
proceseaza_termen_citit(Stream, comanda(consulta),C):-
				write(Stream,'Se incepe consultarea\n'),
				flush_output(Stream),
				scopuri_princ(Stream),
				C1 is C+1,
				proceseaza_text_primit(Stream,C1).
				
proceseaza_termen_citit(Stream, X, _):- % cand vrem sa-i spunem "Pa"
				(X == end_of_file ; X == exit),
				write(gata),nl,
				close(Stream).
				
			
proceseaza_termen_citit(Stream, Altceva,C):- %cand ii trimitem sistemului expert o comanda pe care n-o pricepe
				write(Stream,'ce vrei, neica, de la mine?! '),write(Stream,Altceva),nl(Stream),
				flush_output(Stream),
				C1 is C+1,
				proceseaza_text_primit(Stream,C1).
	
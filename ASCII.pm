package Lingua::DE::ASCII;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(to_ascii to_latin1);
our %EXPORT_TAGS = ( 'all' => [ @EXPORT ]);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our $VERSION = '0.13';

our %ANSI_TO_ASCII_TRANSLITERATION = (qw(
        � !
        � ct
        � Lb
        � EUR
        � Yen
        � S
        � �
        � s
        � a
        � <<
        � --|
        � -
        � -
        � �
		� +-
		� ^2
		� ^3
        � >>
		� 1/4
        � 1/2
        � 3/4
        � ?
        � .
		� ^1
        � �
		� a
		� A
		� a
        � A
		� a
		� A
		� a
		� A
		� a
		� A
		� ae
		� Ae
		� ae
		� Ae
		� c
		� C
		� D
		� p
		� e
		� E
		� e
		� E
		� e
		� E
		� e
		� E
		� i
		� I
		� i
		� I
		� i
		� I
		� i
		� I
		� n
		� N
		� o
		� o
		� O
		� o
		� O
		� o
		� O
		� o
		� O
		� oe
		� Oe
		� oe 
		� Oe
		� P
		� ss 	
		� ue
		� u
		� U
		� u
		� U
		� u
		� U
		� ue
		� Ue
		� x
		� y
		� Y
		� y
		� th
		� Th
        ),
	     ("�" => "'",
	      "�" => ",",
          "�" => "(R)",
          "�" => "(C)",
          chr(160) => ' ')
    );

# remove all unknown chars
$ANSI_TO_ASCII_TRANSLITERATION{$_} = ''
     for (
       grep { !defined( $ANSI_TO_ASCII_TRANSLITERATION{$_} ) }
         map { chr $_ } ( 128 .. 255 )
     );

sub to_ascii($) {
    my $text = shift;
    return unless defined $text;
    $text =~ s/([\200-\377])/$ANSI_TO_ASCII_TRANSLITERATION{$1}/g;
                #\octal => \200 = 128, \377 => 255
    return $text;
}

my %mutation = qw(
    ae �
    Ae �
    oe �
    Oe �
    ue �
    Ue �
);

my $vocal = qr/[aeiou���AEIOU���]/;
my $consonant = qr/[bcdfghjklmnpqrstvwxzBCDFGHJKLMNPQRSTVWXZ]/;
my $letter = qr/[abcdefghijklmnopqrstuvwxyz���ABCDEFGHIJKLMNOPQRSTUVWXYZ���]/;

my $prefix = qr/(?=[\w������]\w)   # to improve speed

                (?:[Aa](?:[nb]|u[fs]|bend)|
                   [Bb]e(?:reit|i|isammen|vor|)|
                   [Dd](?:a(?>f�r|neben|rum|r|)|
                       icke?|
                       rin|
                       urch|
                       rei
                    )|
                   [Ee](?:r|
                          in|
                          nt|
                    )|
                   [Ff]e(?:hl|st)|
                   [Ff]rei|
                   (?:[Gg](?:erade|
                             leich|
                             ro�|
                             ross)
                   )|
                   [Ll]os|
                   [Gg]e(?:heim(?:nis)?)?|
                   [Gg]enug|
                   [Gg]ut|
                   [Hh](?:alb|eraus|erum|in(?:(?:un)?ter)?)|
                   [Kk]rank|
                   [Kk]und|
                   [Mm]ehr|
                   [Mm]it|
                   [Nn]ach|
                   [Nn]icht|
                   [Nn]eun|
                   (?:[Ss](?:ch�n|till|tramm))|
                   [Tt]ot|
                   [Uu]m|
                   [Vv][eo]r|
                   [Vv]ier(?:tel)?|
                   [Ww]e[gh]|
                   [Ww]ichtig|
                   [Uu]n|
                   [Zz]u(?:r�ck|sammen)?|
                   [Zz]wei|
                   [��]ber
                )
               /x;

my $town_with_a = qr/[Ff]uld|
                     [Aa]lton|
                     [Gg]han|
                     [Gg]oth|
                     [Ll]ausch|
                     [Mm]oden|
                     [Nn]izz|
                     [Pp]anam|
                     [Pp]arm|
                     [Rr]ig|
                     [Ss]myrn|
                     [Ss]ofi/x;

my $town_with_o = qr/[Kk]air|
                     [Oo]sl|
                     [Tt]og|
                     [Tt]oki/x;
                     
sub to_latin1($) {
    local $_ = shift;
    return unless defined;

	if (/[Aa]e/) {
	    s/ (?<! [Gg]al)               # Galaempf�nge
    	   (?<! [Jj]en)               # Jenaer Glas  
           (?<! Dek)                  # Dekaeder
           (?<! [^n]dek)
           (?<! [Hh]ex)
           (?<! [Ii]kos)
           (?<! [Tt]etr)
           (?<! [Oo]kt)
           (?<! [Mm]eg)
           (?<!  Pent)                # upper case, because of Gruppent�ter
           (?<! [Ss]of)               # Sofaecke
           
           ae
           
           (?=[\w�\.])                     # no � at the end of a word
           
           (?!rleb)                   # e.g. Ahaerlebnis
           (?!rreg[^i])               #      Malariaerreger
           (?!n\b)                    # even not if in plural
           (?!pid)                    # Choleraepidemie
           (?!in)                     # Kameraeinstellung
           (?!lit)                    # dingsda-elit
           (?!lem)                    # ...element
     	 /�/gx;

        s/(?<=[rtz])ae(?=n\b)/�/g;                # Eoz�n, Kapit�n, Souver�n
        
        s/phorae/phor�/g;             # Epiphor�
        s/kenae/ken�/g;               # Myken�
        s/ovae\b/ov�/g;
        
        s/($town_with_a)�r/$1aer/g;
        
        s/(?<=[mr])�(?=ls?\b|li)/ae/g; # Mari�
        s/(?<=\b[Pp]r)ae/�/g;         # Pr�...
        s/(?<=bd)ae(?=n)/�/g;         # Molybd�n
        s/(?<=[^Aa]ns)
          (?<!kens)
          (?<!eins)
          �
          (?![uetg])      # Mensaessen != Ameisens�ure, Ans�en, Ans�gen
          (?![fm]t|         # Bratens�fte, ...�mter
              ngs|        # ...-�ngste
              r[gz]|         # ...-s�rge, ...-�rzte
              c[kh]|         # ...-s�cke
              n[dgk]e|         # ...-�nderung, ...-�nge, ... -s�nke
              [lh�]e          #s�le, ... s�he, s��e
          )
         /ae/gx; 
        
        s/\bAe(?!r[oiu])/�/gx;         # Ae at beginning of a word, like Aerobic != �ra, �ren
    }

	if (/[Oo]e/) {
	    # oe => �
    	s/(?<! [bB]enz )             # Benzoes�ure 
	      (?<! [Bb]ru tt)            # Bruttoertr�ge
	      (?<! [Nn]e tt)             # Nettoertr�ge
	      (?<! [^e]ot)               # Fotoelektrizit�t != Stereot�ne
	      (?<! iez)                  # Piezoelektronik
		  (?<! [Tt]herm)                 # Thermoelektrizit�t
          (?<! [Bb]i)                # Bio...
          (?<!  [kc]tr)                 # Elektro..., 
          (?<! [Gg]astr)               
          (?<! [Mm]ikr)              # Mikro...
          (?<! [Ff]err)              # ferro
          (?<! [Rr]homb)
          (?<! [Tt]rapez)
          (?<! [Hh]ydr)              # Hydro-...
	      (?<! \b[Cc])               # coeditor or so
          (?<! \b[Ss]h)                # must be English
          (?<! c)                    # c� doesn't exist in German
          ( [oO] e )
	      (?=[\w�\.])                     # � not at the end of words
          (?! [uy])
          (?!ffi[^gn])                     # Koeffizent  != H�ffige, Sch�ffin, ...effekt
          (?!ffek)                   # ..effekt
          (?!rot)                    # �rot
          (?!le[cm])                    # element
          (?!rgo)                    # ergometer
          (?!mpf)                    # empfang
          (?!ia)                     # typical for latin words e.g. pharmacopoeia
          (?!last)                   # elastic
          (?![fv]sk[iy])             # Dostoevsky e.g.
          (?! c$vocal)               # economic, ...
         /$mutation{$1}/egx;
         
         s/($town_with_o)�r/$1oer/g;
	 }
    
	if (/[Uu]e/) {
	    # ue => �, but take care for 'eue','�ue', 'aue', 'que'
    	s/(?:(?<![oa�eA�EqQzZ]) | 
        	 (?<=nde) | 
	         (?<=ga)  |                 # Joga�bung
    	     (?<=era) |                 # kamera�berwachte
	    	 (?<=ve)  |                 # Reserve�bung
             (?<=deo) |                 # video�ber...
             (?<=ldo) |                 # Saldo�ber...
   	 	     (?<=(?<![eEfFgGtT])[rR]e) |	  	# Re�ssieren, but not treuem
	         (?<=$vocal ne)|             # Routine�berpr�fung 
             (?<=[Vv]orne)              # vorne�ber
    	   )
           (?<![Ss]tat)              # Statue
           (?<!x)                    # Sexuelle
           (?<![Cc]r)
           ( [uU] e )
           (?= [\w�\-])                   # no � at the end of a word
	       (?! [iy])                    # Zueilende - �-...
           (?! llst\w)                 # Spirituellste
           (?! nce)                    # influence e.g.
           (?! ntia)
           (?! s?day)                  # English days
           (?! some)                   # ...
          /$mutation{$1}/egx;
         
        s/(?<=[Zz])ue(?=g | n[dfgs] | c[hk] | be[lr] | rn[^t] | ri?ch | bl)/�/gx; 
        s/(?<=z)ue(?=rnte?[mnrs]?t?\b)/�/g;
        s/(?<=\b[Aa]bz)�(?=rnt)/ue/g;        # Abzuerntende
        s/v�n\b/vuen/g;
        s/(?<=ga)�(?=r(in)?)\b/ue/g;      # ...gauer like Argauer, Thurgauer, ...
         
        {no warnings;
            s/((?:${prefix}|en)s)?(([tT])�n(de?|\b))(?!chen|lein|lich)
             /$1 ? "$1$2" : "$3uen$4"/xgeo;# Gro�tuende, but abst�nde, St�ndchen
        }
        s/($prefix s? t)�(r(ische?[mnrs]?|
                           i?[ns](nen)?)?\b)/$1ue$2/gx;
        s/($prefix t)�(?=s?t\b|risch)/$1 ? "$1ue" : "$1�"/gxe;  # zur�cktuest, gro�tuerisch 
        s/gr�nz/gruenz/g;
        s/(?<!en)�(s?)(?![\w�])/ue$1/g;   # Im deutschen enden keine Worte auf �, bis auf Ausnahmen
        s/z�(?!rich)([rs][befhiosz�])/zue$1/g; # Zuerz�hlende != z�richerisch
    
        s/([uU] e) (?=bt)/$mutation{$1}/egx;  # �bte
        s/(?<=[Dd])�(?=ll)/ue/g;              # Duell
        s/e�rt/euert/g;   # geneuert
        s/re�(?=[nv]|s?t)/reue/g;   # reuen
        
        s/
          ([Au]ssen|
           [Dd]oppel|
           [Dd]reh|
           [Ee]ingangs|
           [Ee]ntree|
           [Ee]tagen|
           [Ff]all|
           [Gg]eheim|
           [Hh]aus|
           [Hh]inter|
           [Kk]eller|
           [Kk]irchen|
           [Kk]orridor|
           [Nn]ot|
           [Oo]fen|
           [Pp]endel|
           [Ss]aal|
           (?:[Ss]ch(?:iebe|
                       rank|
                       wing))|
           [Ss]eiten|
           [Tt]apeten|
           [Vv]erbindungs|
           [Vv]order|
           [Ww]agen|
           [Ww]ohnungs|
           [Zz]wischen) tuer (?!isch)/$1t�r/gx;

        s/(?<=[a-z����])�(?=[A-Z���])/ue/g;  # e.g. "IssueType"
    }
	
	if (/ss/) {
   	     # russ => ru�
    	 s/(?<=(?<![dD])(?<!sau)(?<![Vv]i)[rRfF][u�])  # Brachosaurusses, Virusses
	       ss 
    	   (?! el) (?! le)                    # Br�ssel, Br�ssler
      	   (?! isch)                          # Russisch
           (?! land)                          # Ru�land
           (?! tau)
           (?! [oy])
           (?! ia)
          /�/gx;
          
         # ss => � with many exceptions
         s/(?<= $letter{2})
           (?<! $consonant $consonant)
           (?<! (?<! [��bBfFmMsSeE] ) [u�] )  # b��en, Fu�, ..., but Fluss
           (?<! [Mm] u)   # musst, musste, ...
           (?<! su)
           (?<! [bBdDfFhgGHkKlLmMnNpPrRsStTuUvVwWzZ] i )   # 'wissen', -nisse,
           (?<! [dgsklnt] )
           (?<! [bBdDfFgGhHiIjJkKnNtTwWlLpPvV] a )     # is a short vocal
           (?<! (?<![Ss]t) (?<![fF]) [rR]a)                # Rasse != Stra�e, fra�en
           (?<! [Qq]u a)
           (?<! [bBfFgGhHlLnNpPsSwW] �)          # (short vocal) Abl�sse, 
           (?<! [cCdDfFgGhHjJlLmMnNpPrsStTvVwWzZ] e )           # is very short vocal
           (?<! sae)                             # Mensaessen
           (?<! ion )                            # Direktionssekret�rin
           (?<! en )                             # dingenssachen 
           (?<! [fFhHoO] l o)
           (?<! (?<![gG]) [rR] o)                # Ross-Schl�chter, but Baumgro�e          
           (?<! [bBdDgGkKmMnNpPzZ] [o�])
           (?<! [sS]chl �)
           (?<! [bBkKuU]e)                       # Kessel
           (?<! [yj])
	       (?<! [br]r $vocal)
           (?<! [Pp]r ei)

           ss

           (?! ch )
           (?! isch )                        # gen�ssisch
           (?! t[��o])                   
           (?! tr[ao])   # Davisstra�e, but Schwei�treibende, ...-stroh
           (?! treif)
           (?! tur)   # Eissturm, but Schwei�tuch
	       (?! t�(?:ck|[hr]))  # Beweisst�ck,  Bischofsst�hle, Kursst�rze, but Schwei�t�cher
	       (?! tau?[bd])   # Preisstabilit�t, ...-stadt
           (?! ist)   # Di�tassistentin
           (?! te[pu])   # ...steppe, ...steuern
           (?! eins?\b)   # ...-sein
           (?! eit)
           (?! ett)
           (?! i[vl])    # Massiv, Fossil
           (?! l?ich)  # gr�sslich  ...sicherung
	       (?! �ge)   # Kreiss�ge
	       (?! �[tu])    # Siegess�ule, Tagess�tze
           (?! ier)   # K�rassier
           (?! ag)   # Massage, lossagen
           (?! ard)   # Bussard
           (?! p [���i]) # K�s-sp�tzle, # ...-spitze
           (?! pr[e�ai])                   # losspr�che, sprechen, sprach
           (?! [oy])
           (?! eh)    # ...-seh, setzen
           (?! itz)   # ...-sitz
           (?! ist)
           (?! ees?\b) # ... -see
           (?! aise)  # foreign words don't have an �
           (?! age)
           (?! agte)  # ...-sagte
           (?! upp)   # ...-suppe
           (?! anc) # Renaissance
           (?! egn)  # ...-segne
	       (?! eur)  # Connosseur or so
          /�/gxo;
          
          s/(?<= [AaEe]u)                        # drau�en
	        ss 
            (?! [���]) 
            (?! e[ehg])                             # Chaussee, ...seh
            (?=\b|e|l)
		  /�/gxo;                    # scheu�lich 

         s/((?<=[fs][������]) |
            (?<=[Ss]p[a�])    
		   )                      # ends on long vocal plus ss, like
           ss                                  # Gef�� != Schluss
          (?! [���])
          (?! er)                           # Gef��e != F�sser
          (?! iv)
          (?=\b|e|$consonant)                 # end of word or plural or new composite (Gef��verschluss)
         /�/gxo;
         
         s/(?<=verg[�a])ss(?=e|\b)/�/g;  # verg��e

        s/(?<!chlo)                                # Schloss
          (?<! (?<![gG]) [rR] o)
          (?<! [bBpPgG] o )  # goss, Boss
          ((?<=o) |(?<=ie))          # Flo�, gro�, Grie�brei, Nu�, but no Ross-Schl�chter 
          ss
          (?! ch)
          (?! t? [���])
          (?! teu)
          (?! pr[�eai])                   # losspr�che
          (?=\b|es|$consonant)
        /�/gxo;
        s/(�u|(?<!chl)�)sschen/$1�chen/go;
        
        s/(?<=[bBeEnN][Ss]a)ss(?=\b|en)/�/g; # absa�, beisammensa�en
        s/($prefix)sass/$1sa�/g;

        s/(?:(?<=[mM][ai])|(?<=[Ss]�)|(?<=[Ss]t�)|(?<=[Ww]ei))ss(?=ge|lich)/�/go;
        
        s/(?<=[Gg]ro) ss (?=t|$vocal) (?!ist)/�/gx;   # gro�t�te, gro�-o...
        s/(?<=[Ss]pa) ss (?!ion) (?!age) (?!iv)/�/gx;         # spa�ig, but not Matth�uspassion

        
        if (/�/) {
            s/(?<=[mM][u�])�(?=te|en|er)/ss/go;
            s/($prefix|en)?([Ss]a)�([ea])/$1 ? "$1$2�$3" : "$2ss$3"/goe;  
                     # Gef�ngnisinsasse, Sassafra != aufsa�en, beisammensa�en

            s/(?<=[rR] [a�]) (?<![Gg]r�) � (?=l |e [rl](?!$vocal) | chen)/ss/gxo;      # R�sser, R�ssel
    
	        s/(?<=(?<![GgPp])
	              (?<![Bb]e)
		          (?<![Ee]nt)
    		      (?<![Vv]er)
	    	      [Rr]u
	          )
    	      �
	          (?=[ei](?![sg])(?>nnen|n|)(\b|\S{5,}))
	        /ss/gxo;  # Russe, Russin, != Pru�e, != Gru�, != Beru�en, != Entru�en, != Ru�es, != Ru�ige
            s/Ru�ki/Russki/g;
            
            #s/(?<=[rb])�(?=[tpy])/ss/g;
            s/(?<=$consonant)�(?=$consonant|y)/ss/g;
            s/(?<=[^i]e)�(?=en)/ss/g;
            s/(?<=[Aa]u)�(?=end(?!i)|etz)/ss/g;
            s/(?<!�)u�(?=el|lig)/uss/g;  # Fussel
            s/(?<=[gG]lo)�/ss/g;
            s/(?<=sa)�(?=in)/ss/g;
            s/(?<=\b[Mm][aou])
              �
              (?!et)         # ma�et
              (?=$vocal$consonant|[ae][iy]|eu)
             /ss/gx;  # Massai, Massaker, Massel, Mossul, Musselin
            s/Ma�e/Masse/g;
            s/ma�(?=el|ak|ig)/mass/g;
            s/\bma�(?=en\w)/mass/g;
            s/(ten)ma�/$1mass/g; 
            s/((?:\b|$prefix)flo)�/$1ss/g;
        }
        
        s/($prefix)?scho(ss|�)/$1 ? "$1schoss" : "scho�"/ge;
	}

    # symbols
    s/\(R\)/�/g;
    s/\(C\)/�/g;

    # special characters
    s/<<(\D*?)>>/�$1�/g;    # if there are numbers between,
    s/>>(\D*?)<</�$1�/g;    # it could be also a mathematical/physical equation

    # foreign words
    s/cademie/cad�mie/g;
    s/rancais/ran�ais/g;
    s/leen/l�en/g;
    s/grement/gr�ment/g;
    s/lencon/len�on/g;
    s/Ancien Regime/Ancien R�gime/g;
    s/Andre(?=s?\b)/Andr�/g;
    s/Apercu/Aper�u/g;
    s/([aA])pres/$1pr�s/g;
    s/Apero/Ap�ro/g;
    s/Aragon/Arag�n/g;
    s/\bdeco\b/d�co/g;
    s/socie(?=\b|s)/soci�/g;
    s/([aA])suncion/$1sunci�n/g;
    s/([aA])ttache/$1ttach�/g;
    s/Balpare/Balpar�/g;
    s/Bartok/Bart�k/g;
    s/Baumegrad/Baum�grad/g;
    s/Beaute/Beaut�/g;
    s/Epoque/�poque/g;
    s/Bj�rnson/Bj�rnson/g;
    s/Bogota/Bogot�/g;
    s/Bokmal/Bokm�l/g;
    s/Boucle/Boucl�/g;
    s/rree/rr�e/g;
    s/Bruyere/Bruy�re/g;
    s/Bebe/B�b�/g;
    s/echamel/�chamel/g;
    s/Beret/B�ret/g;
    s/([cC])afe/$1af�/g;
    s/([cC])reme/$1r�me/g;
    s/alderon/alder�n/g;
    s/Cam�s/Cam�es/g;
    s/anape/anap�/g;
    s/Cano�a/Canossa/g;
    s/celebre/c�l�bre/g;
    s/tesimo/t�simo/g;
    s/eparee/�par�e/g;
    s/Elysee/�lys�e/g;
    s/onniere/onni�re/g;
    s/Charite/Charit�/g;
    s/inee/in�e/g;
    s/hicoree/hicor�e/g;
    s/Chateau/Ch�teau/g;
    s/Cigany/Cig�ny/g;
    s/Cinecitta/Cinecitt�/g;
    s/Cliche/Clich�/g;
    s/Cloisonne/Cloisonn�/g;
    s/Cloque/Cloqu�/g;
    s/dell\'Arte/dell�Arte/g;
    s/Communique/Communiqu�/g;
    s/Consomme/Consomm�/g;
    s/d\'Ampezzo/d�Ampezzo/g;
    s/d\'Etat/d�Etat/g;
    s/Coupe/Coup�/g;
    s/Cox\'Z/Cox�/g;
    s/Craquele/Craquel�/g;
    s/roise/rois�/g;
    s/(?<! l)
      (?<! pap)
      iere\b
     /i�re/g;

    s/([cC])reme/$1r�me/g;
    s/fraiche/fra�che/g;
    s/Crepe/Cr�pe/g;
    s/Csikos/Csik�s/g;
    s/Csardas/Cs�rd�s/g;
    s/Cure/Cur�/g;
    s/Cadiz/C�diz/g;
    s/Centimo/C�ntimo/g;
    s/Cezanne/C�zanne/g;
    s/Cordoba/C�rdoba/g;

    s/Dauphine/Dauphin�/g;
    s/Dekollete/Dekollet�/g;
    s/ieces/i�ces/g;
    s/troch�u�/troch�uss/g;
    s/Drape/Drap�/g;
    s/m��(?=[et])/m�ss/g;
    s/Dvorak/Dvor�k/g;
    s/([dD])eja/$1�j�/g;
    s/habille/habill�/g;
    s/Detente/D�tente/g;

    s/Ekarte/Ekart�/g;
    s/El Nino/El Ni�o/g;
    s/Epingle/Epingl�/g;
    s/Expose/Expos�/g;
    s/Faure/Faur�/g;
    s/Filler/Fill�r/g;
    s/Siecle/Si�cle/g;
    s/l��el/l�ssel/g;
    s/Bergere/Berg�re/g;
    s/Fouche/Fouch�/g;
    s/Fouque/Fouqu�/g;
    s/elementaire/�l�mentaire/g;
    s/ternite(s?)\b/ternit�$1/g;
    s/risee/ris�e/g;
    s/roi(�|ss)e/roiss�/g;
    s/\bFrotte(?=\b|s\b)/Frott�/g;
    s/Fume/Fum�/g;
    s/([Gg])arcon/$1ar�on/g;
    s/([Gg])ef�ss/$1ef��/g;
    s/Gemechte/Gem�chte/g;
    s/Geneve/Gen�ve/g;
    s/Glace/Glac�/g;
    s/Godemiche/Godemich�/g;
    s/Godthab/Godth�b/g;
    s/(?<=[Gg])�(?=th)/oe/g;
    s/lame(?=\b|s)/lam�/g;
    s/uyere/uy�re/g;
    s/Grege/Gr�ge/g;
    s/Gulyas/Guly�s/g;
    s/abitue/abitu�/g;
    s/Haler/Hal�r/g;
    s/ornuss/ornu�/g;
    s/Horvath/Horv�th/g;
    s/Hottehue/Hotteh�/g;
    s/Hacek/H�cek/g;
    s/matoz�n/matozoen/g;
    s/chlosse(?![rsn])/chlo�e/g;
    s/doree/dor�e/g;
    s/Jerome/J�r�me/g;
    s/Kodaly/Kod�ly/g;
    s/�rzitiv/oerzitiv/g;
    #s/nique/niqu�/g;
    s/Kalman/K�lm�n/g;
    s/iberte/ibert�/g;
    s/Egalite/�galit�/g;
    s/Linne/Linn�/g;
    s/([fF])asss/$1a�s/g;
    s/Lome/Lom�/g;
    s/Makore/Makor�/g;
    s/Mallarme/Mallarm�/g;
    s/aree/ar�e/g;
    s/Maitre/Ma�tre/g;
    s/([Mm]$vocal)liere\b/$1li�re/g;
    s/Mouline/Moulin�/g;
    s/Mousterien/Moust�rien/g;
    s/Malaga/M�laga/g;
    s/Meche/M�che/g;
    s/erimee/�rim�e/g;
    s/eglige/eglig�/g;
    s/eaute/eaut�/g;
    s/egritude/�gritude/g;
    s/anache/anach�/g;
    s/Pappmache/Pappmach�/g;
    s/Parana/Paran�/g;
    s/Pathetique/Path�tique/g;
    s/Merite/M�rite/g;
    s/([Pp])reuss/$1reu�/g;
    s/otege/oteg�/g;
    s/recis/r�cis/g;
    s/P�rilit�t/Puerilit�t/g;
    s/Ratine/Ratin�/g;
    s/Raye/Ray�/g;
    s/Renforce/Renforc�/g;
    s/Rene/Ren�/g;
    s/Rev�/Revue/g;
    s/Riksmal/Riksm�l/g;
    s/xupery/xup�ry/g;
    s/S(?:�|ae)ns/Sa�ns/g;
    s/Jose(?=s?\b)/Jos�/g;
    s/bernaise/b�rnaise/g;
    s/Sassnitz/Sa�nitz/g;
	s/Saone/Sa�ne/g;
	s/Sch�nt�r/Sch�ntuer/g;   # more probable
	s/ch��ling/ch�ssling/g;
	s/Senor/Se�or/g;
	s/Skues/Sk�s/g;
	s/Souffle(?=s|\b)/Souffl�/g;
	s/Spass/Spa�/g;
	s/(?<=[Cc])oupe/oup�/g;
	s/St�l\b/Sta�l/g;
	s/Suarez/Su�rez/g;
	s/Sao\b/S�o/g;
	s/Tome(?=s|\b)/Tom�/g;
	s/Seance/S�ance/g;
	s/Serac/S�rac/g;
	s/Sevres/S�vres/g;
	s/Stassfurt/Sta�furt/g;
	s/(?<=Troms)(�|oe)/�/g;
	s/Trouvere/Trouv�re/g;
	s/T�nder/T�nder/g;
	s/ariete/ariet�/g;
	s/Welline/Wellin�/g;
	s/Yucatan/Yucat�n/g;
	s/((?<!\w)$prefix g)ass(?!$vocal)/$1a�/gx;
	s/((?<!\w)$prefix)ass/$1a�/gx;
    s/((?<!\w)$prefix)�sse/$1��e/g;
    s/(\A|\W)�sse/$1��e/g;
	s/($prefix) (?<![Ee]in)    # != einfl��en
                (?<![Ee]inzu)  #    einzufl��en
       fl��(e(n?|s?t))\b
      /$1fl�ss$2/gx;   # exception of rule
    s/(${prefix}|\b)sch��e/$1sch�sse/go; # also an exception
    {no warnings; s/($prefix)?spr��e/$1spr�sse/go;}
    s/($prefix)dr��e/$1dr�sse/g;
	s/\bass(?=\b|en\b)/a�/go;  # a�
    s/\^2/�/go;
    s/\^3/�/go;
    s/gemecht/gem�cht/go;
    s/(?<=[Hh])ue\b/�/g;
    s/a�elbe/asselbe/g;
    s/linnesch/linn�sch/g;
    s/(?<=\b[Mm]u)ss(?=t?\b)/�/g;
    s/mech(?=e|s?t)/m�ch/g;
    s/metallise/m�tallis�/g;
    s/(?<![\w����])la([\s[:punct:]]+)la(?![\w����])/l�$1l�/g;
    s/(?<=\b[Oo]l)e\b/�/g;
    s/peu(\W+)a(\W+)peu/peu$1�$2peu/g;
    s/reussisch/reu�isch/g;
    s/sans gene\b/sans g�ne/g;
    s/(?<=\b[Ss]a)ss(?=(en|es?t)\b)/�/g;
    s/\bskal\b/sk�l/g;
    s/(?<=\bst)ue(?=nde)/�/g;
    s/(?<=[Tt]sch)ue(?=s)/�/g;
    s/([Tt])ete-a-([Tt])ete/$1�te-�-$2�te/g;
    s/voila/voil�/g;
    s/Alandinseln/�landinseln/g;
    s/Angstr�m/�ngstr�m/g;
    s/Egalite/�galit�/g;
    s/(?<=[Ll]and)bu�e/busse/g;
    s/\b(?<![�������])a(?=\W+(?:condition|deux mains|fonds perdu|gogo|jour|la)\b)/�/g;
    s/(?<![\w�������])a discretion/� discr�tion/g;
    s/(?<=[Bb]ai)�(?=e)/ss/g;
    s/(?<=[Hh]au)�(?=e)/ss/g;
    s/\bue\./�./g;
    s/�berflo�/�berfloss/g;
    s/\blo�(?!\w)/loss/g;
    s/�chm/Aechm/g;  # e.g. Aechmea
    s/(?<=[Aa]n)�(?=ro)/ae/g;
    s/pr�ter/praeter/g;
    s/Anaphorae/Anaphor�/g;
    s/B�deker/Baedeker/g;
    s/Aspiratae/Aspirat�/g;
    s/ham�r(?=(?:[sn]|in|innen)?\b)/hamaer/g;   # Bahamer, Bahamerin and similar
    s/(?<=[Pp])�(?=se)/ae/g;  # Bel Paese
    s/C�lius/Caelius/g;
    s/(?<=Famul)ae\b/�/g;
    s/(?<=F)�(?=ce)/ae/g;  # Faeces
    s/((Gan)?[Gg])raen/$1r�n/g;
    s/(?<=[gG]r)�(?=c(?:um|as))/ae/g;
    s/H�ckel/Haeckel/g;
    s/Intimae/Intim�/g;
    s/Kannae/Kann�/g;
    s/Klavikulae/Klavikul�/g;
    s/Kolossae/Koloss�/g;
    s/Konjunktivae/Konjunktiv�/g;
    s/L�rtes/Laertes/g;
    s/ariae\b/ari�/g;
    s/\bM�st(?![eu])/Maest/g;
    s/r�cox/raecox/g;
    s/ich�l/ichael/g;
    s/(?<=[Ss])ae(?=nger)/�/g;
    s/(?<=[Pp])�(?=lla)/ae/g;
    s/Ph�t/Phaet/g;
    s/(?<=\b[Rr]a)                         # Raphael, Raffael ...
      (ff?|ph)�l/$1ael/gx;       # != Niagaraf�llen
    s/($prefix)saesse/$1s��e/g;
    s/(?<!ph)�(?=ro[bds])/ae/g;
    s/T�kwondo/Taekwondo/g;
    s/mondaen/mond�n/g;
    s/o\.ae\./o.�./g;
    s/Al�/Aloe/g;
    s/Apn�/Apnoe/g;
    s/B�ing/Boeing/g;
    s/�c\./oec./g;
    s/Her�/Heroe/g;
    s/H�k\b/Hoek/g;
    s/z�n\b/zoen/g;
    s/obszoen/obsz�n/g;
    s/Itzeh�/Itzehoe/g;
    s/J�l/Joel/g;
    s/(?<=[Kk])�(?=du|x)/oe/g;   # Koedukation, ...
    s/Ob�/Oboe/g;
    s/(?<=i)oe(?=se?[mnr]?)/�/g;
    s/(?<=\b[Pp])�(?=bene|[mt]|sie)(?!tt)/oe/g;
    s/($prefix)p�(?=bene|[mt]|sie)(?!tt)/$1poe/g;
    s/Pr�(?=[^bps])/Proe/g;
    s/stroeme/str�me/g;
    s/Crus�/Crusoe/g;
    s/Z�(?!\w)/Zoe/g;
    s/s�ben/soeben/g;
    s/Airbu�e/Airbusse/g;
    s/pio�es/piosses/g;
    s/Cottbu�/Cottbuss/g;
    s/Globu�/Globuss/g;
    s/Beisa�e/Beisasse/g;
    s/Boru�ia/Borussia/g;
    s/Bra�/Brass/g;
    s/Cai�a/Caissa/g;
    s/(?<=c$vocal)�(?=$vocal)/ss/g;
    s/(?<=[Bb]u)�(?=erl)/ss/g;
    s/(Cr?a)�(?=ata|i|us)/$1ss/g;
    s/(?<=[CZ]erberu)�/ss/g;
    s/Croi�ant/Croissant/g;
    s/Diglo�ie/Diglossie/g;
    s/(?<=\b[Ee]i)�(?=\w)/ss/g;
    s/Elsa�/Elsass/g;
    s/��/ss�/g;
    s/rima�e/rimasse/g;
    s/olo�/oloss/g;
    s/(?<=[Ll]ai)�/ss/g;  # Laissez-faire
    s/a�achu/assachu/g;
    s/fu�(?=l[ei])/fuss/g;
    s/gro�o/grosso/g;
    s/kt�l/ktuel/g;
    s/(?<=nn)�(?=lle)/ue/g;
    s/(?<=[gj])�(?=z\b)/ue/g;
    s/BDUe/BD�/g;
    s/n�n\b/nuen/g;
    s/g�(?=(tt|rr)[ei])/gue/g;
    s/(?<=\b[Bb]l)�(?=(?!\w)|[bfgjp]|movie|stock|chip)/ue/g; # Blue- [cjb...] is untypical for german, bl�men but is
    s/(?<=[Mm]en)ue/�/g;
    s/B�nos/Buenos/g;
    s/Deng�/Dengue/g;
    s/n�ndo(?=\b|s)/nuendo/g;
    s/(?<=b)�(?=nt([ei]n(nen)?)?\b)/ue/g;
    s/D�nja/Duenja/g;
    s/(?<=[Dd])�tt/uett/g;
    s/man�l/manuel/g;
    s/(?<=[Ff]ond)�/ue/g;
    s/F�rte/Fuerte/g;
    s/G�ricke/Guericke/g;
    s/(?<=[Gg])�(?=rill)/ue/g;
    s/G�rnica/Guernica/g;
    s/(?<=[vs]id)�(?=n)/ue/g;
    s/fl�nz/fluenz/g;
    s/ongr�n/ongruen/g;
    s/t�nte/tuente/g;
    s/t�lle/tuelle/g;
    s/([\w�������]+t)�ll/$1 eq lc($1) ? "$1uell" : "$1�ll"/gex; #eventuell != H�kelt�ll    
    s/Event�ll/Eventuell/g;
    s/Lang�/Langue/g;
    s/Man�l/Manuel/g;
    s/Mig�l/Miguel/g;
    s/en�tt/enuett/g;
    s/g�rite/guerite/g;
    s/in�nd/inuend/g;
    s/(?<=[Gg])�(?=st)/ue/g;
    s/(?<=[Pp])�(?=blo)/ue/g;
    s/(?<=[Pp])�(?=rto)/ue/g;
    s/Re�(?=[nv])/Reue/g;
    s/Sam�l/Samuel/g;
    s/S�ve/Sueve/g;
    s/S�z/Suez/g;
    s/(?<=[Tt])�(?=rei)/ue/g;
    s/�rdingen/Uerdingen/g;
    s/�cker/Uecker/g;
    s/s�ll/suell/g;
    s/nn�ll/nnuell/g;
    s/(?<!\w)�(?=ron)/ae/g;       # aeronautic e.g.
    s/\beinz�ng/einzueng/g;
    s/\bt�(?=s?t\b)/tue/g;
    s/Zei�/Zeiss/g;          # I'm coming from Jena, Zeiss' hometown and that
                             # really looks better :-)
    s/(?<=airma)�/ss/g;
    s/D�da/Daeda/g;
    s/B�na/Buena/g;
    s/(?<=can)�/oe/g;        # english for "Kanu"
    s/(canv|carc)a�/$1ass/g;      # english for "pr�fend", ...
    s/Ca�andra/Cassandra/g;
    s/Citr(oe|�)n/Citro�n/g; 
    s/\bd�mon\b/daemon/g;        # lowercase is wrong German (but not for "d�monenhaft"), thus it must be the english version
    s/([A-Z���]*)(Ae|Oe|Ue)\b/$1$mutation{$2}/g;   # must be an abbreviation ending on �,�,�   
    s/jo�/joss/g;
    s/Su�ex/Sussex/g;
    s/(?<![Oo])([Bb]|rh)oe\b/$1�/g;   # ...-rrh�, Windb�, != Oboe
    s/Malmoe/Malm�/g;
    s/(fl|tr?)�nt\b/$1uent/g;
    s/g�se/guese/g;
    s/(?<=[sh])�(?=ver)/oe/g;       # whomsever, whoever
    s/potat�s/potatoes/g;
    s/(?<=\b[fd])�(?=[lt]\b)/ue/g;  # fuel, duel, duet, ...
    s/Dreyfu�/Dreyfuss/g;
    s/(?<=[Gg])�(?=lic)/ae/g;
    s/(?<=[Mm])�(?=stro)/ae/g;
    s/(?<=\b[dg])�(?=s(\b|n))/oe/g;  # does, goes
    s/min�t\b/minuet/g;
    s/(?<=trespa)�/ss/g;
    s/N(oe|�)l\b/No�l/g;
    s/\bg�ss\b/guess/g;
    s/mut�l/mutuel/g;
    s/�il/oeil/g;
    s/m�zzi/muezzi/g;
    s/p�sy/poesy/g;
    s/(?<=[Tt]omat)�/oe/g;
    s/(?<=B)�(?=gehold)/oe/g;
    return $_;
}

1;
__END__

=head1 NAME

Lingua::DE::ASCII - Perl extension to convert german umlauts to and from ascii

=head1 SYNOPSIS

  use Lingua::DE::ASCII;
  print to_ascii("Umlaute wie �,�,�,� oder auch � usw. " .
                 "sind nicht im ASCII Format " .
                 "und werden deshalb umgeschrieben);
  print to_latin1("Dies muesste auch rueckwaerts funktionieren ma cherie");
                 

=head1 DESCRIPTION

This module enables conversion from and to the ASCII format of german texts.

It has two methods: C<to_ascii> and C<to_latin1> which one do exactly what they 
say.

Please note that both methods take only one scalar as argument and 
not whole a list.

=head2 to_ascii($string)

The C<to_ascii> method is just simple. It replaces each printable ANSI character
(codes 160..255) with a (hopefully) sensfull ASCII representation (might be more
than one character). The ANSI character with codes 128..160 are not printable
and they are removed by default.
The transliteration is defined with the global
C<%Lingua::DE::ASCII::ANSI_TO_ASCII_TRANSLITERATION>
variable.
You can change this variable if you want to change the transliteration
behaviour.

=head2 to_latin1($string)

The C<to_latin1> method is very complex (more than 700 lines of code). It
retranslates 7-bit ASCII representations into a reasonable german ANSI
representation. Thus it changes mainly 'ae' to '�', 'oe' to '�', 'ue' to '�',
'ss' to '�'. It also changes some other characters, e.g. '(C)' to '�' or in
words like 'Crepe' it also restores the really writing 'Cr�pe'.

Of course, the method only tries to change where it should. That
explains the enormous complexity of this method, as it tries to solve a hard
linguistic problem with a bit logic and many regular expressions (please also
look to L<BUGS> if you are interested in known problems).

It's quicker to let C<to_latin1> work on a big (even multiline) string than 
to make a lot of callings with little strings (like lines or words). The reason is that the
method works with a lot of regular expressions (as nearly every line of code
contains a regexp). As Perl is very good to optimize them especially for long
strings, you can gain a good speed advantage if you need it.

At the moment you can't change the behaviour of the C<to_latin1> method (e.g.
switching from the new german spelling to the old one), and I'm not sure whether
I will enable it. Please inform me, if you feel that it would be important or
much convenient in a case.

=head2 EXPORT

to_ascii($string)
to_latin1($string)

=head1 BUGS

That's only a stupid computer program, faced with a very hard AI problem.
So there will be some words that will be always hard to retranslate from ASCII 
to Latin-1 encoding. A known example is the difference between "Ma�(einheit)" and
"Masseentropie" or similar. Another examples are "fl�sse" and "Fl��e"
or "(Der Schornstein) ru�e" and "Russe", "Geheimtuer(isch)" and "Geheimt�r", 
"anzu-ecken" and "anz�cken" or quite even a lonely "ss" or "�". 
Also, it's  hard to find the right spelling for the prefixes "miss-" or "mi�-".
In doubt I tried to use to more common word and in even still a doubt the
program tries to be conservative, that means it prefers not to translate to an
umlaut. Reason is that the text is still readable with one "ae","oe","ue" or
"ss" too much, but a wrong "�", "�", "�" or "�" can make it very unreadable.

I tried it with a huge list of german words, but please tell me if you find a bug.

This module is intended for ANSI code that is e.g. different from windows coding.

Misspelled words will create a lot of extra mistakes by the program.
In doubt it's better to write with new Rechtschreibung.

The C<to_latin1> method is not very quick (but quick enough to work
interactively with text files of about 100 KB).
It's programmed to handle as many exceptions as possible.

I avoided localizations for character handling
(thus it should work on every computer),
but the price is that in some rare cases of words with multiple umlauts
(like "H�kelt�lle") some buggy conversions can occur.
Please tell me if you find such words.

The C<to_latin1> method also has some knowledge to work with some basic English.
(So that some words don't confuse everything and you can
also use some code snippets in your text).
However, it is very recommended to use American English instead of British English.
Espeically many plural forms (ending on "oes") are hard to handle,
and often I decided not to implement an extra rule as
it is a C<Lingua::DE::*> module and not an English one.

=head1 TESTS

The test scripts (called by e.g. C<make test>) need a long time.
The reason is that I test it with a huge german word list. Normally you can skip
this test if there is no failing in the first few seconds. However, the tests
also have a progress bar (either a Term::ProgressBar if installed or just a simple text output), so that you can see the advances :-)

There are two major reasons why I added so many words to test even to the CPAN
release. On the one hand, I wanted to give you a chance to detect strange
behaviour under uncommon circumstances. (I haven't test it under a non-german
locale based operation system e.g. and I have also included that words are tests
under a random environment to find out unexpected errors) 
On the other hand, I also wanted you to give
a chance to detect yourself whether a C<to_latin1> result is a bug or a feature.
(Just search through the content of the test files to determine whether a
strange looking word is tested for and thus wanted).

There is also a test with common 1000 English words (having an ae,oe,ue or ss inside),
as German is nowadays often mixed with a lot of them,
and this module should not be confused with them.

=head1 AUTHOR

Janek Schleicher, E<lt>bigj@kamelfreund.deE<gt>

=head1 SEE ALSO

Lingua::DE::Sentence   (another cool module)

=cut

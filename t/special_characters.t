#!/usr/bin/perl -w

use strict;
use warnings;

use Lingua::DE::ASCII;
use Test::More tests => 204;

use strict;
use warnings;
use diagnostics;

my $non_ascii_chars = join("", map {chr} (128..255));

while (<DATA>) {
    chomp;
    my $ascii_text        = to_ascii($_);  
    my $iso_text          = to_latin1($ascii_text);
    my $iso_text_from_iso = to_latin1($_);
    ok defined($ascii_text) or diag("Not defined to_ascii('$_')");
    ok defined($iso_text)   or diag("Not defined to_latin1('$_')");
    ok defined($iso_text_from_iso) or diag("Not defind to_latin1('$ascii_text')");
    ok $ascii_text !~ /[$non_ascii_chars]/o or diag("to_ascii:  $_ => $ascii_text");
    is $iso_text, $_          or diag("to_latin1:\n$_ =>\n$ascii_text =>\n$iso_text");
    is $iso_text_from_iso, $_ or diag("to_latin1(latinstr):\n $_ => $iso_text_from_iso");
}

foreach (160 .. 255) {   # printable ANSI character codes
    my $ansi_char = chr($_);
    my $ascii_representation = to_ascii($ansi_char);
    ok length(to_ascii($ansi_char)) or 
        diag("ascii representation of code $_ ('$ansi_char' fails");
}

1;

__DATA__
�Herr Kommandant,� sagte Herr Bantes, dieses und die ansto�enden Zimmer hatte auch Ihr Herr Vorfahre; nehmen Sie vorlieb.
�Ich hoffe indes,� sagte Waldrich, �Sie werden mit mir und meinen Leuten nicht unzufrieden sein.�
�Eine Tochter!� antwortete Frau Bantes, und zeigte auf das junge Frauenzimmer, das bescheiden die Augen zum Teller niedersenkte.
Er sagte den Eltern etwas Verbindliches, so gut er es in der ersten Best�rzung aufzubringen wusste, und war herzlich zufrieden, als der alte Papa rief: �Noch einen L�ffel Sauce und dergleichen, zu Ihrem trockenen Braten da, Herr Kommandant!�
�Lass gut sein, Mama!� rief der Papa.
�Wer wei�, er w�re am Ende vielleicht auch ein Windbeutel und dergleichen geworden, wie der Georg.�
�Aber wissen Sie denn, Papa, ob Georg wirklich solch ein Windbeutel geworden, wie Sie ihn sich vorstellen?� sagte Friederike.
�H�tte der Bursch�, so schloss die Historie nutzanwendend, �auf der Universit�t etwas Rechtschaffenes gelernt, so w�re er nicht unter die Soldaten und dergleichen gegangen.�
�Ich wei� nicht,� entgegnete die Tochter, �ob er auf der Universit�t flei�ig gewesen; aber ich wei�, dass er wenigstens mit guten Herzen ging, sich f�r eine heilige Sache zu opfern.�
�Komm mir doch nicht immer mit deiner heiligen Sache und dergleichen!� rief Herr Bantes.
Gr��en -- hier ist nur wichtig, dass ein ue mit einem sz vorkommt, da dies einmal einem eingebauten Bug entsprach
0

Eine einfache Null oder ein Leerstring d�rfen nat�rlich nicht zu einem undef
werden, leider war genau das mal ein Bug!
a language
(war auch mal ein Bug)
one loss, some wins

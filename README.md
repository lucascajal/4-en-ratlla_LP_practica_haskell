# Practica de Haskell: 4 en ratlla.

Joc programat en haskell per poder jugar al famós joc del 4 en ratlla contra l'ordinador.

## Compilació i execució

Per poder executar el joc s'ha de compilar el codi utilitzant la comanda ```ghc joc.hs```, i ```./joc``` per executar-lo.

## Paràmetres inicials

Una vegada començat el joc, se'ns demanaran per consola diversos paràmetres que definiràn la partida a jugar. Haurem d'introduïr l'alçada del taulell, la seva amplada, l'estratègia que volem que utilitzi l'ordinador i el jugador que farà la primera tirada.

## Estratègies de l'ordinador

L'ordinador pot seguir tres estratègies diferents per escollir quines tirades fer: `random`, `greedy` i `smart`. Totes les estratègies reben com a paràmetre el taulell en el moment de fer la tirada i retornen una columna vàlida on tirar la següent fitxa. Una columna vàlida és aquella que està dins del taulell (0 <= columna < amplada del taulell) i que té al menys un espai lliure, és a dir, que no està plena de fitxes. El funcionament resumit de les diferents estratègies és el següent:

- **`Random`:** Escull una columna a l'atzar.

- **`Greedy`:** A cada tirada l'ordinador intenta posar el màxim nombre de fitxes en linia, però evitant que el contrincant pugui fer 4 en ratlla. 

- **`Smart`:** L'ordinador escull una columna tenint en compte tant les seves jugades potencials com les del contrincant. Sempre intenta apropar-se a una victòria mentre alhora bloqueja jugades de l'oponent, però en cas de no poder fer ambdues coses prioritza bloquejar al contrincant. Quan hi ha més d'una columna que compleixen les mateixes condicions, prioritza aquella més cercana al centre del taulell, ja que tal i com s'ha demostrat [(1)](https://github.com/lucascajal/LP_practica_haskell/blob/master/README.md#refer%C3%A8ncies), tirar fitxes a les columnes més properes al centre augmenta la possibilitat de victòria.

## Referències
1) [VICTOR ALLIS, *A Knowledge-based Approach of Connect-Four*, Master thesis, 1988.](http://www.informatik.uni-trier.de/~fernau/DSL0607/Masterthesis-Viergewinnt.pdf)
2)
https://www.youtube.com/watch?v=yDWPi1pZ0Po&t=220s

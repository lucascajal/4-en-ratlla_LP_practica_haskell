# Practica de Haskell: 4 en ratlla

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

## Representació de la partida

Per poder representar el taulell, s'ha utilitzat una matriu d'enters, de dimensions `m` x `n`. Les posicions buides están marcades amb `0`, les ocupades per una fitxa del jugador amb un `1` i les ocupades per una fitxa de l'ordinador amb un `2`. 

Per fer una jugada, es crida a `turn player board movesLeft strategy`, on `player` ens indica a qui li toca jugar, `board` és el taulell actual i `strategy` l'estrategia seguida per l'ordinador. El paràmetre `movesLeft` ens indica quantes tirades més es poden fer, per tant el seu valor inicial és `n`x`m`, i a cada tirada se li resta una unitat. Si a la jugada que s'acaba de fer un jugador guanya, es passa el indicador d'aquest jugador en negatiu (`-1` per l'humà, `-2` per l'ordinador) com a valor de `movesLeft`. Per tant, quan a una jugada el valor de `movesLeft` sigui un `0`, la partida haurà acabat en empat. Si el valor és `-1`, haurà guanyat la partida el jugador humà, i si és `-2` haurà guanyat l'ordinador. Per a qualsevol altre valor la partida no estarà acabada i per tant es farà un nou moviment, ja sigui demanant al jugador una tirada per consola o generant des de l'ordinador una tirada seguint l'estratègia indicada al paràmetre `strategy`.

## Implementació d'estratègies

Per implementar les estratègies `greedy` i `smart` s'ha utilitzat un mètode basat en conjunts. Hi ha diverses funcions que, passat el taulell actual, retornen un conjunt de tirades possibles (representat com a llista d'enters) que compleixen certes condicions. També s'ha definit una funció `intersect a b` que, donats dos conjunts `a` i `b`, retorna la seva intersecció. L'idea és obtenir una llista de conjunts, ja sigui mitjançant les funcions directes o la intersecció d'altres conjunts, on cada conjunt contingui totes les tirades possibles que compleixen unes certes condicions. Aquests conjunts estàn ordenats segons les seves condicions, de més prioritàries a menys. Una vegada generats tots els conjunts, agafem el primer conjunt no buit (és a dir, el conjunt més prioritari amb alguna tirada possible) i escollim una tirada d'entre les d'aquest conjunt. 

### Greedy


### Smart

## Referències
1) [VICTOR ALLIS, *A Knowledge-based Approach of Connect-Four*, Master thesis, 1988.](http://www.informatik.uni-trier.de/~fernau/DSL0607/Masterthesis-Viergewinnt.pdf)
2) [NUMBERPHILE (2013) *Connect Four - Numberphile* (visualitzat el 18 d'abril de 2020)](https://www.youtube.com/watch?v=yDWPi1pZ0Po&t=220s)

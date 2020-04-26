# Pràctica de Haskell: 4 en ratlla

Joc programat en haskell per poder jugar al famós joc del 4 en ratlla contra l'ordinador.

## Compilació i execució

Per poder executar el joc s'ha de compilar el codi utilitzant la comanda ```ghc joc.hs```, i ```./joc``` per executar-lo.

## Paràmetres inicials

Una vegada executat el joc, se'ns demanaran per consola diversos paràmetres que definiran la partida a jugar. Haurem d'introduir l'alçada del taulell, la seva amplada, l'estratègia que volem que utilitzi l'ordinador i el jugador que farà la primera tirada.

## Estratègies de l'ordinador

L'ordinador pot seguir tres estratègies diferents per escollir quines tirades fer: `random`, `greedy` i `smart`. Totes les estratègies reben com a paràmetre el taulell en el moment de fer la tirada i retornen una columna vàlida on tirar la següent fitxa. Una columna vàlida és aquella que està dins del taulell (0 <= columna < amplada del taulell) i que té almenys un espai lliure, és a dir, que no està plena de fitxes. El funcionament resumit de les diferents estratègies és el següent:

- **`Random`:** Escull una jugada a l'atzar.

- **`Greedy`:** A cada jugada l'ordinador intenta posar el màxim nombre de fitxes en línia, però evitant que el contrincant pugui fer 4 en ratlla. 

- **`Smart`:** L'ordinador escull una jugada tenint en compte tant les seves jugades potencials com les del contrincant. Sempre intenta apropar-se a una victòria mentre alhora bloqueja jugades de l'oponent, però en cas de no poder fer ambdues coses prioritza bloquejar al contrincant. Quan hi ha més d'una columna que compleixen les mateixes condicions, prioritza aquella més propera al centre del taulell, ja que tal com s'ha demostrat [(1)](https://github.com/lucascajal/LP_practica_haskell/blob/master/README.md#refer%C3%A8ncies), tirar fitxes a les columnes més properes al centre augmenta la probabilitat de victòria.

## Representació de la partida

Per poder representar el taulell, s'ha utilitzat una matriu d'enters, de dimensions `m` x `n`. Les posicions buides estan marcades amb `0`, les ocupades per una fitxa del jugador amb un `1` i les ocupades per una fitxa de l'ordinador amb un `2`. 

Per fer una jugada, es crida a `turn player board movesLeft strategy`, on `player` ens indica a qui li toca jugar, `board` és el taulell actual i `strategy` l'estratègia  seguida per l'ordinador. El paràmetre `movesLeft` ens indica quantes tirades més es poden fer, per tant el seu valor inicial és `n`x`m`, i a cada tirada se li resta una unitat. Si a la jugada que s'acaba de fer un jugador guanya, es passa l'indicador d'aquest jugador en negatiu (`-1` per l'humà, `-2` per l'ordinador) com a valor de `movesLeft`. Per tant, quan a una jugada el valor de `movesLeft` sigui un `0`, la partida haurà acabat en empat. Si el valor és `-1`, haurà guanyat la partida el jugador humà, i si és `-2` haurà guanyat l'ordinador. Per a qualsevol altre valor la partida no estarà acabada i per tant es farà un nou moviment, ja sigui demanant al jugador una tirada per consola o generant des de l'ordinador una tirada seguint l'estratègia indicada al paràmetre `strategy`.

## Implementació d'estratègies

Per implementar les estratègies `greedy` i `smart` s'ha utilitzat un mètode basat en conjunts. Hi ha diverses funcions que, passat el taulell actual, retornen un conjunt de tirades possibles (representat com a llista d'enters) que compleixen certes condicions. També s'ha definit una funció `intersect a b` que, donats dos conjunts `a` i `b`, retorna la seva intersecció. 

La idea és obtenir una llista de conjunts, sigui mitjançant les funcions directes o la intersecció d'altres conjunts, on cada conjunt contingui totes les tirades possibles que compleixen unes certes condicions. Aquests conjunts estan ordenats segons les seves condicions, de més prioritàries a menys. Una vegada generats tots els conjunts, agafem el primer conjunt no buit (és a dir, el conjunt més prioritari amb alguna tirada possible) i escollim una tirada d'entre les d'aquest conjunt. 

A continuació es descriu detalladament quins són aquests conjunts i el seu ordre per a cada estratègia.

### Greedy
Llista de conjunts (ordenades de més a menys prioritat):
- `wewin`: Tirades amb les quals guanyem la partida.
- `make3noLoss`: Tirades amb les quals bloquejem una tirada guanyadora de l'oponent i fem 3 en ratlla.
- `make2noLoss`: Tirades amb les quals bloquejem una tirada guanyadora de l'oponent i fem 2 en ratlla.
- `stopEnemyWin`: Tirades amb les quals bloquejem una tirada guanyadora de l'oponent.
- `make3`: Tirades amb les quals fem 3 en ratlla.
- `make2`: Tirades amb les quals fem 2 en ratlla.
- `cols`: Totes les tirades vàlides possibles.

Tots els conjunts utilitzats a l'estratègia greedy són subconjunts del conjunt `cols`

Una vegada trobat el conjunt més prioritari no buit, es retorna la primera tirada d'aquest conjunt.

### Smart
Llista de conjunts (ordenades de més a menys prioritat):
- `wewin`: Tirades amb les quals guanyem la partida.
- `make3spacedSafeStop`: Tirades amb les quals bloquegem una tirada guanyadora de l'oponent i fem 3 en ratlla, amb espais lliures a ambdues bandes.
- `make3safeStop`: Tirades amb les quals bloquegem una tirada guanyadora de l'oponent i fem 3 en ratlla.
- `make2safeStop`: Tirades amb les quals bloquegem una tirada guanyadora de l'oponent i fem 2 en ratlla.
- `safeStopEnemyWin`: Tirades amb les quals bloquegem una tirada guanyadora de l'oponent.
- `stopEnemyWin`: Tirades amb les quals bloquegem una tirada guanyadora de l'oponent sense comprovar si permeten a l'oponent guanyar posant una fitxa just a sobre.
- `spaced3combined`: Tirades amb les quals evitem que l'oponent faci 3 en ratlla amb espais lliures a ambdues bandes i fem nosaltres 3 en ratlla amb espais lliures a ambdues bandes.
- `rivalMake3spaced`: Tirades amb les quals evitem que l'oponent faci 3 en ratlla amb espais lliures a ambdues bandes.
- `make3spacedRival3`: Tirades amb les quals evitem que l'oponent faci 3 en ratlla i fem nosaltres 3 en ratlla amb espais lliures a ambdues bandes.
- `make3spaced`: Tirades amb les quals fem 3 en ratlla amb espais lliures a ambdues bandes.
- `make3combined`: Tirades amb les quals evitem que l'oponent faci 3 en ratlla i fem nosaltres 3 en ratlla.
- `make2rivalMake3`: Tirades amb les quals evitem que l'oponent faci 3 en ratlla i fem nosaltres 2 en ratlla.
- `rivalMake3`: Tirades amb les quals evitem que l'oponent faci 3 en ratlla.
- `make3`: Tirades amb les quals fem 3 en ratlla.
- `make2`: Tirades amb les quals fem 2 en ratlla.
- `safeCols`: Totes les tirades vàlides possibles que no permeten a l'oponent guanyar posant una fitxa just a sobre.
- `cols`: Totes les tirades vàlides possibles.

Tots els conjunts utilitzats a l'estratègia smart són subconjunts del conjunt `safeCols`, excepte els conjunts `wewin`, `stopEnemyWin` i `cols`.

Una vegada trobat el conjunt més prioritari no buit, es retorna la tirada més propera al centre del taulell d'aquest conjunt.

L'ordre de prioritat d'alguns d'aquests conjunts es podria canviar per tal de fer petites modificacions al comportament de l'estratègia. Per exemple, es podria donar més prioritat a fer nosaltres 3 en ratlla que no pas bloquejar un 3 en ratlla del rival. Però després d'analitzar resultats de diferents partides, s'ha decidit prioritzar el bloqueig d'una jugada del contrincant a la realització d'una jugada nostra. Això disminueix la probabilitat de victòries del contrincant en gran manera, augmenta la probabilitat d'empat i disminueix lleugerament la probabilitat de victòria de l'ordinador.

## Referències
1) [VICTOR ALLIS, *A Knowledge-based Approach of Connect-Four*, Master thesis, 1988.](http://www.informatik.uni-trier.de/~fernau/DSL0607/Masterthesis-Viergewinnt.pdf)
2) [NUMBERPHILE (2013) *Connect Four - Numberphile* (visualitzat el 18 d'abril de 2020)](https://www.youtube.com/watch?v=yDWPi1pZ0Po&t=220s)

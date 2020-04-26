# Practica de Haskell: 4 en ratlla.

Joc programat en haskell per poder jugar al famós joc del 4 en ratlla contra l'ordinador.

## Compilació i execució

Per poder executar el joc s'ha de compilar el codi utilitzant la comanda ```ghc joc.hs```, i ```./joc``` per executar-lo.

## Paràmetres inicials

Una vegada començat el joc, se'ns demanaran per consola diversos paràmetres que definiràn la partida a jugar. Haurem d'introduïr l'alçada del taulell, la seva amplada, l'estratègia que volem que utilitzi l'ordinador i el jugador que farà la primera tirada.

## Estratègies de l'ordinador

L'ordinador pot seguir tres estratègies diferents per escollir quines tirades fer: `random`, `greedy` i `smart`. Totes les estratègies reben com a paràmetre el taulell en el moment de fer la tirada i retornen una columna vàlida on tirar la següent fitxa. Una columna vàlida és aquella que està dins del taulell (0 <= columna < amplada del taulell) i que té al menys un espai lliure, és a dir, que no està plena de fitxes. El funcionament de les diferents estratègies és el següent:

- *`Random`*: Escull una columna a l'atzar.

- `Greedy`: cada tirada de l'ordinador és a la columna que li
permet posar en ratlla el nombre més alt de fitxes pròpies i que evita
(si pot) que el contrari faci 4-en-ratlla a la jugada següent. En cas
d'empat, tria arbitràriament.

- `Smart`: trieu vosaltres una estratègia el més astuta possible.
No hauria de ser massa lenta (un parell de segons màxim per jugada, diguem).

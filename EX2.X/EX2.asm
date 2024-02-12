include "p18F23K20.inc"

RES_VECT  CODE    0x0000            ; processor reset vector
goto Main

groupc UDATA 0x100 
somme RES 10   ; Réserve 1 emplacement mémoire pour 'somme'
i RES 10       ; Réserve 1 emplacement mémoire pour 'i'

MAIN_PROG CODE                      ; let linker place main program

Main:
    MOVLB 0x01             ; Sélectionne le banc de mémoire
    CLRF somme,1           ; Initialise 'somme' à 0
    MOVLW 0x14             ; Charge 20 dans W
    MOVWF i,1              ; Initialise 'i' à 20

Boucle:
    MOVF i,W,1             ; Met 'i' dans le registre de travail W
    ADDWF somme,1          ; Ajoute 'i' à 'somme'

    MOVLW 0x01             ; Charge 1 dans W
    CPFSEQ i,1             ; Compare 'i' avec 1
    goto ContinueBoucle    ; Si 'i' == 1, continue la boucle

    goto FinBoucle         ; Si 'i' != 1, fin de la boucle

ContinueBoucle:
    DECF i,1,1             ; Décrémente 'i'
    goto Boucle            ; Répète la boucle

FinBoucle:
    ; Ici, 'somme' contient la somme des 20 premiers entiers en décroissant
    END

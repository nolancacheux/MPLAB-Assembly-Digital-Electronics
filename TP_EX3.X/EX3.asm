include "p18F23K20.inc"

RES_VECT  CODE    0x0000            ; processor reset vector
goto Main

groupc UDATA 0x100 
somme_High RES 1   ; Réserve 1 emplacement mémoire pour 'somme_High' (octet de poids fort)
somme_Low RES 1    ; Réserve 1 emplacement mémoire pour 'somme_Low' (octet de poids faible)
i RES 1            ; Réserve 1 emplacement mémoire pour 'i'

MAIN_PROG CODE                      ; let linker place main program

Main:
    MOVLB 0x01             ; Sélectionne le banc de mémoire
    CLRF somme_High,1      ; Initialise 'somme_High' à 0
    CLRF somme_Low,1       ; Initialise 'somme_Low' à 0
    MOVLW 0x28             ; Charge 40 dans W (0x28 en hexadécimal)
    MOVWF i,1              ; Initialise 'i' à 40

Boucle:
    MOVF i,W,1             ; Met 'i' dans le registre de travail W
    ADDWF somme_Low,1      ; Ajoute 'i' à 'somme_Low'
    
;La ligne MOVLW 0x00 est utilisée pour charger la valeur zéro (0) dans le registre W (registre de travail). 
;Cette opération est nécessaire pour effacer la retenue (carry) avant d'effectuer l'addition suivante.

;Dans le contexte de ce programme, après chaque addition de i à somme_Low, nous devons nous assurer que la retenue 
 ;est correctement gérée pour l'ajouter à l'octet de poids fort somme_High. 
;En chargeant zéro dans W avec MOVLW 0x00, nous nous assurons que la retenue est réinitialisée avant de passer à l'addition suivante.
;Cela garantit que la retenue est correctement gérée et que l'addition se fait correctement.
 
    MOVLW 0x00             ; Charge 0 dans W
    ADDWFC somme_High,1    ; Ajoute la retenue à 'somme_High'
    DECF i,1,1             ; Décrémente 'i'

    MOVLW 0x00             ; Charge 0 dans W
    CPFSEQ i,1             ; Compare 'i' avec 1
    goto ContinueBoucle    ; Si 'i' == 1, continue la boucle

    goto FinBoucle         ; Si 'i' != 1, fin de la boucle
    
ContinueBoucle:
    goto Boucle            ; Répète la boucle

FinBoucle:
    ; Ici, 'somme_High' et 'somme_Low' contiennent la somme des 40 premiers entiers
    END

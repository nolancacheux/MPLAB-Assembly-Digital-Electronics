include "p18F23K20.inc"

RES_VECT  CODE    0x0000            ; processor reset vector
goto Main

groupc UDATA 0x100 
somme_High RES 1   ; R�serve 1 emplacement m�moire pour 'somme_High' (octet de poids fort)
somme_Low RES 1    ; R�serve 1 emplacement m�moire pour 'somme_Low' (octet de poids faible)
i RES 1            ; R�serve 1 emplacement m�moire pour 'i'

MAIN_PROG CODE                      ; let linker place main program

Main:
    MOVLB 0x01             ; S�lectionne le banc de m�moire
    CLRF somme_High,1      ; Initialise 'somme_High' � 0
    CLRF somme_Low,1       ; Initialise 'somme_Low' � 0
    MOVLW 0x28             ; Charge 40 dans W (0x28 en hexad�cimal)
    MOVWF i,1              ; Initialise 'i' � 40

Boucle:
    MOVF i,W,1             ; Met 'i' dans le registre de travail W
    ADDWF somme_Low,1      ; Ajoute 'i' � 'somme_Low'
    
;La ligne MOVLW 0x00 est utilis�e pour charger la valeur z�ro (0) dans le registre W (registre de travail). 
;Cette op�ration est n�cessaire pour effacer la retenue (carry) avant d'effectuer l'addition suivante.

;Dans le contexte de ce programme, apr�s chaque addition de i � somme_Low, nous devons nous assurer que la retenue 
 ;est correctement g�r�e pour l'ajouter � l'octet de poids fort somme_High. 
;En chargeant z�ro dans W avec MOVLW 0x00, nous nous assurons que la retenue est r�initialis�e avant de passer � l'addition suivante.
;Cela garantit que la retenue est correctement g�r�e et que l'addition se fait correctement.
 
    MOVLW 0x00             ; Charge 0 dans W
    ADDWFC somme_High,1    ; Ajoute la retenue � 'somme_High'
    DECF i,1,1             ; D�cr�mente 'i'

    MOVLW 0x00             ; Charge 0 dans W
    CPFSEQ i,1             ; Compare 'i' avec 1
    goto ContinueBoucle    ; Si 'i' == 1, continue la boucle

    goto FinBoucle         ; Si 'i' != 1, fin de la boucle
    
ContinueBoucle:
    goto Boucle            ; R�p�te la boucle

FinBoucle:
    ; Ici, 'somme_High' et 'somme_Low' contiennent la somme des 40 premiers entiers
    END

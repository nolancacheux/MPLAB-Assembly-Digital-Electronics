    include "p18F23K20.inc"

    ORG 0x0000
    goto MAIN

    ; Déclaration des variables
    cblock 0x100
        somme_High:1
        somme_Low:1
        i:1
    endc

    ; Sous-programme pour calculer la somme
    calcul_somme:
        MOVWF i
        CLRF somme_High
        CLRF somme_Low

    Boucle_Somme:
        MOVF i,W
        ADDWF somme_Low,F
        BTFSC STATUS,C
        INCF somme_High,F
        DECF i,F
        TSTFSZ i
        GOTO Boucle_Somme
        RETURN

    ; Programme principal
    MAIN:
        MOVLW 0x28 ; 40 en hexadécimal pour l'exercice 3
        CALL calcul_somme
        ; Le résultat est maintenant dans somme_High et somme_Low

        END

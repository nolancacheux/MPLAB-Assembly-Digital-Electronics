    include "p18F23K20.inc"

    ORG 0x0000
    goto MAIN

    ; Déclaration des variables
    cblock 0x100
        indice
        min
        max
        temp
    endc

    ; Données en mémoire Flash
    ORG 0x0100
    DB 0x19, 0x04, 0x02, 0x0F, 0x10, 0x65, 0x21, 0x03

    ; Sous-programme pour chercher min et max
    cherche_min_max:
        MOVLW HIGH 0x0100
        MOVWF TBLPTRH
        MOVLW LOW 0x0100
        MOVWF TBLPTRL
        MOVLW indice
        ADDWF TBLPTRL, F

        TBLRD*+
        MOVF TABLAT, W
        MOVWF temp
        CPFSLT min
        MOVWF min
        CPFSGT max
        MOVWF max
        INCF indice,F
        RETURN

    ; Programme principal
    MAIN:
        CLRF indice
        MOVLW 0xFF
        MOVWF min
        MOVLW 0x00
        MOVWF max

    Boucle_Principale:
        CPFSGT indice, 7
        GOTO Fin
        CALL cherche_min_max
        GOTO Boucle_Principale

    Fin:
        ; Ici, 'min' et 'max' contiennent les valeurs minimale et maximale
        END

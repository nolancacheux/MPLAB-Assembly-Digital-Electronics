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

    ; Table de données en mémoire Flash
    ORG 0x0100
Table:
    RETLW 25
    RETLW 4
    RETLW 2
    RETLW 15
    RETLW 16
    RETLW 101
    RETLW 33
    RETLW 3

    ; Sous-programme pour chercher min et max
    cherche_min_max:
        MOVF indice,W
        CALL Table
        MOVWF temp
        CPFSLT min
        MOVWF min
        CPFSGT max
        MOVWF max
        INCF indice,F
        RETURN

    ; Programme principal
    MAIN:
        MOVLW 0x00
        MOVWF indice
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

    include "p18F23K20.inc"

    ORG 0x0000
    goto MAIN

    ; Déclaration des variables
    cblock 0x100
        tableau:8   ; Espace pour 8 éléments du tableau
        taille_tableau
        min
        max
    endc

    ; Sous-programme pour écrire dans le tableau
    ecrire_tableau:
        MOVLW HIGH tableau
        MOVWF FSR0H
        MOVLW LOW tableau
        MOVWF FSR0L

        MOVLW 25
        MOVWF POSTINC0
        MOVLW 4
        MOVWF POSTINC0
	MOVLW 2
        MOVWF POSTINC0
	MOVLW 15
        MOVWF POSTINC0
	MOVLW 16
        MOVWF POSTINC0
	MOVLW 101
        MOVWF POSTINC0
	MOVLW 33
        MOVWF POSTINC0
	MOVLW 3
        MOVWF POSTINC0

        MOVLW 8
        MOVWF taille_tableau
        RETURN

    ; Sous-programme pour chercher le minimum
    cherche_min:
        MOVLW HIGH tableau
        MOVWF FSR0H
        MOVLW LOW tableau
        MOVWF FSR0L

        MOVF INDF0,W
        MOVWF min
        INCF FSR0L,F

        MOVLW 8
        MOVWF taille_tableau
        DECF taille_tableau,F

    Boucle_Min:
        MOVF POSTINC0,W
        CPFSLT min
        MOVWF min
        DECF taille_tableau,F
        BZ Fin_Min
        GOTO Boucle_Min
    Fin_Min:
        RETURN

    ; Sous-programme pour chercher le maximum
    cherche_max:
        MOVLW HIGH tableau
        MOVWF FSR0H
        MOVLW LOW tableau
        MOVWF FSR0L

        MOVF INDF0,W
        MOVWF max
        INCF FSR0L,F

        MOVLW 8
        MOVWF taille_tableau
        DECF taille_tableau,F

    Boucle_Max:
        MOVF POSTINC0,W
        CPFSGT max
        MOVWF max
        DECF taille_tableau,F
        BZ Fin_Max
        GOTO Boucle_Max
    Fin_Max:
        RETURN

    ; Programme principal
    MAIN:
        CALL ecrire_tableau
        CALL cherche_min
        CALL cherche_max
        ; Les valeurs min et max sont maintenant dans 'min' et 'max'
        END

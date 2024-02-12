    INCLUDE "p18f45k20.inc"

    ORG 0x00
    GOTO Main
    ORG 0x08

    cblock
        StringLength: 1
    endc

Main:
    ; Initialisation du pointeur FSR0 pour accéder à la RAM
    MOVLW 0x00
    MOVWF FSR0L
    MOVLW 0x01
    MOVWF FSR0H

    ; Stockage de la chaîne "813nv3nu3" en ASCII
    MOVLW '8'
    MOVWF POSTINC0
    MOVLW '1'
    MOVWF POSTINC0
    MOVLW '3'
    MOVWF POSTINC0
    MOVLW 'n'
    MOVWF POSTINC0
    MOVLW 'v'
    MOVWF POSTINC0
    MOVLW '3'
    MOVWF POSTINC0
    MOVLW 'n'
    MOVWF POSTINC0
    MOVLW 'u'
    MOVWF POSTINC0
    MOVLW '3'
    MOVWF POSTINC0
    MOVLW 0x00
    MOVWF POSTINC0

    ; Appel du sous-programme pour calculer la longueur de la chaîne
    CALL CalculateStringLength

    ; Boucle infinie pour rester dans le programme
LoopMain:
    GOTO LoopMain

CalculateStringLength:
    CLRF StringLength        ; Réinitialise le compteur de longueur
    LFSR FSR0, 0x0100        ; Pointe FSR0 vers le début de la chaîne

LoopRoutine:
    INCF StringLength, F     ; Incrémente le compteur de longueur
    MOVF POSTINC0, W         ; Charge le caractère suivant de la chaîne
    BZ EndStringLength       ; Si 0x00, fin de la chaîne
    GOTO LoopRoutine         ; Sinon, continue la boucle

EndStringLength:
    MOVF StringLength-1, W

    RETURN

    END

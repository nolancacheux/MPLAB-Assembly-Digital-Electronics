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

    ; Appel du sous-programme pour crypter la chaîne
    CALL EncryptString

    ; Boucle infinie pour rester dans le programme
LoopMain:
    GOTO LoopMain

CalculateStringLength:
    CLRF StringLength        ; Réinitialise le compteur de longueur
    LFSR FSR0, 0x0100        ; Pointe FSR0 vers le début de la chaîne

EncryptString:
    LFSR FSR0, 0x0100        ; Pointe FSR0 vers le début de la chaîne originale
    LFSR FSR1, 0x0200        ; Pointe FSR1 vers le début de la banque 2 pour la chaîne cryptée

    MOVF StringLength, W     ; Charge la longueur de la chaîne
    MOVWF POSTINC1           ; Stocke la longueur au début de la banque 2
    MOVF StringLength, W     ; Réinitialise le compteur
    MOVWF StringLength       ; Stocke dans StringLength pour utilisation dans la boucle

CryptLoop:
    DECFSZ StringLength, F   ; Décrémente StringLength et saute si 0
    GOTO EndEncrypt          ; Fin si tous les caractères sont traités

    MOVF POSTINC0, W         ; Charge le prochain caractère de la chaîne originale
    XORLW 0x55               ; Inverse un bit sur deux (bits de rang pair)
    MOVWF POSTINC1           ; Stocke le caractère crypté dans la banque 2
    GOTO CryptLoop

EndEncrypt:
    MOVLW 0x00
    MOVWF POSTINC1           ; Stocke le caractère nul à la fin de la chaîne cryptée

    RETURN

    END

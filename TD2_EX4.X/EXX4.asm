    INCLUDE "p18f45k20.inc"

    ORG 0x00
    GOTO Main
    ORG 0x08

    cblock
        StringLength: 1
    endc

Main:
     ; Initialisation du pointeur FSR0 pour acc�der � la RAM
    MOVLW 0x00
    MOVWF FSR0L
    MOVLW 0x01
    MOVWF FSR0H

    ; Stockage de la cha�ne "813nv3nu3" en ASCII
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
    
    ; Appel du sous-programme pour calculer la longueur de la cha�ne
    CALL CalculateStringLength

    ; Appel du sous-programme pour crypter la cha�ne
    CALL EncryptString

    ; Boucle infinie pour rester dans le programme
LoopMain:
    GOTO LoopMain

CalculateStringLength:
    CLRF StringLength        ; R�initialise le compteur de longueur
    LFSR FSR0, 0x0100        ; Pointe FSR0 vers le d�but de la cha�ne

EncryptString:
    LFSR FSR0, 0x0100        ; Pointe FSR0 vers le d�but de la cha�ne originale
    LFSR FSR1, 0x0200        ; Pointe FSR1 vers le d�but de la banque 2 pour la cha�ne crypt�e

    MOVF StringLength, W     ; Charge la longueur de la cha�ne
    MOVWF POSTINC1           ; Stocke la longueur au d�but de la banque 2
    MOVF StringLength, W     ; R�initialise le compteur
    MOVWF StringLength       ; Stocke dans StringLength pour utilisation dans la boucle

CryptLoop:
    DECFSZ StringLength, F   ; D�cr�mente StringLength et saute si 0
    GOTO EndEncrypt          ; Fin si tous les caract�res sont trait�s

    MOVF POSTINC0, W         ; Charge le prochain caract�re de la cha�ne originale
    XORLW 0x55               ; Inverse un bit sur deux (bits de rang pair)
    MOVWF POSTINC1           ; Stocke le caract�re crypt� dans la banque 2
    GOTO CryptLoop

EndEncrypt:
    MOVLW 0x00
    MOVWF POSTINC1           ; Stocke le caract�re nul � la fin de la cha�ne crypt�e

    RETURN

    END

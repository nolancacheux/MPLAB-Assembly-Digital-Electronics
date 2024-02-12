; D�claration de la variable StringLength
StringthLength EQU 0x20  ; Vous pouvez choisir l'adresse m�moire appropri�e

; Sous-programme pour calculer la longueur de la cha�ne
CalculateStringLength:
    MOVLW 0x00          ; Initialisation du compteur � z�ro
    MOVWF StringthLength

Loop:
    MOVF INDF0, W       ; Charger le caract�re actuel de la cha�ne dans WREG
    BTFSC STATUS, Z     ; V�rifier si le caract�re est nul (0x00)
    GOTO EndLoop        ; Si le caract�re est nul, sortir de la boucle
    INCF StringthLength, F  ; Incr�menter le compteur de longueur
    INCF FSR0L, F       ; Incr�menter le pointeur FSR0 pour passer au caract�re suivant
    GOTO Loop           ; R�p�ter la boucle

EndLoop:
    RETURN              ; Retourner du sous-programme

MAIN_PROG CODE

    INCLUDE "p18f45k20.inc"

    ; Initialisation du pointeur FSR0 pour acc�der � la RAM
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF FSR0L    ; Chargement de WREG dans FSR0L (partie basse du pointeur)
    MOVLW 0x01     ; Chargement de la valeur 0x01 dans WREG
    MOVWF FSR0H    ; Chargement de WREG dans FSR0H (partie haute du pointeur)

    ; Chargement de la cha�ne "813nv3nu3" en ASCII dans la RAM
    MOVLW A'8'      ; Chargement du caract�re '8' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la premi�re position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'1'      ; Chargement du caract�re '1' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la deuxi�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'3'      ; Chargement du caract�re '3' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la troisi�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'n'      ; Chargement du caract�re 'n' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la quatri�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'v'      ; Chargement du caract�re 'v' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la cinqui�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'3'      ; Chargement du caract�re '3' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la sixi�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'n'      ; Chargement du caract�re 'n' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la septi�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'u'      ; Chargement du caract�re 'u' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la huiti�me position de la RAM (FSR0) et incr�mentation de FSR0
    MOVLW A'3'      ; Chargement du caract�re '3' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la neuvi�me et derni�re position de la RAM (FSR0)

    ; Fin de la cha�ne avec le caract�re nul (0x00)
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la derni�re position de la RAM (FSR0)

    ; Appel du sous-programme pour calculer la longueur de la cha�ne
    CALL CalculateStringLength

Loop:
    GOTO Loop           ; Boucle infinie

    END

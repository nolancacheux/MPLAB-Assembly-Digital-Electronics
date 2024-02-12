; Déclaration de la variable StringLength
StringthLength EQU 0x20  ; Vous pouvez choisir l'adresse mémoire appropriée

; Sous-programme pour calculer la longueur de la chaîne
CalculateStringLength:
    MOVLW 0x00          ; Initialisation du compteur à zéro
    MOVWF StringthLength

Loop:
    MOVF INDF0, W       ; Charger le caractère actuel de la chaîne dans WREG
    BTFSC STATUS, Z     ; Vérifier si le caractère est nul (0x00)
    GOTO EndLoop        ; Si le caractère est nul, sortir de la boucle
    INCF StringthLength, F  ; Incrémenter le compteur de longueur
    INCF FSR0L, F       ; Incrémenter le pointeur FSR0 pour passer au caractère suivant
    GOTO Loop           ; Répéter la boucle

EndLoop:
    RETURN              ; Retourner du sous-programme

MAIN_PROG CODE

    INCLUDE "p18f45k20.inc"

    ; Initialisation du pointeur FSR0 pour accéder à la RAM
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF FSR0L    ; Chargement de WREG dans FSR0L (partie basse du pointeur)
    MOVLW 0x01     ; Chargement de la valeur 0x01 dans WREG
    MOVWF FSR0H    ; Chargement de WREG dans FSR0H (partie haute du pointeur)

    ; Chargement de la chaîne "813nv3nu3" en ASCII dans la RAM
    MOVLW A'8'      ; Chargement du caractère '8' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la première position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'1'      ; Chargement du caractère '1' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la deuxième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'3'      ; Chargement du caractère '3' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la troisième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'n'      ; Chargement du caractère 'n' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la quatrième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'v'      ; Chargement du caractère 'v' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la cinquième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'3'      ; Chargement du caractère '3' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la sixième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'n'      ; Chargement du caractère 'n' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la septième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'u'      ; Chargement du caractère 'u' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la huitième position de la RAM (FSR0) et incrémentation de FSR0
    MOVLW A'3'      ; Chargement du caractère '3' dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la neuvième et dernière position de la RAM (FSR0)

    ; Fin de la chaîne avec le caractère nul (0x00)
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF POSTINC0  ; Stockage de WREG dans la dernière position de la RAM (FSR0)

    ; Appel du sous-programme pour calculer la longueur de la chaîne
    CALL CalculateStringLength

Loop:
    GOTO Loop           ; Boucle infinie

    END

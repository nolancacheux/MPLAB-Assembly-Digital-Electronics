INCLUDE "p18f45k20.inc"

MAIN_PROG CODE

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

Loop:
    GOTO Loop      ; Boucle infinie

    END

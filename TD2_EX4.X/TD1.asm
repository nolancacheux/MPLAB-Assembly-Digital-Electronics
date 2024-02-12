INCLUDE "p18f45k20.inc"
    
MAIN_PROG CODE

    ; Initialisation du pointeur FSR0 pour accéder à la RAM
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF FSR0L    ; Chargement de WREG dans FSR0L (partie basse du pointeur)
    MOVLW 0x01     ; Chargement de la valeur 0x01 dans WREG
    MOVWF FSR0H    ; Chargement de WREG dans FSR0H (partie haute du pointeur)

    ; Chargement de la chaîne "813nv3nu3" en ASCII dans la RAM
    MOVLW '8'      ; Chargement du caractère '8' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la première position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    
    MOVLW '1'      ; Chargement du caractère '1' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la deuxième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    MOVLW '3'      ; Chargement du caractère '3' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la troisième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'n'      ; Chargement du caractère 'n' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la quatrième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'v'      ; Chargement du caractère 'v' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la cinquième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    MOVLW '3'      ; Chargement du caractère '3' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la sixième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'n'      ; Chargement du caractère 'n' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la septième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'u'      ; Chargement du caractère 'u' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la huitième position de la RAM (FSR0)
    INCF FSR0L, F  ; Incrémentation de FSR0L pour pointer vers la dernière position
    MOVLW '3'      ; Chargement du caractère '3' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la neuvième et dernière position de la RAM (FSR0)

    ; Fin de la chaîne avec le caractère nul (0x00)
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la dernière position de la RAM (FSR0)

	
GOTO $                          ; loop forever

    END

    

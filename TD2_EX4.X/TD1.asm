INCLUDE "p18f45k20.inc"
    
MAIN_PROG CODE

    ; Initialisation du pointeur FSR0 pour acc�der � la RAM
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF FSR0L    ; Chargement de WREG dans FSR0L (partie basse du pointeur)
    MOVLW 0x01     ; Chargement de la valeur 0x01 dans WREG
    MOVWF FSR0H    ; Chargement de WREG dans FSR0H (partie haute du pointeur)

    ; Chargement de la cha�ne "813nv3nu3" en ASCII dans la RAM
    MOVLW '8'      ; Chargement du caract�re '8' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la premi�re position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    
    MOVLW '1'      ; Chargement du caract�re '1' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la deuxi�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    MOVLW '3'      ; Chargement du caract�re '3' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la troisi�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'n'      ; Chargement du caract�re 'n' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la quatri�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'v'      ; Chargement du caract�re 'v' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la cinqui�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    MOVLW '3'      ; Chargement du caract�re '3' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la sixi�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'n'      ; Chargement du caract�re 'n' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la septi�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la prochaine position
    MOVLW 'u'      ; Chargement du caract�re 'u' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la huiti�me position de la RAM (FSR0)
    INCF FSR0L, F  ; Incr�mentation de FSR0L pour pointer vers la derni�re position
    MOVLW '3'      ; Chargement du caract�re '3' dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la neuvi�me et derni�re position de la RAM (FSR0)

    ; Fin de la cha�ne avec le caract�re nul (0x00)
    MOVLW 0x00     ; Chargement de la valeur 0x00 dans WREG
    MOVWF INDF0    ; Stockage de WREG dans la derni�re position de la RAM (FSR0)

	
GOTO $                          ; loop forever

    END

    

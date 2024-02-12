include "p18F23K20.inc"   ; Inclure le fichier d'en-t�te pour PIC18F23K20

RES_VECT    CODE    0x0000    ; D�finir le vecteur de r�initialisation
    GOTO    MAIN              ; Aller � l'�tiquette principale

; *****************************************************************************
MAIN:                          ; �tiquette principale
    MOVLW   0x46              ; Charger la valeur litt�rale 0x46 dans WREG
    MOVWF   FSR0L             ; D�placer WREG dans FSR0L
    MOVLW   0x03              ; Charger la valeur litt�rale 0x03 dans WREG
    MOVWF   FSR0H             ; D�placer WREG dans FSR0H

    MOVLW   0x24              ; Charger la valeur litt�rale 0x24 dans WREG
    MOVWF   INDF0             ; D�placer WREG dans INDF0
    MOVLW   0x63              ; Charger la valeur litt�rale 0x63 dans WREG
    MOVWF   POSTINC0          ; D�placer WREG dans POSTINC0

    MOVLW   0x19              ; Charger la valeur litt�rale 0x19 dans WREG
    MOVWF   INDF0             ; D�placer WREG dans INDF0
    MOVLW   0x58              ; Charger la valeur litt�rale 0x58 dans WREG
    MOVWF   POSTINC0          ; D�placer WREG dans POSTINC0

    GOTO    $                ; Boucle infinie pour emp�cher la fin du programme

END                          ; Fin du programme

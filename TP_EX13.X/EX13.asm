include "p18F23K20.inc"   ; Inclure le fichier d'en-tête pour PIC18F23K20

RES_VECT    CODE    0x0000    ; Définir le vecteur de réinitialisation
    GOTO    MAIN              ; Aller à l'étiquette principale

; *****************************************************************************
MAIN:                          ; Étiquette principale
    MOVLW   0x46              ; Charger la valeur littérale 0x46 dans WREG
    MOVWF   FSR0L             ; Déplacer WREG dans FSR0L
    MOVLW   0x03              ; Charger la valeur littérale 0x03 dans WREG
    MOVWF   FSR0H             ; Déplacer WREG dans FSR0H

    MOVLW   0x24              ; Charger la valeur littérale 0x24 dans WREG
    MOVWF   INDF0             ; Déplacer WREG dans INDF0
    MOVLW   0x63              ; Charger la valeur littérale 0x63 dans WREG
    MOVWF   POSTINC0          ; Déplacer WREG dans POSTINC0

    MOVLW   0x19              ; Charger la valeur littérale 0x19 dans WREG
    MOVWF   INDF0             ; Déplacer WREG dans INDF0
    MOVLW   0x58              ; Charger la valeur littérale 0x58 dans WREG
    MOVWF   POSTINC0          ; Déplacer WREG dans POSTINC0

    GOTO    $                ; Boucle infinie pour empêcher la fin du programme

END                          ; Fin du programme

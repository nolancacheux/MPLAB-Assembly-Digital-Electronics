    include "p18F23K20.inc"

    CONFIG FOSC = INTIO67    ; Oscillateur interne, port fonction sur RA6 et RA7
    CONFIG WDTEN = OFF       ; Watchdog Timer désactivé
    CONFIG LVP = OFF         ; Low-Voltage Programming désactivé

    ORG 0x0000               ; Adresse de départ pour le programme
    goto MAIN                ; Aller à l'étiquette principale

    ; Déclaration des variables pour les boucles de temporisation
    cblock 0x70
        var0
        var1
        var2
    endc

    ; Routine de temporisation
routine_tempo:
    MOVLW d'255'             ; Valeur initiale de var0
    MOVWF var0
boucle_var0:
    MOVLW d'255'             ; Valeur initiale de var1
    MOVWF var1
boucle_var1:
    MOVLW d'255'             ; Valeur initiale de var2
    MOVWF var2
boucle_var2:
    DECFSZ var2, F           ; Décrémente var2 et saute si 0
    goto boucle_var2         ; Boucle sur var2
    DECFSZ var1, F           ; Décrémente var1 et saute si 0
    goto boucle_var1         ; Boucle sur var1
    DECFSZ var0, F           ; Décrémente var0 et saute si 0
    goto boucle_var0         ; Boucle sur var0
    RETURN                   ; Retourne au programme principal

    ; Programme principal
MAIN:
    MOVLW b'01100001'        ; Configuration du registre OSCCON pour 4MHz
    MOVWF OSCCON

    CLRF TRISA               ; Configure PORTA (RA0-RA3) en sortie
    CLRF TRISC               ; Configure PORTC (RC0-RC3) en sortie

    ; Boucle principale pour alterner les LEDs
boucle_leds:
    MOVLW 0x55               ; Première valeur pour les LEDs
    MOVWF PORTA
    MOVWF PORTC
    CALL routine_tempo       ; Appelle la routine de temporisation
    MOVLW 0xAA               ; Seconde valeur pour les LEDs (complémentaire)
    MOVWF PORTA
    MOVWF PORTC
    CALL routine_tempo       ; Appelle la routine de temporisation
    goto boucle_leds         ; Répète la boucle

    END                      ; Fin du programme

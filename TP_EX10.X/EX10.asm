    include "p18F23K20.inc"

    CONFIG FOSC = INTIO67    ; Oscillateur interne, port fonction sur RA6 et RA7
    CONFIG WDTEN = OFF       ; Watchdog Timer désactivé
    CONFIG LVP = OFF         ; Low-Voltage Programming désactivé

    ORG 0x0000               ; Adresse de départ pour le programme
    goto MAIN                ; Aller à l'étiquette principale

    ; Sous-programme de temporisation basée sur le Timer0
routine_tempo:
    BCF INTCON, TMR0IF       ; Efface le flag d?overflow du Timer0
    MOVLW 0x06               ; Charge la valeur dans T0CON pour un prescaler de 1:128 et Timer ON
    MOVWF T0CON
    MOVLW HIGH(0xFFFF - 0x8000)  ; Charge la valeur haute pour un délai d'environ 1 seconde
    MOVWF TMR0H
    MOVLW LOW(0xFFFF - 0x8000)   ; Charge la valeur basse pour un délai d'environ 1 seconde
    MOVWF TMR0L
    BSF T0CON, TMR0ON        ; Démarre le Timer0

WaitForOverflow:
    BTFSS INTCON, TMR0IF     ; Vérifie si le flag d?overflow est mis
    goto WaitForOverflow     ; Attend le débordement (overflow) du Timer0
    BCF INTCON, TMR0IF       ; Efface le flag d?overflow pour la prochaine utilisation
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

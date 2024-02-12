    include "p18F23K20.inc"

    CONFIG FOSC = INTIO67    ; Oscillateur interne, port fonction sur RA6 et RA7
    CONFIG WDTEN = OFF       ; Watchdog Timer d�sactiv�
    CONFIG LVP = OFF         ; Low-Voltage Programming d�sactiv�

    ORG 0x0000               ; Adresse de d�part pour le programme
    goto MAIN                ; Aller � l'�tiquette principale

    ; Sous-programme de temporisation bas�e sur le Timer0
routine_tempo:
    BCF INTCON, TMR0IF       ; Efface le flag d?overflow du Timer0
    MOVLW 0x06               ; Charge la valeur dans T0CON pour un prescaler de 1:128 et Timer ON
    MOVWF T0CON
    MOVLW HIGH(0xFFFF - 0x8000)  ; Charge la valeur haute pour un d�lai d'environ 1 seconde
    MOVWF TMR0H
    MOVLW LOW(0xFFFF - 0x8000)   ; Charge la valeur basse pour un d�lai d'environ 1 seconde
    MOVWF TMR0L
    BSF T0CON, TMR0ON        ; D�marre le Timer0

WaitForOverflow:
    BTFSS INTCON, TMR0IF     ; V�rifie si le flag d?overflow est mis
    goto WaitForOverflow     ; Attend le d�bordement (overflow) du Timer0
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
    MOVLW 0x55               ; Premi�re valeur pour les LEDs
    MOVWF PORTA
    MOVWF PORTC
    CALL routine_tempo       ; Appelle la routine de temporisation
    MOVLW 0xAA               ; Seconde valeur pour les LEDs (compl�mentaire)
    MOVWF PORTA
    MOVWF PORTC
    CALL routine_tempo       ; Appelle la routine de temporisation
    goto boucle_leds         ; R�p�te la boucle

    END                      ; Fin du programme

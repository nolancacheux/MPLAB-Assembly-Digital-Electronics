    include "p18F23K20.inc"

    CONFIG FOSC = INTIO67    ; Oscillateur interne, port fonction sur RA6 et RA7
    CONFIG WDTEN = OFF       ; Watchdog Timer d�sactiv�
    CONFIG LVP = OFF         ; Low-Voltage Programming d�sactiv�
    CONFIG PBADEN = OFF      ; PORTB<4:0> pins are configured as digital I/O on Reset

    ORG 0x0000               ; Adresse de d�part pour le programme
    goto MAIN                ; Aller � l'�tiquette principale

    ; Programme principal
MAIN:
    MOVLW b'01100001'        ; Configuration du registre OSCCON pour 4MHz
    MOVWF OSCCON

    ; Configuration des ports
    CLRF TRISA               ; Configure PORTA en entr�e/sortie
    BSF TRISA, 5             ; Configure RA5 comme entr�e analogique
    CLRF TRISC               ; Configure PORTC en sortie
    BSF TRISC, 3             ; Configure RC3/P1A (PWM output) en sortie

    ; Configuration du module ADC
    MOVLW 0x01               ; AN4 configur� comme entr�e analogique
    MOVWF ANSEL
    MOVLW 0x0E               ; Configure ADCON1 pour que les tensions de r�f�rence soient VSS et VDD
    MOVWF ADCON1
    MOVLW 0xB4               ; Configure ADCON2 pour un r�sultat justifi� � gauche, Fosc/4, Acq. time 8 TAD
    MOVWF ADCON2

    ; Configuration du Timer2 pour PWM avec une p�riode de 20ms
    MOVLW 0x7A               ; Configure T2CON pour prescaler de 1:16, Timer2 ON
    MOVWF T2CON
    MOVLW 0xFA               ; Configure PR2 pour une p�riode de signal PWM de 20ms
    MOVWF PR2

    ; Configuration du PWM pour servomoteur
    MOVLW 0x0C               ; Configure CCP2CON pour le mode PWM, bits de poids faible du duty � 0
    MOVWF CCP2CON
    BCF TRISB, 3             ; Configure la patte RB3/P1A (sortie de la PWM par d�faut) en sortie

    ; Boucle principale pour lire ADC et ajuster PWM
boucle_pwm:
    CALL ReadADC             ; Lecture de la valeur ADC
    ; Convertit la valeur ADC pour ajuster CCPR2L entre les valeurs pour 0.5ms et 2.5ms
    ; Ici, vous devez impl�menter le calcul pour ajuster le rapport cyclique en fonction de la valeur ADC
    MOVWF CCPR2L             ; Met � jour le registre de rapport cyclique du PWM
    goto boucle_pwm          ; R�p�te la boucle

    ; Sous-programme pour lire la valeur ADC
ReadADC:
    MOVLW 0x31               ; S�lectionne AN4 et met en marche le convertisseur ADC
    MOVWF ADCON0
    BSF ADCON0, GO           ; D�marre la conversion
attente_conversion:
    BTFSC ADCON0, GO         ; Attend que la conversion soit termin�e
    goto attente_conversion
    RETURN                   ; Retourne au programme principal

    END                      ; Fin du programme

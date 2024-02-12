    include "p18F23K20.inc"

    ; Configuration des bits
    CONFIG FOSC = INTIO67, WDTEN = OFF, LVP = OFF

    ORG 0x0000
    goto MAIN

    ; Programme principal
    MAIN:
        ; Configuration de l'oscillateur à 4 MHz
        MOVLW b'01100001' ; Configuration du registre OSCCON pour 4MHz
        MOVWF OSCCON

        ; Configuration des ports A et C en sortie
        CLRF TRISA ; Configure PORTA (RA0-RA3) en sortie
        CLRF TRISC ; Configure PORTC (RC0-RC3) en sortie

        ; Boucle principale pour alterner les LEDs
    Boucle_LEDs:
        MOVLW b'01010101' ; Valeur pour allumer une LED sur deux
        MOVWF PORTA
        MOVWF PORTC
        CALL Delay
        MOVLW b'10101010' ; Complément pour allumer les autres LEDs
        MOVWF PORTA
        MOVWF PORTC
        CALL Delay
        GOTO Boucle_LEDs

    ; Sous-programme de délai (approximativement 1ms)
    Delay:
        MOVLW 0xFF
        MOVWF temp, 0

    Boucle_Delay:
        DECF temp, 1, 0
        BZ Fin_Delay
        GOTO Boucle_Delay

    Fin_Delay:
        RETURN

    ; Zone de données et variables
    cblock 0x100
        temp
    endc

    END

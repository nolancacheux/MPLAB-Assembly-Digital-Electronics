#include <p18f25k40.inc>

; CONFIGURATION BITS (les bits de configuration doivent correspondre aux besoins de votre application)
CONFIG FEXTOSC=OFF, RSTOSC=HFINTOSC_1MHZ, CLKOUTEN=OFF, CSWEN=ON, FCMEN=ON
CONFIG MCLRE=EXTMCLR, PWRTE=OFF, LPBOREN=OFF, BOREN=SBORDIS
CONFIG BORV=VBOR_2P45, ZCD=OFF, PPS1WAY=ON, STVREN=ON, DEBUG=OFF, XINST=OFF
CONFIG WDTCPS=WDTCPS_31, WDTE=OFF, WDTCWS=WDTCWS_7, WDTCCS=SC
CONFIG WRT0=OFF, WRT1=OFF, WRT2=OFF, WRT3=OFF, WRTC=OFF, WRTB=OFF, WRTD=OFF, SCANE=ON, LVP=OFF
CONFIG CP=OFF, CPD=OFF, EBTR0=OFF, EBTR1=OFF, EBTR2=OFF, EBTR3=OFF, EBTRB=OFF

; DÉFINITIONS DES VARIABLES
GPR_VAR UDATA
compteur1 RES 1
compteur2 RES 1
compteur3 RES 1

; VECTEUR DE RÉINITIALISATION
RES_VECT CODE 0x0000
    GOTO DEBUT

; PROGRAMME PRINCIPAL
MAIN_PROG CODE

DEBUT

    ; Initialisation de PORTA et PORTC pour la sortie des LED
    CLRF LATA
    CLRF LATB
    CLRF LATC
    MOVLW 0x00 ; Configure tous les broches de PORTA et PORTC en sortie
    MOVWF TRISA
    MOVWF TRISB
    MOVWF TRISC

boucle
    CALL etat_LED1
    CALL routine_tempo
    CALL etat_LED2
    CALL routine_tempo
    GOTO boucle

routine_tempo
    MOVLW 0xFF
    MOVWF compteur1
    MOVLW 0xFF
    MOVWF compteur2

boucle_tempo
    DECFSZ compteur1, F
    GOTO boucle_tempo
    DECFSZ compteur2, F
    GOTO boucle_tempo
    RETURN

etat_LED1
    ; Allumer un LED sur deux
    MOVLW 0x55
    MOVWF LATA
    MOVWF LATB
    MOVWF LATC
    RETURN

etat_LED2
    ; Allumer les LEDs alternées
    MOVLW 0xAA
    MOVWF LATA
    MOVWF LATB
    MOVWF LATC
    RETURN

END

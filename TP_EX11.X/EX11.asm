    include "p18F23K20.inc"

    CONFIG FOSC = INTIO67    ; Oscillateur interne, port fonction sur RA6 et RA7
    CONFIG WDTEN = OFF       ; Watchdog Timer d�sactiv�
    CONFIG LVP = OFF         ; Low-Voltage Programming d�sactiv�
    CONFIG PBADEN = OFF      ; PORTB<4:0> pins are configured as digital I/O on Reset
    CONFIG MCLRE = ON        ; MCLR pin enabled; RE3 input disabled

    ORG 0x0000               ; Adresse de d�part pour le programme
    goto MAIN                ; Aller � l'�tiquette principale
    ORG 0x0008               ; Adresse de l'interruption
    goto ISR                 ; Saut � la routine d'interruption

    ; Routine d'interruption
ISR:
    BTFSC INTCON, INT0IF     ; V�rifie si l'interruption INT0 a �t� d�clench�e
    CALL ToggleTimer         ; Bascule l'�tat du Timer0
    BTFSC INTCON3, INT1IF    ; V�rifie si l'interruption INT1 a �t� d�clench�e
    CALL ToggleTimer         ; Bascule l'�tat du Timer0
    ; Efface les flags d'interruption pour �viter les interruptions en boucle
    BCF INTCON, INT0IF
    BCF INTCON3, INT1IF
    RETFIE                   ; Retour de l'interruption

    ; Programme principal
MAIN:
    MOVLW b'01100001'        ; Configuration du registre OSCCON pour 4MHz
    MOVWF OSCCON

    ; Configuration des interruptions
    MOVLW b'00010000'        ; Active les interruptions INT0 et INT1 sur front descendant
    MOVWF INTCON2
    BSF INTCON, INT0IE       ; Active l'interruption INT0
    BSF INTCON3, INT1IE      ; Active l'interruption INT1
    BSF INTCON, GIE          ; Active les interruptions globales

    ; Boucle principale - Rien � faire, tout est g�r� par les interruptions
boucle_principale:
    goto boucle_principale

    ; Sous-programme pour basculer l'�tat du Timer0
ToggleTimer:
    BTFSC T0CON, TMR0ON      ; V�rifie si le Timer0 est en marche
    GOTO StopTimer           ; Si oui, l'arr�te
    GOTO StartTimer          ; Si non, le d�marre

StartTimer:
    MOVLW HIGH(0xFFFF - 0x8000)  ; Charge la valeur haute pour un d�lai d'environ 1 seconde
    MOVWF TMR0H
    MOVLW LOW(0xFFFF - 0x8000)   ; Charge la valeur basse pour un d�lai d'environ 1 seconde
    MOVWF TMR0L
    BSF T0CON, TMR0ON        ; D�marre le Timer0
    RETURN

StopTimer:
    BCF T0CON, TMR0ON        ; Arr�te le Timer0
    RETURN

    END                      ; Fin du programme

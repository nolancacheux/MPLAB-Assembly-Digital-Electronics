;*******************************************************************************

; TODO INSERT INCLUDE CODE HERE

; PIC18F25K40 Configuration Bit Settings

; Assembly source line config statements

#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = OFF        ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)
;  CONFIG  RSTOSC = HFINTOSC_1MHZHFINTOSC ; with HFFRQ = 4 MHz and CDIV = 4:1    ; Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))

; CONFIG1H
  CONFIG  CLKOUTEN = ON       ; Clock Out Enable bit (CLKOUT function is disabled)
  CONFIG  CSWEN = ON            ; Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor enabled)

; CONFIG2L
  CONFIG  MCLRE = EXTMCLR       ; Master Clear Enable bit (If LVP = 0, MCLR pin is MCLR; If LVP = 1, RE3 pin function is MCLR )
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (Power up timer disabled)
  CONFIG  LPBOREN = OFF         ; Low-power BOR enable bit (ULPBOR disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled , SBOREN bit is ignored)

; CONFIG2H
  CONFIG  BORV = VBOR_2P45      ; Brown Out Reset Voltage selection bits (Brown-out Reset Voltage (VBOR) set to 2.45V)
  CONFIG  ZCD = OFF             ; ZCD Disable bit (ZCD disabled. ZCD can be enabled by setting the ZCDSEN bit of ZCDCON)
  CONFIG  PPS1WAY = ON          ; PPSLOCK bit One-Way Set Enable bit (PPSLOCK bit can be cleared and set only once; PPS registers remain locked after one clear/set cycle)
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  DEBUG = OFF           ; Debugger Enable bit (Background debugger disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Extended Instruction Set and Indexed Addressing Mode disabled)

; CONFIG3L
  CONFIG  WDTCPS = WDTCPS_31    ; WDT Period Select bits (Divider ratio 1:65536; software control of WDTPS)
  CONFIG  WDTE = OFF             ; WDT operating mode (WDT enabled regardless of sleep)

; CONFIG3H
  CONFIG  WDTCWS = WDTCWS_7     ; WDT Window Select bits (window always open (100%); software control; keyed access not required)
  CONFIG  WDTCCS = SC           ; WDT input clock selector (Software Control)

; CONFIG4L
  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3 (006000-007FFFh) not write-protected)

; CONFIG4H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-30000Bh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)
  CONFIG  SCANE = ON            ; Scanner Enable bit (Scanner module is available for use, SCANMD bit can control the module)
  CONFIG  LVP = OFF            ; Low Voltage Programming Enable bit (Low voltage programming enabled. MCLR/VPP pin function is MCLR. MCLRE configuration bit is ignored)

; CONFIG5L
  CONFIG  CP = OFF              ; UserNVM Program Memory Code Protection bit (UserNVM code protection disabled)
  CONFIG  CPD = OFF             ; DataNVM Memory Code Protection bit (DataNVM code protection disabled)

; CONFIG5H

; CONFIG6L
  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection Block 3 (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG6H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0007FFh) not protected from table reads executed in other blocks)




;*******************************************************************************
;
; TODO Step #2 - Configuration Word Setup
;*******************************************************************************

; TODO INSERT CONFIG HERE

;*******************************************************************************
;
; TODO Step #3 - Variable Definitions
;*******************************************************************************

; TODO PLACE VARIABLE DEFINITIONS GO HERE
GPR_VAR	    UDATA 
COUNTER     RES		1      ; User variable linker places   
LOOP_COUNTER	RES     1      ; User variable linker places    
LED_BITS        RES	1      ; User variable linker places



;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
GOTO    DEBUT                   ; go to beginning of program

;*******************************************************************************
; TODO Step #4 - Interrupt Service Routines
;*******************************************************************************

; TODO INSERT ISR HERE
ISRHV     CODE    0x0008
GOTO    HIGH_ISR

ISRH      CODE                     ; let linker place high ISR routine
    HIGH_ISR

    MOVLB 0x00
    INCF COUNTER, 1, 1

    BTFSC COUNTER, 3
    CLRF COUNTER

    ;MOVFF COUNTER, ADPCH

    CALL LED_RESET

    MOVFF COUNTER, LOOP_COUNTER
    MOVLW b'00000001'
    MOVWF LED_BITS
    
    CHOOSE_LED
	DCFSNZ LOOP_COUNTER
	GOTO SET_LED
	RLNCF LED_BITS
	GOTO CHOOSE_LED

    SET_LED
	BTFSC LED_BITS, 7
	BCF LATB, 5

	BTFSC LED_BITS, 0
	BCF LATB, 4

	BTFSC LED_BITS, 1
	BCF LATB, 3

	BTFSC LED_BITS, 2
	BCF LATB, 2

	BTFSC LED_BITS, 3
	BCF LATC, 7

	BTFSC LED_BITS, 4
	BCF LATC, 6

	BTFSC LED_BITS, 5
	BCF LATC, 5

	BTFSC LED_BITS, 6
	BCF LATC, 4

	MOVLB 0x0E
	BCF PIR0, 0

	RETFIE  FAST



;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE                      ; let linker place main program

DEBUT

    CLRF COUNTER
    ;PORT C
    CLRF PORTC
    CLRF LATC 
    MOVLW b'00000000'
    MOVWF TRISC

    ;PORT A
    CLRF PORTA
    CLRF LATA 
    MOVLW b'11111111'
    MOVWF TRISA

    ;PORT B
    CLRF PORTB
    CLRF LATB
    MOVLB 0x0F
    MOVLW b'00000000'
    MOVWF ANSELB, 1
    MOVLW b'00000001'
    MOVWF TRISB

    CALL LED_RESET
    BCF LATC, 4


    MOVLB 0x0E

    MOVLW b'01100000'
    MOVWF OSCCON1, 1


    MOVLW b'00000011' ;Met la frqc de l'oscilateur à 8MHz     100 = 12Mhz   010 = 4Mhz
    MOVWF OSCFRQ ,1

    BSF OSCSTAT ,6




    ; début de la configuration
    MOVLW b'00000100'
    MOVWF CCPTMRS ; associe le module CCP2 avec le timer 2
    ;MOVLB 0x _ _ ; sélection de la banque d?adresse
    MOVLW 0x06
    MOVWF RC1PPS, 1 ; associe le pin RC1 avec la fonction de sortie de CCP2
    BSF TRISC, 1 ; désactivation de la sortie PWM pour configuration
    MOVLW 0xFF
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    MOVLW b'10001100'
    MOVWF CCP2CON ; configuration du module CCP2 et format des données
    MOVLW d'00000000'
    MOVWF CCPR2H
    MOVLW 0xFF
    MOVWF CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
    MOVLW b'00000001'
    MOVWF T2CLKCON ; configuration de l?horloge du timer 2 = Fosc/4
    MOVLW b'11000000'
    MOVWF T2CON ; choix des options du timer 2 (voir p.256)
    BCF TRISC, 1 ; activation de la sortie PWM
    ; fin de la configuration

    ; début de la configuration
    MOVLB 0x0E ; sélection de la banque d?adresse
    MOVLW b'00000000'
    MOVWF ADPCH, 1 ; sélection du channel ADC
    MOVLW b'00000000'
    MOVWF ADREF, 1 ; configuration des références analogiques
    MOVLW b'00001111'
    MOVWF ADCLK, 1 ; configuration de l?horloge de l?ADC : 1?s ? TAD ? 6?s
    MOVLW b'00001000'
    MOVWF ADACQ, 1 ; configuration du temps d?acquisition
    CLRF ADPRE, 1 ; configuration du temps de précharge (min. par défaut)
    CLRF ADCAP, 1 ; pas de capacité additionnelle
    MOVLW b'00000000'
    MOVWF ADACT, 1 ; pas d?activation auto. de l?ADC sur événement
    MOVLW b'00000000'
    MOVWF ADCON3, 1 ; pas d?interruption sur l?ADC
    MOVLW b'00000000'
    MOVWF ADCON2, 1 ; configuration de l?ADC en mode basique
    MOVLW b'00000000'
    MOVWF ADCON1, 1 ; configuration des options de précharge
    MOVLW b'10000000'
    MOVWF ADCON0 ; configuration générale et format du résultat
    ; fin de la configuration

    MOVLW b'11100001'
    MOVWF INTCON ; interrupt on raising edge INT0

    MOVLW b'00000001'
    MOVWF PIE0, 1 ; enable INT0 

    BOUCLE


	BSF ADCON0,0 ;Start conversion

	ADCPoll
	BTFSC ADCON0,0 ;Is conversion done?
	BRA ADCPoll ;No, test again

	BTFSS PORTB, 0
	BSF TRISC, 1
	BTFSC PORTB, 0
	BCF TRISC, 1

	;MOVFF ADRESH, CCPR2H
	;MOVFF ADRESL ,CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
	MOVFF ADRESH, T2PR

	GOTO BOUCLE

	GOTO $                     ; loop forever

    LED_RESET
	MOVLW b'00111101'
	MOVWF LATB  
	MOVLW b'11110000'
	MOVWF LATC
	RETURN
END
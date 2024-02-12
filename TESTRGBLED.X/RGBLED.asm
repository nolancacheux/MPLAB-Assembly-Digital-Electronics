#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)
  CONFIG  RSTOSC = HFINTOSC_64MHZ; Power-up default value for COSC bits (HFINTOSC with HFFRQ = 64 MHz and CDIV = 1:1)

; CONFIG1H
  CONFIG  CLKOUTEN = OFF        ; Clock Out Enable bit (CLKOUT function is disabled)
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
  CONFIG  LVP = OFF              ; Low Voltage Programming Enable bit (Low voltage programming enabled. MCLR/VPP pin function is MCLR. MCLRE configuration bit is ignored)

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


; TODO PLACE VARIABLE DEFINITIONS GO HERE
LED_PIN equ RB0 ; Définir la broche de la LED

INT_VAR UDATA_ACS
NB_LED RES 1
RESULTHI RES 1
RESULTLO RES 1
incre RES 1

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    BEGIN                   ; go to beginning of program


    
MAIN_PROG CODE                      ; let linker place main program
  
BEGIN
    
; On met la fréquence à 64MHz
    MOVLW b'01000000'
    MOVWF OSCCON1
    MOVWF OSCCON2
    
; Configuration des ports en sortie
    CLRF TRISB
    CLRF TRISA
    
    MOVLB 0x0E	
    BCF TRISC, 3

; Configuration des bits de configuration du microcontrôleur
LED_PIN equ LATC0 ; Définir la broche de la LED sur LATC0

; CONFIGURATION ADC
    BANKSEL ADCON1 ;
    
   ; début de la configuration de l'ADC
    MOVLB 0x0F; ;sélection de la banque d'adresse, 
    ;data sheet ADPCH : F5Fh, donc F adresse de la bank
    MOVLW b'00000101' ; schéma ADC : ANA5 => datasheet ANA 5 = 000101 (p447)
    MOVWF ADPCH, 1 ; sélection du channel ADC
    MOVLW b'00000000' ;voir datasheet (aide cours)
    MOVWF ADREF, 1 ; configuration des références analogiques
    MOVLW b'00000001' ; bit 7-6 Unimplemented: Read as ?0? bit 5-0 000001 = FOSC/4
    MOVWF ADCLK, 1 ; configuration de l?horloge de l?ADC : 1µs ? TAD ? 6µs
    MOVLW b'11111111'
    MOVWF ADPRE, 1 ; configuration du temps de précharge (max. par défaut)
    MOVWF ADACQ, 1 ; configuration du temps d?acquisition (max. par défaut)
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
;PWM
; début de la configuration
    MOVLW b'00000100'
    MOVWF CCPTMRS ; associe le module CCP2 avec le timer 2
    MOVLB 0x0E ; sélection de la banque d?adresse
    MOVLW 0x06
    MOVWF RC1PPS, 1 ; associe le pin RC1 avec le module CCP2 (voir p.213)
    BSF TRISC, 1 ; désactivation de la sortie PWM pour configuration
    MOVLW d'250' 
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    MOVLW b'10011100'
    MOVWF CCP2CON ; configuration du module CCP2 et format des données
    MOVLW d'32' ;A la base 128 mais comme a gauche on divise par 4 donc 32
    MOVWF CCPR2H
    MOVLW d'0'
    MOVWF CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
    MOVLW b'00000001'
    MOVWF T2CLKCON ; configuration de l?horloge du timer 2 = Fosc/4
    MOVLW b'10000000'
    MOVWF T2CON ; choix des options du timer 2 (voir p.256)
    BCF TRISC, 1 ; activation de la sortie PWM
; fin de la configuration
    
    
BOUCLE
    
    GOTO send0
; **********************     LEDS RGB	  **********************    
send0
    BSF LATC, 3
    NOP
    NOP
    NOP
    NOP
    BCF LATC, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RETURN
send1
    BSF LATC, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BCF LATC, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RETURN
    

    
    
    
; ********************** ADC LEDS DE CTRL **********************
    
; CONVERSION ADC
    MOVLW b'10000000'	;Select channel
    MOVWF ADCON0	;Turn ADC On

    BSF ADCON0,ADGO	;Start conversion
    BTFSC ADCON0,ADGO	;Is conversion done?
    GOTO $-2		;No, test again
    BANKSEL ADRESH
    MOVF ADRESH,W	;Read upper 2 bits
    MOVWF RESULTHI	;store in GPR space
    BANKSEL ADRESL
    MOVF ADRESL,W	;Read lower 8 bits
    MOVWF RESULTLO	;Store in GPR space
; FIN CONVERSION ADC
   
    
   
; AFFICHAGE LEDS
    MOVLW 0x00
    CPFSLT ADRESH
    CALL LED_RESET
    
    MOVLW 0x20
    CPFSLT ADRESH
    CALL LED_0
    
    MOVLW 0x40
    CPFSLT ADRESH
    CALL LED_1
    
    MOVLW 0x60
    CPFSLT ADRESH
    CALL LED_2
    
    MOVLW 0x80
    CPFSLT ADRESH
    CALL LED_3
    
    MOVLW 0xA0
    CPFSLT ADRESH
    CALL LED_4
    
    MOVLW 0xC0
    CPFSLT ADRESH
    CALL LED_5
    
    MOVLW 0xE0
    CPFSLT ADRESH
    CALL LED_6
    
    MOVLW 0xFF
    CPFSLT ADRESH
    CALL LED_7
    
    GOTO BOUCLE

    
    
; ********************** FONCTIONS **********************
    
LED_0
    MOVLW b'00000001'
    MOVWF LATA
;    MOVLW d'61' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_1
    MOVLW b'00000011'
    MOVWF LATA
;    MOVLW d'71' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_2
    MOVLW b'00000111'
    MOVWF LATA
;    MOVLW d'81' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_3
    MOVLW b'00001111'
    MOVWF LATA
;    MOVLW d'91' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_4
    MOVLW b'00010000'
    MOVWF LATB
;    MOVLW d'101' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_5
    MOVLW b'00110000'
    MOVWF LATB
    MOVLW d'111' 
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_6
    MOVLW b'01110000'
    MOVWF LATB
;    MOVLW d'121' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_7
    MOVLW b'11110000'
    MOVWF LATB
;    MOVLW d'131' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
LED_RESET
    CLRF LATA
    CLRF LATB
;    MOVLW d'61' 
;    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    RETURN
    
    END
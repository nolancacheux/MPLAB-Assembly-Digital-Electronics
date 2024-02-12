#include "p18f25k40.inc"

    ; TODO PLACE VARIABLE DEFINITIONS GO HERE
LED_PIN equ RB0 ; Définir la broche de la LED
 
 
; CONFIG1L
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (Oscillator not enabled)
  CONFIG  RSTOSC = HFINTOSC_64MHZ;
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
  CONFIG  WDTE = OFF            ; WDT operating mode (WDT Disabled)

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
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (HV on MCLR/VPP must be used for programming)

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

    ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
    
; VARIABLE DEFINITIONS
GPR_VAR UDATA_ACS   0x00
prog RES 1
 RESULTHI RES 1
 RESULTLO RES 1

 
; Déclarations de variables
cblock 0x20
    d1
    d2
    resultHi
    resultLo
endc
    

 
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START0                ; go to beginning of program
 
    MAIN_PROG CODE


  ;------------------------------------------------------------------------------
    ;                       Début du Programme                                 |
    ;------------------------------------------------------------------------------
START0


; Configuration de l'oscillateur
MOVLB 0x0E ; Sélection de la banque d'adresse
MOVLW b'01110000'
MOVWF OSCCON1 ; Configurer l'oscillateur pour utiliser l'oscillateur externe (EXTOSC)
MOVWF OSCCON2 ; Configurer l'oscillateur pour utiliser l'oscillateur externe (EXTOSC)
MOVLW b'00001000'
MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 64 MHz

; Configuration du prédiviseur
MOVLW b'00000001'
MOVWF OSCCON3 ; Configurer le prédiviseur à 2
 
 ;------------------------------------------------------------------------------
;                       Configuration de l'ADC                                |
;------------------------------------------------------------------------------

; début de la configuration de l'ADC
    MOVLB 0x0F; ;sélection de la banque d?adresse, datasheet ADPCH : F5Fh, donc F adresse de la bank
    MOVLW b'00000101' ; schéma ADC : ANA5 => data sheet ANA 5 = 000101 (p447)
    MOVWF ADPCH, 1 ; sélection du channel ADC
    MOVLW b'00000000' ; Voir cours
    MOVWF ADREF, 1 ; configuration des références analogiques
    MOVLW b'00001111' ; bit 7-6 Unimplemented: Read as ?0? bit 5-0 001111 = 1µs < FOSC/32 < 6µs
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
    MOVLW b'10000100' ; ADC enable, format right
    MOVWF ADCON0 ; configuration générale et format du résultat
; fin de la configuration
;------------------------------------------------------------------------------
    ;                       Configuration de l'PWM                                |
    ;------------------------------------------------------------------------------

    ; début de la configuration
     MOVLW b'00000100'
     MOVWF CCPTMRS ; associe le module CCP2 avec le timer 2
     MOVLB 0x0E ;data sheet bank d'adresse E 
     MOVLW 0x06 ;data sheet p213 CCP2
     MOVWF RC1PPS, 1 ; associe le pin RC1 avec le module CCP2 (voir p.213)
     BSF TRISC, 1 ; désactivation de la sortie PWM pour configuration
     MOVLW d'249'
     MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
     MOVLW b'10001100'
     MOVWF CCP2CON ; configuration du module CCP2 et format des données
     MOVLW b'01100000'
     MOVWF CCPR2H
     MOVLW b'00000001'
     MOVWF CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
     MOVLW b'00000001' 
     MOVWF T2CLKCON ; configuration de l?horloge du timer 2 = Fosc/4
     MOVLW b'10000000'
     MOVWF T2CON ; choix des options du timer 2 (voir p.256)
     BCF TRISC, 1 ; activation de la sortie PWM
    ; fin de la configuration
    
 
 
   ;Définition Port output
   BCF TRISA, 0 
   BCF TRISA, 1
   BCF TRISA, 2
   BCF TRISA, 3
   BCF TRISB, 4
   BCF TRISB, 5
   BCF TRISB, 6
   BCF TRISB, 7
   BCF TRISC, 1 
     
   ;Définition Port input
   BSF TRISB, 1 ; Configure RC7 as input

   BCF TRISC,3
   BSF LATC,3
   
  ; Configurer RC2 comme sortie
bcf TRISC, 2 ; Configurer RC2 comme sortie
; Activer le moteur
bsf LATC, 2 ; Envoyer un signal 1 à RC2

 ADC
 ; CONVERSION ADC
    movlw b'10000000' ; Select channel AN0
    movwf ADCON0 ; Turn ADC On
    bsf ADCON0,ADGO ; Start conversion
    btfsc ADCON0,ADGO ; Is conversion done?
    goto $-2 ; No, test again
    banksel ADRESH ;
    movf ADRESH,w ; Read upper 2 bits
    movwf resultHi ; Store in GPR space
    banksel ADRESL ;
    movf ADRESL,w ; Read lower 8 bits
    movwf resultLo ; Store in GPR space
    ; FIN CONVERSION ADC

    ; Gérer graduellement les valeurs en 16 bits
    movlw b'1'; Charger la valeur de resultHi dans W
    movwf CCPR2H ; Stocker dans CCPR2H
    movf resultHi, 0 ; Charger la valeur de resultLo dans W
    movwf CCPR2L ; Stocker dans CCPR2L
GOTO ADC

    
    end
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




;*******************************************************************************
;
; TODO Step #3 - Variable Definitions
;
; Refer to datasheet for available data memory (RAM) organization assuming
; relocatible code organization (which is an option in project
; properties > mpasm (Global Options)).  Absolute mode generally should
; be used sparingly.
;
; Example of using GPR Uninitialized Data
;
;   GPR_VAR        UDATA
;   MYVAR1         RES        1      ; User variable linker places
;   MYVAR2         RES        1      ; User variable linker places
;   MYVAR3         RES        1      ; User variable linker places
;
;   ; Example of using Access Uninitialized Data Section (when available)
;   ; The variables for the context saving in the device datasheet may need
;   ; memory reserved here.
;   INT_VAR        UDATA_ACS
;   W_TEMP         RES        1      ; w register for context saving (ACCESS)
;   STATUS_TEMP    RES        1      ; status used for context saving
;   BSR_TEMP       RES        1      ; bank select used for ISR context saving
;
;*******************************************************************************

; TODO PLACE VARIABLE DEFINITIONS GO HERE
LED_PIN equ RB0 ; D�finir la broche de la LED

INT_VAR UDATA_ACS
prog RES 1
isbtn1pressed RES 1
isbtn0pressed RES 1
un RES 1
deux RES 1
trois RES 1
quatre RES 1
cinq RES 1
six RES 1
sept RES 1
huit RES 1
NB_LED RES 1
RESULTHI RES 1
RESULTLO RES 1
incre RES 1
luminosite RES 1
onetime RES 1
alreadysend RES 1
nbnop RES 1
nbnop2 RES 1
delay RES 1
;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    BEGIN                   ; go to beginning of program

;*******************************************************************************
; TODO Step #4 - Interrupt Service Routines
;
; There are a few different ways to structure interrupt routines in the 8
; bit device families.  On PIC18's the high priority and low priority
; interrupts are located at 0x0008 and 0x0018, respectively.  On PIC16's and
; lower the interrupt is at 0x0004.  Between device families there is subtle
; variation in the both the hardware supporting the ISR (for restoring
; interrupt context) as well as the software used to restore the context
; (without corrupting the STATUS bits).
;
; General formats are shown below in relocatible format.
;
;------------------------------PIC16's and below--------------------------------
;
; ISR       CODE    0x0004           ; interrupt vector location
;
;     <Search the device datasheet for 'context' and copy interrupt
;     context saving code here.  Older devices need context saving code,
;     but newer devices like the 16F#### don't need context saving code.>
;
;     RETFIE
;
;----------------------------------PIC18's--------------------------------------
;
; ISRHV     CODE    0x0008
;     GOTO    HIGH_ISR
; ISRLV     CODE    0x0018
;     GOTO    LOW_ISR
;
; ISRH      CODE                     ; let linker place high ISR routine
; HIGH_ISR
;     <Insert High Priority ISR Here - no SW context saving>
;     RETFIE  FAST
;
; ISRL      CODE                     ; let linker place low ISR routine
; LOW_ISR
;       <Search the device datasheet for 'context' and copy interrupt
;       context saving code here>
;     RETFIE
;
;*******************************************************************************

; TODO INSERT ISR HERE

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
    
MAIN_PROG CODE                      ; let linker place main program
  
BEGIN
    

    
; Configuration des ports en sortie
    movlw 0x07
    movwf TRISB
    movlw 0x30
    movwf TRISA
    BANKSEL ANSELB
    BCF ANSELB,2
    BCF ANSELB,1

    
    MOVLB 0x0E	
    BCF TRISC, 3

; Configuration des bits de configuration du microcontr�leur
LED_PIN equ LATC0 ; D�finir la broche de la LED sur LATC0

;------------------------------------------------------------------------------
;                       Configuration de l'ADC                                |
;------------------------------------------------------------------------------

; d�but de la configuration de l'ADC
    MOVLB 0x0F; ;s�lection de la banque d?adresse, datasheet ADPCH : F5Fh, donc F adresse de la bank
    MOVLW b'00000101' ; sch�ma ADC : ANA5 => data sheet ANA 5 = 000101 (p447)
    MOVWF ADPCH, 1 ; s�lection du channel ADC
    MOVLW b'00000000' ; 
    MOVWF ADREF, 1 ; configuration des r�f�rences analogiques
    MOVLW b'00001111' ;   001111 =  FOSC/32=2 �s
    MOVWF ADCLK, 1 ; 
    MOVLW b'11111111'
    MOVWF ADPRE, 1 ; configuration du temps de pr�charge (max. par d�faut)
    MOVWF ADACQ, 1 ; configuration du temps d?acquisition (max. par d�faut)
    CLRF ADCAP, 1 ; pas de capacit� additionnelle
    MOVLW b'00000000'
    MOVWF ADACT, 1 ; pas d?activation auto. de l?ADC sur �v�nement
    MOVLW b'00000000'
    MOVWF ADCON3, 1 ; pas d?interruption sur l?ADC
    MOVLW b'00000000'
    MOVWF ADCON2, 1 ; configuration de l?ADC en mode basique
    MOVLW b'00000000'
    MOVWF ADCON1, 1 ; configuration des options de pr�charge
    MOVLW b'10000100' ; ADC enable, format right
    MOVWF ADCON0 ; configuration g�n�rale et format du r�sultat
; fin de la configuration

    
;------------------------------------------------------------------------------
;                       Configuration de l'PWM                                |
;------------------------------------------------------------------------------

; d�but de la configuration
    MOVLW b'00000100'
    MOVWF CCPTMRS ; associe le module CCP2 avec le timer 2
    MOVLB 0x0E ;  bank d'adresse E 
    MOVLW 0x06 ;  CCP2 = 6
    MOVWF RC1PPS, 1 ; associe le pin RC1 avec le module CCP2 (voir p.213)
    BSF TRISC, 1 ; d�sactivation de la sortie PWM pour configuration
    MOVLW d'200' ; 64 000 000 / ( 10 000 x 4 x 8) - 1 = 199, on arrondis � 200
    ; 64 000 000 = FOSC, 10 000 p�riode PWM, 8 = prescaler
    MOVWF T2PR ;  p�riode de PWM 
    MOVLW b'10001100'; justifier a droite
    MOVWF CCP2CON ; configuration du module CCP2 et format des donn�es
    MOVLW b'00000001'
    MOVWF CCPR2H
    MOVLW b'10000000'
    MOVWF CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
    ; 201 x 4 x 0,48 = 384
    MOVLW b'00000001' 
    MOVWF T2CLKCON ; configuration de l?horloge du timer 2 = Fosc/4
    MOVLW b'10110000'; Timer = On , prescaler  = 8, pas de postscaler
    MOVWF T2CON ; choix des options du timer 2 (voir p.256)
    BCF TRISC, 1 ; activation de la sortie PWM
; fin de la configuration
    
    ; CONVERSION ADC
    MOVLW b'10000000' ;Select channel AN0
    MOVWF ADCON0 ;Turn ADC On

    BSF ADCON0,ADGO ;Start conversion
    BTFSC ADCON0,ADGO ;Is conversion done?
    GOTO $-2 ;No, test again
    BANKSEL ADRESH ;
    MOVF ADRESH,W ;Read upper 2 bits
    MOVWF RESULTHI ;store in GPR space
    BANKSEL ADRESL ;
    MOVF ADRESL,W ;Read lower 8 bits
    MOVWF RESULTLO ;Store in GPR space
; FIN CONVERSION ADC
    
BSF TRISB, 0
BCF ANSELB, 0
    
BCF TRISC, 2 ;Mettre le port en sortie
BSF LATC, 2 ;faire tourner le moteur
    
 movlw 0x01
 movwf prog
 CLRF isbtn1pressed
 CLRF isbtn0pressed
 CLRF luminosite
 CLRF onetime
 clrf delay
 
 movlw b'00000001'
 movwf un
 movlw b'00000010'
 movwf deux
 movlw b'00000100'
 movwf trois
 movlw b'00001000'
 movwf quatre
 movlw b'00010000'
 movwf cinq
 movlw b'00110000'
 movwf six
 movlw b'01110000'
 movwf sept
 movlw b'11110000'
 movwf huit
 
 
 clrf alreadysend

    
loop 
    BTFSS PORTB,0
    clrf alreadysend
    BTFSC PORTB, 0
    BTFSC alreadysend,0
    goto skiplop
    BSF onetime,0
    movlw 0x01
    movwf alreadysend
    
skiplop
    
    BTFSC PORTB,2
    CALL BP1_released
    BTFSS PORTB,2
    goto ife2
    goto suite
ife2
    BTFSS isbtn1pressed,0
    CALL BP1_PRESSED
suite
    BTFSC PORTB,1
    CALL BP0_released
    BTFSS PORTB,1
    goto ife3
    goto suite2
ife3
    BTFSS isbtn0pressed,0
    CALL BP0_PRESSED
    
suite2
    
    call eteindre_led
    movlw 0x01
    CPFSEQ prog
    goto lab1
    CALL prog1
lab1
    movlw 0x02
    CPFSEQ prog
    goto lab2
    CALL prog2
lab2
    movlw 0x03
    CPFSEQ prog
    goto lab3
    CALL prog3
lab3
    movlw 0x04
    CPFSEQ prog
    goto lab4
    CALL prog4
lab4

    movlw 0x01
    CPFSEQ luminosite
    goto ski1
    call lum1

ski1
    movlw 0x02
    CPFSEQ luminosite
    goto ski2
    call lum2

ski2
    movlw 0x03
    CPFSEQ luminosite
    goto ski3
    call lum3

ski3
    movlw 0x04
    CPFSEQ luminosite
    goto ski4
    call lum4

ski4
    

    
goto loop
    
    
;functions
    
    
trigger_led
    
     ; CONVERSION ADC
    MOVLW b'10000000' ;Select channel AN0
    MOVWF ADCON0 ;Turn ADC On

    BSF ADCON0,ADGO ;Start conversion
    BTFSC ADCON0,ADGO ;Is conversion done?
    GOTO $-2 ;No, test again
    BANKSEL ADRESH ;
    MOVF ADRESH,W ;Read upper 2 bits
    MOVWF RESULTHI ;store in GPR space
    BANKSEL ADRESL ;
    MOVF ADRESL,W ;Read lower 8 bits
    MOVWF RESULTLO ;Store in GPR space
; FIN CONVERSION ADC
    
    MOVLW 0x00
    CPFSLT ADRESH
    CALL LUMINOSITE0
    
    MOVLW 0x02
    CPFSLT ADRESH
    CALL LUMINOSITE1
    
    MOVLW 0x55
    CPFSLT ADRESH
    CALL LUMINOSITE2
;    
    MOVLW 0xAA
    CPFSLT ADRESH
    CALL LUMINOSITE3
;    
    MOVLW 0xFD
    CPFSLT ADRESH
    CALL LUMINOSITE4

    
    return
    
    
lum1
    movf cinq,0
    movwf LATB
    return
lum2
    movf six,0
    movwf LATB
    return
lum3
    movf sept,0
    movwf LATB
    return
lum4
    movf huit,0
    movwf LATB
    return
    
LUMINOSITE0
    movlw 0x00
    movwf luminosite
    
    return
    
LUMINOSITE1
   
    movlw 0x01
    movwf luminosite
   
    

    return
    
LUMINOSITE2
   
    movlw 0x02
    movwf luminosite
    movf six,0
    movwf LATB
    

    return
    
    
LUMINOSITE3
   
    movlw 0x03
    movwf luminosite
    movf sept,0
    movwf LATB
    

    return
    
LUMINOSITE4
   
    movlw 0x04
    movwf luminosite
    movf huit,0
    movwf LATB

    return
    
    

    
    

    
eteindre_led
    movlw 0x00
    movwf LATB
    movlw 0x00
    movwf LATA
    return

    
BP1_PRESSED
    movlw 0X01
    movwf isbtn1pressed
    movwf onetime
    INCF prog
    movlw 0x05
    CPFSEQ prog
    goto skip
    goto resett
    
resett
    movlw 0x01
    movwf prog
skip
    
    return
BP0_PRESSED
    movlw 0X01
    movwf isbtn0pressed
    movwf onetime
    call trigger_led
    return

BP1_released
    movlw 0X00
    movwf isbtn1pressed
    return
BP0_released
    movlw 0X00
    movwf isbtn0pressed
    return
    
prog1
    movf un,0
    movwf LATA
    BTFSS onetime,0
    return
    movlw 0x00
    movwf onetime 
    ;   BOUCLE LEDD
    CPFSEQ luminosite
    goto ledlum0skip1
    goto ledlum0pr1
    
ledlum0pr1
    call eteindre_led
    
ledlum0skip1
    movlw 0x01
    CPFSEQ luminosite
    goto ledlum1skip1
    goto ledlum1pr1
    
ledlum1pr1
    call LED_ETEINTE
    call LEDROUGE1
     call LED_ETEINTE
    call LEDROSE1
    call LED_ETEINTE
    
    movlw 0X70
    movwf delay
    call DELAYNOPP
    
    call LEDROUGE1
    call LED_ETEINTE
    call LEDGREEN1
    call LED_ETEINTE
    call LEDROSE1
    
ledlum1skip1
   
    
    movlw 0x02
    CPFSEQ luminosite
    goto ledlum2skip1
    goto ledlum2pr1

    
ledlum2pr1
   call LED_ETEINTE
    call LEDROUGE2
     call LED_ETEINTE
    call LEDROSE2
    call LED_ETEINTE
    
    movlw 0X70
    movwf delay
    call DELAYNOPP
    
    call LEDROUGE2
    call LED_ETEINTE
    call LEDGREEN2
    call LED_ETEINTE
    call LEDROSE2
    
    
ledlum2skip1
    
    movlw 0x03
    CPFSEQ luminosite
    goto ledlum3skip1
    goto ledlum3pr1

    
ledlum3pr1
    call LED_ETEINTE
    call LEDROUGE3
     call LED_ETEINTE
    call LEDROSE3
    call LED_ETEINTE
    
    movlw 0X70
    movwf delay
    call DELAYNOPP
    
    call LEDROUGE3
    call LED_ETEINTE
    call LEDGREEN3
    call LED_ETEINTE
    call LEDROSE3
    
ledlum3skip1
    
    movlw 0x04
    CPFSEQ luminosite
    goto ledlum4skip1
    goto ledlum4pr1
    

    
ledlum4pr1
    call LED_ETEINTE
    call LEDROUGE4
     call LED_ETEINTE
    call LEDROSE4
    call LED_ETEINTE
    
    movlw 0X70
    movwf delay
    call DELAYNOPP
    
    call LEDROUGE4
    call LED_ETEINTE
    call LEDGREEN4
    call LED_ETEINTE
    call LEDROSE4

    
ledlum4skip1
    
    return
    
    
prog2
    movf deux,0
    movwf LATA
    BTFSS onetime,0
    return
    movlw 0x00
    movwf onetime
    CPFSEQ luminosite
    goto ledlum0skip2
    goto ledlum0pr2
    
ledlum0pr2
    call eteindre_led
    
ledlum0skip2
    movlw 0x01
    CPFSEQ luminosite
    goto ledlum1skip2
    goto ledlum1pr2
    
ledlum1pr2
    call LEDROUGE1
    call LEDBLEUE1
    call LEDROUGE1
    call LEDBLEUE1
    call LEDGREEN1
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
     movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
ledlum1skip2
   
    
    movlw 0x02
    CPFSEQ luminosite
    goto ledlum2skip2
    goto ledlum2pr2

    
ledlum2pr2
    call LEDROUGE2
    call LEDBLEUE2
    call LEDROUGE2
    call LEDBLEUE2
    call LEDGREEN2
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
     movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    
ledlum2skip2
    
    movlw 0x03
    CPFSEQ luminosite
    goto ledlum3skip2
    goto ledlum3pr2

    
ledlum3pr2
    call LEDROUGE3
    call LEDBLEUE3
    call LEDROUGE3
    call LEDBLEUE3
    call LEDGREEN3
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
     movlw 0x20
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
ledlum3skip2
    
    movlw 0x04
    CPFSEQ luminosite
    goto ledlum4skip2
    goto ledlum4pr2

    
ledlum4pr2
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
    movlw 0X35
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0X70
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
    movlw 0X35
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
ledlum4skip2
    return
    
    
  
prog3
    movf deux,0
    movwf LATA
    BTFSS onetime,0
    return
    movlw 0x00
    movwf onetime
    CPFSEQ luminosite
    goto ledlum0skip3
    goto ledlum0pr3
    
ledlum0pr3
    call eteindre_led
    
ledlum0skip3
    movlw 0x01
    CPFSEQ luminosite
    goto ledlum1skip3
    goto ledlum1pr3
    
ledlum1pr3
    call LEDROUGE1
    call LEDBLEUE1
    call LEDROUGE1
    call LEDBLEUE1
    call LEDGREEN1
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE1
    call LEDBLEUE1
    call LEDROUGE1
    call LEDBLEUE1
    call LEDGREEN1
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE1
    call LEDBLEUE1
    call LEDROUGE1
    call LEDBLEUE1
    call LEDGREEN1
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDJAUNE1
    call LEDBLEUE1
    call LEDROSE1
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
ledlum1skip3
   
    
    movlw 0x03
    CPFSEQ luminosite
    goto ledlum3skip3
    goto ledlum3pr3

    
ledlum2pr3
    call LEDROUGE2
    call LEDBLEUE2
    call LEDROUGE2
    call LEDBLEUE2
    call LEDGREEN2
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE2
    call LEDBLEUE2
    call LEDROUGE2
    call LEDBLEUE2
    call LEDGREEN2
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE2
    call LEDBLEUE2
    call LEDROUGE2
    call LEDBLEUE2
    call LEDGREEN2
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDJAUNE2
    call LEDBLEUE2
    call LEDROSE2
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    
ledlum2skip3
    
    movlw 0x03
    CPFSEQ luminosite
    goto ledlum3skip3
    goto ledlum3pr3

    
ledlum3pr3
    call LEDROUGE3
    call LEDBLEUE3
    call LEDROUGE3
    call LEDBLEUE3
    call LEDGREEN3
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE3
    call LEDBLEUE3
    call LEDROUGE3
    call LEDBLEUE3
    call LEDGREEN3
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE3
    call LEDBLEUE3
    call LEDROUGE3
    call LEDBLEUE3
    call LEDGREEN3
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDJAUNE3
    call LEDBLEUE3
    call LEDROSE3
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
ledlum3skip3
    
    movlw 0x04
    CPFSEQ luminosite
    goto ledlum4skip3
    goto ledlum4pr3

    
ledlum4pr3
    call LEDROUGE4
    call LEDBLEUE4
    call LEDROUGE4
    call LEDBLEUE4
    call LEDGREEN4
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE4
    call LEDBLEUE4
    call LEDROUGE4
    call LEDBLEUE4
    call LEDGREEN4
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE


    call LEDROUGE4
    call LEDBLEUE4
    call LEDROUGE4
    call LEDBLEUE4
    call LEDGREEN4
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
    movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDJAUNE4
    call LEDBLEUE4
    call LEDROSE4
    
     movlw 0x0A
    movwf delay
    call DELAYNOPP
    
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    call LED_ETEINTE
    
ledlum4skip3
    return  
    
prog4
    movf quatre,0
    movwf LATA
    return
    
prog5
    movf cinq,0
    movwf LATB
    return
prog6
    movf six,0
    movwf LATB
    return
prog7
    movf sept,0
    movwf LATB
    return
prog8
    movf huit,0
    movwf LATB
    return
bit0
    ; 1
    BSF LATC, 3
    NOP ; 1 NOP = 0,0625 �s (= 1/16 MHz car 1 NOP = 1 cycle clk)
    NOP
    NOP
    NOP
    NOP
    BCF LATC, 3
    
    NOP ; 10 NOP = 0,875 �s
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    
    RETURN
    
bit1
    ; 1
    BSF LATC, 3
    NOP ; 1 NOP = 0,0625 �s (= 1/16 MHz car 1 NOP = 1 cycle clk)
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
    
    NOP ; 10 NOP = 0,875 �s
    NOP
    NOP
    NOP	
    NOP



    
    RETURN
    
    



    
LEDROSE4
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDROSE3
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN

LEDROSE2
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN

LEDROSE1
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDJAUNE4
    
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN

LEDJAUNE3
    
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN

LEDJAUNE2
    
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
 
LEDJAUNE1
    
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
 
LEDGREEN4
       
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN 
 
LEDGREEN3
       
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN     

LEDGREEN2
       
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN    

LEDGREEN1
       
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN    

LEDROUGE4
    
        
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDROUGE3
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDROUGE2
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDROUGE1
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
;bleues
    
LEDBLEUE4
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1
    call bit1

    
    RETURN
    
LEDBLEUE3
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
        
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDBLEUE2
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
     
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN
    
LEDBLEUE1
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit1
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN  
    
    
LED_ETEINTE
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    
    RETURN  
    
    
DELAYNOP
    clrf nbnop
dol3
    NOP
    incf nbnop,1
    movlw 0xFF
    CPFSEQ nbnop 
    GOTO dol3
    RETURN
    
    
DELAYNOPP
    clrf nbnop2
    NOP
do14
    CALL DELAYNOP
    incf nbnop2,1
    movf delay,0
    CPFSEQ nbnop2 
    goto do14
    RETURN
    end
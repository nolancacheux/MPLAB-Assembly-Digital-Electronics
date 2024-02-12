#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)
  CONFIG  RSTOSC = EXTOSC       ; Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))

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
LED_PIN equ RB0 ; Définir la broche de la LED

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
    
; On met la fréquence à 16MHz
    MOVLW b'01100000'
    MOVWF OSCCON1
    MOVWF OSCCON2
    
; Configurat	ion des ports en sortie
    movlw 0x07
    movwf TRISB
    movlw 0x30
    movwf TRISA
    BANKSEL ANSELB
    BCF ANSELB,2
    BCF ANSELB,1

    
    MOVLB 0x0E	
    BCF TRISC, 3

; Configuration des bits de configuration du microcontrôleur
LED_PIN equ LATC0 ; Définir la broche de la LED sur LATC0

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
    MOVLW d'61' 
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    MOVLW b'10011100'
    MOVWF CCP2CON ; configuration du module CCP2 et format des données
    MOVLW d'32' ; A la base 128 mais comme a gauche on divise par 4 donc 32 
    MOVWF CCPR2H
    MOVLW d'0'
    MOVWF CCPR2L ; fixe le rapport cyclique du signal (voir formule p.272)
    MOVLW b'00000001'
    MOVWF T2CLKCON ; configuration de l?horloge du timer 2 = Fosc/4
    MOVLW b'10000000'
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
    
    
 movlw 0x01
 movwf prog
 CLRF isbtn1pressed
 CLRF isbtn0pressed
 CLRF luminosite
 
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
 movlw b'00100000'
 movwf six
 movlw b'01000000'
 movwf sept
 movlw b'10000000'
 movwf huit
 

    
loop 
    

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
    movlw 0x05
    CPFSEQ prog
    goto lab5
    CALL prog5
lab5
    movlw 0x06
    CPFSEQ prog
    goto lab6
    CALL prog6
lab6
    movlw 0x07
    CPFSEQ prog
    goto lab7
    CALL prog7
lab7
    movlw 0x08
    CPFSEQ prog
    goto lab8
    CALL prog8
lab8
    

    
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
    
    MOVLW 0x33
    CPFSLT ADRESH
    CALL LUMINOSITE1
    
    MOVLW 0x66
    CPFSLT ADRESH
    CALL LUMINOSITE2
;    
    MOVLW 0x99
    CPFSLT ADRESH
    CALL LUMINOSITE3
;    
    MOVLW 0xFF
    CPFSLT ADRESH
    CALL LUMINOSITE4

    
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
    

    return
    
    
LUMINOSITE3
   
    movlw 0x03
    movwf luminosite
    

    return
    
LUMINOSITE4
   
    movlw 0x04
    movwf luminosite
    

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
    INCF prog
    movlw 0x09
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
    
    movlw 0x00
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
    call LEDROUGE1
    call LEDROSE1
    
ledlum1skip1
   
    
    movlw 0x02
    CPFSEQ luminosite
    goto ledlum2skip1
    goto ledlum2pr1

    
ledlum2pr1
    call LEDROUGE2
    call LEDROSE2
    
    
ledlum2skip1
    
    movlw 0x03
    CPFSEQ luminosite
    goto ledlum3skip1
    goto ledlum3pr1

    
ledlum3pr1
    call LEDROUGE3
    call LEDROSE3
    
ledlum3skip1
    
    movlw 0x04
    CPFSEQ luminosite
    goto ledlum4skip1
    goto ledlum4pr1

    
ledlum4pr1
    call LEDROUGE4
    call LEDROSE4
    
ledlum4skip1
    return
    
    
prog2
    movf deux,0
    movwf LATA
    movlw 0x00
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
    call LEDJAUNE1
    call LEDBLEUE1
    
ledlum1skip2
   
    
    movlw 0x02
    CPFSEQ luminosite
    goto ledlum2skip2
    goto ledlum2pr2

    
ledlum2pr2
    call LEDJAUNE2
    call LEDBLEUE2
    
    
ledlum2skip2
    
    movlw 0x03
    CPFSEQ luminosite
    goto ledlum3skip2
    goto ledlum3pr2

    
ledlum3pr2
    call LEDJAUNE3
    call LEDBLEUE3
    
ledlum3skip2
    
    movlw 0x04
    CPFSEQ luminosite
    goto ledlum4skip2
    goto ledlum4pr2

    
ledlum4pr2
    call LEDJAUNE4
    call LEDBLEUE4
    
ledlum4skip2
    return
prog3
    movf trois,0
    movwf LATA
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
    NOP ; 1 NOP = 0,0625 µs (= 1/16 MHz car 1 NOP = 1 cycle clk)
    NOP
    NOP
    NOP
    NOP
    BCF LATC, 3
    
    NOP ; 10 NOP = 0,875 µs
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
    NOP ; 1 NOP = 0,0625 µs (= 1/16 MHz car 1 NOP = 1 cycle clk)
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
    
    NOP ; 10 NOP = 0,875 µs
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
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0
    call bit0

    
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
    end
;*******************************************************************************
;                                                                              *
;    Microchip licenses this software to you solely for use with Microchip     *
;    products. The software is owned by Microchip and/or its licensors, and is *
;    protected under applicable copyright laws.  All rights reserved.          *
;                                                                              *
;    This software and any accompanying information is for suggestion only.    *
;    It shall not be deemed to modify Microchip?s standard warranty for its    *
;    products.  It is your responsibility to ensure that this software meets   *
;    your requirements.                                                        *
;                                                                              *
;    SOFTWARE IS PROVIDED "AS IS".  MICROCHIP AND ITS LICENSORS EXPRESSLY      *
;    DISCLAIM ANY WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING  *
;    BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS    *
;    FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL          *
;    MICROCHIP OR ITS LICENSORS BE LIABLE FOR ANY INCIDENTAL, SPECIAL,         *
;    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, HARM TO     *
;    YOUR EQUIPMENT, COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR    *
;    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY   *
;    DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER      *
;    SIMILAR COSTS.                                                            *
;                                                                              *
;    To the fullest extend allowed by law, Microchip and its licensors         *
;    liability shall not exceed the amount of fee, if any, that you have paid  *
;    directly to Microchip to use this software.                               *
;                                                                              *
;    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF    *
;    THESE TERMS.                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Filename:                                                                 *
;    Date:                                                                     *
;    File Version:                                                             *
;    Author:                                                                   *
;    Company:                                                                  *
;    Description:                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Notes: In the MPLAB X Help, refer to the MPASM Assembler documentation    *
;    for information on assembly instructions.                                 *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Known Issues: This template is designed for relocatable code.  As such,   *
;    build errors such as "Directive only allowed when generating an object    *
;    file" will result when the 'Build in Absolute Mode' checkbox is selected  *
;    in the project properties.  Designing code in absolute mode is            *
;    antiquated - use relocatable mode.                                        *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Revision History:                                                         *
;                                                                              *
;*******************************************************************************



;*******************************************************************************
; Processor Inclusion
;
; TODO Step #1 Open the task list under Window > Tasks.  Include your
; device .inc file - e.g. #include <device_name>.inc.  Available
; include files are in C:\Program Files\Microchip\MPLABX\mpasmx
; assuming the default installation path for MPLAB X.  You may manually find
; the appropriate include file for your device here and include it, or
; simply copy the include generated by the configuration bits
; generator (see Step #2).
;
;*******************************************************************************

; TODO INSERT INCLUDE CODE HERE

;*******************************************************************************
;
; TODO Step #2 - Configuration Word Setup
;
; The 'CONFIG' directive is used to embed the configuration word within the
; .asm file. MPLAB X requires users to embed their configuration words
; into source code.  See the device datasheet for additional information
; on configuration word settings.  Device configuration bits descriptions
; are in C:\Program Files\Microchip\MPLABX\mpasmx\P<device_name>.inc
; (may change depending on your MPLAB X installation directory).
;
; MPLAB X has a feature which generates configuration bits source code.  Go to
; Window > PIC Memory Views > Configuration Bits.  Configure each field as
; needed and select 'Generate Source Code to Output'.  The resulting code which
; appears in the 'Output Window' > 'Config Bits Source' tab may be copied
; below.
;
;*******************************************************************************

; TODO INSERT CONFIG HERE

; PIC18F25K40 Configuration Bit Settings

; Assembly source line config statements

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
NB_LED RES 1
RESULTHI RES 1
RESULTLO RES 1
incre RES 1

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
    
; Configuration de l'oscillateur
    MOVLB 0x0E ; Sélection de la banque d'adresse
    MOVLW b'01110000'
    MOVWF OSCCON1 ; Configurer l'oscillateur pour utiliser l'oscillateur externe (EXTOSC)
    MOVWF OSCCON2 ; Configurer l'oscillateur pour utiliser l'oscillateur externe (EXTOSC)
    ; Pas de clock divider = 1
    MOVLW b'00001000'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 64 MHz
    
; Configuration des ports en sortie
    CLRF TRISC, 1
    CLRF TRISB
    CLRF TRISA

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
   ; fin de la configuration; début de la configuration de l'ADC
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

    
    ;PWM
; début de la configuration
    MOVLW b'00000100'
    MOVWF CCPTMRS ; associe le module CCP2 avec le timer 2
    MOVLB 0x0E ; data sheet bank d'adresse E 
    MOVLW 0x06 ; data sheet p213 CCP2 = 6
    MOVWF RC1PPS, 1 ; associe le pin RC1 avec le module CCP2 (voir p.213)
    BSF TRISC, 1 ; désactivation de la sortie PWM pour configuration
    MOVLW d'200' ; 64 000 000 / ( 10 000 x 4 x 8) - 1 = 199, on arrondis à 200
    ; 64 000 000 = FOSC, 10 000 période PWM, 8 = prescaler
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
    MOVLW b'10001100'; CPP = enable, right format, PWM operate
    MOVWF CCP2CON ; configuration du module CCP2 et format des données
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
    

    
BOUCLE
    
    
; **********************     LEDS RGB	  **********************

    
   
; ********************** ADC LEDS DE CTRL **********************
    
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
    MOVLW d'61' 
    MOVWF T2PR ; fixe la période de PWM (voir formule p.271)
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
    
    
; Calcul du rapport cyclique pour PWM avec PR2 = 200 
frequence1
    CALL LED_RESET
     MOVLW b'00000000'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 1 MHz
    RETURN
    
frequence2
    CALL LED_0
     MOVLW b'00000001'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 2 MHz
    RETURN
    
frequence4 
    CALL LED_1
     MOVLW b'00000010'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 4 MHz
    RETURN

frequence8 
    CALL LED_2
     MOVLW b'00000011'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 8 MHz
    RETURN

frequence12 
    CALL LED_3
     MOVLW b'00000100'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 12 MHz
    RETURN
    
frequence16 
    CALL LED_4
     MOVLW b'00000101'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 16 MHz
    RETURN
    
    
frequence32
   CALL LED_5
     MOVLW b'00000110'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 32 MHz
    RETURN
    
frequence48 
    CALL LED_6
    MOVLW b'00000111'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 48 MHz
    RETURN

frequence64 
    CALL LED_7
    MOVLW b'00001000'
    MOVWF OSCFRQ ; Configurer la fréquence de l'oscillateur à 64 MHz
    RETURN
    END
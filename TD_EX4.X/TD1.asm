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

;*******************************************************************************
; Reset Vector
;*******************************************************************************
INCLUDE "p18f45k20.inc"


RES_VECT  CODE    0x0000            ; processor reset vector
;    GOTO    START                   ; go to beginning of program
; D�finition de l'espace de donn�es utilisateur pour les variables du groupe 1
groupl UDATA 0x100 
password RES 10   ; R�serve 10 emplacements m�moire pour 'password'

; D�finition de l'espace de donn�es utilisateur pour les variables du groupe 2
group2 UDATA 0x200
crypto RES 10   ; R�serve 10 emplacements m�moire pour 'crypto'
 
; D�but du code du programme principal
MAIN_PROG CODE

; S�lection de la banque 1 pour l'acc�s aux registres
MOVLW 0x01       ; Charge la valeur 1 dans l'accumulateur W
MOVWF BSR        ; D�place la valeur de l'accumulateur W vers le registre BSR pour s�lectionner la banque 1

; �criture de 'J' � l'adresse 'password'
MOVLW 'J'        ; Charge le caract�re 'J' dans l'accumulateur W
MOVWF password   ; �crit 'J' � l'adresse 'password'

; �criture de 'U' � l'adresse suivante
MOVLW 'U'        ; Charge le caract�re 'U' dans l'accumulateur W
MOVWF password+1 ; �crit 'U' � l'adresse suivant 'password'

; �criture de 'N' � l'adresse suivante
MOVLW 'N'        ; Charge le caract�re 'N' dans l'accumulateur W
MOVWF password+2 ; �crit 'N' � l'adresse suivant 'password+1'

; �criture de 'I' � l'adresse suivante
MOVLW 'I'        ; Charge le caract�re 'I' dans l'accumulateur W
MOVWF password+3 ; �crit 'I' � l'adresse suivant 'password+2'

; �criture de 'A' � l'adresse suivante
MOVLW 'A'        ; Charge le caract�re 'A' dans l'accumulateur W
MOVWF password+4 ; �crit 'A' � l'adresse suivant 'password+3'
 
; Cryptage du caract�re � l'adresse 'password'
MOVF password, W  ; D�place le contenu de 'password' dans l'accumulateur W
XORLW 0x55        ; Effectue une op�ration XOR entre le contenu de W et 0x55
MOVLB 0x02        ; S�lectionne la banque 2 pour l'acc�s aux registres
MOVWF crypto      ; �crit le r�sultat XOR � l'adresse 'crypto'

; Cryptage du caract�re suivant � l'adresse 'password+1'
MOVLB 0x01        ; S�lectionne la banque 1 pour l'acc�s aux registres
MOVF password+1, W ; D�place le contenu de 'password+1' dans l'accumulateur W
XORLW 0x55         ; Effectue une op�ration XOR entre le contenu de W et 0x55
MOVLB 0x02         ; S�lectionne la banque 2 pour l'acc�s aux registres
MOVWF crypto+1     ; �crit le r�sultat XOR � l'adresse 'crypto+1'
 
 ; Cryptage de 'U'
MOVLB 0x01
MOVF password+1, W
XORLW 0x55
MOVLB 0x02
MOVWF crypto+1

; Cryptage de 'N'
MOVLB 0x01
MOVF password+2, W
XORLW 0x55
MOVLB 0x02
MOVWF crypto+2

; Cryptage de 'I'
MOVLB 0x01
MOVF password+3, W
XORLW 0x55
MOVLB 0x02
MOVWF crypto+3

; Cryptage de 'A'
MOVLB 0x01
MOVF password+4, W
XORLW 0x55
MOVLB 0x02
MOVWF crypto+4

; Assurez-vous que la banque 2 est s�lectionn�e pour l'acc�s aux registres
MOVLB 0x02

; D�chiffrement de 'J' crypt�
MOVF crypto, W     ; D�place le contenu crypt� de 'crypto' dans l'accumulateur W
XORLW 0x55         ; Effectue un XOR sur le contenu de W avec 0x55, ce qui d�chiffre le caract�re
MOVWF password     ; Stocke le caract�re d�chiffr� � l'adresse 'password'

; R�p�tez le processus pour les autres caract�res
MOVF crypto+1, W
XORLW 0x55
MOVWF password+1

MOVF crypto+2, W
XORLW 0x55
MOVWF password+2

MOVF crypto+3, W
XORLW 0x55
MOVWF password+3

MOVF crypto+4, W
XORLW 0x55
MOVWF password+4


; D�finition de l'espace de donn�es utilisateur pour les variables de la banque 3
group3 UDATA 0x300
decrypte RES 10   ; R�serve 10 emplacements m�moire pour 'decrypte'

; Assurez-vous que la banque 2 est s�lectionn�e pour acc�der aux donn�es crypt�es
MOVLB 0x02

; D�chiffrement de 'J' crypt�
MOVF crypto,0,1    ; D�place le contenu crypt� de 'crypto' dans l'accumulateur W
XORLW 0x55         ; Effectue un XOR sur le contenu de W avec 0x55, ce qui d�chiffre le caract�re
MOVLB 0x03         ; Change vers la banque 3 pour l'acc�s aux registres
MOVWF decrypte     ; Stocke le caract�re d�chiffr� � l'adresse 'decrypte' dans la banque 3

; R�p�tez le processus pour les autres caract�res
MOVLB 0x02         ; S�lectionne � nouveau la banque 2 pour le caract�re suivant
MOVF crypto+1,0,1
XORLW 0x55
MOVLB 0x03
MOVWF decrypte+1   ; Stocke le caract�re suivant dans 'decrypte+1'

MOVLB 0x02
MOVF crypto+2,0,1
XORLW 0x55
MOVLB 0x03
MOVWF decrypte+2

MOVLB 0x02
MOVF crypto+3,0,1
XORLW 0x55
MOVLB 0x03
MOVWF decrypte+3

MOVLB 0x02
MOVF crypto+4,0,1
XORLW 0x55
MOVLB 0x03
MOVWF decrypte+4

;START

    ; TODO Step #5 - Insert Your Program Here

    ;MOVLW 0x55                      ; your instructions
    GOTO $                          ; loop forever

    END
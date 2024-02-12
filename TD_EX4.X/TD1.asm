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
; Définition de l'espace de données utilisateur pour les variables du groupe 1
groupl UDATA 0x100 
password RES 10   ; Réserve 10 emplacements mémoire pour 'password'

; Définition de l'espace de données utilisateur pour les variables du groupe 2
group2 UDATA 0x200
crypto RES 10   ; Réserve 10 emplacements mémoire pour 'crypto'
 
; Début du code du programme principal
MAIN_PROG CODE

; Sélection de la banque 1 pour l'accès aux registres
MOVLW 0x01       ; Charge la valeur 1 dans l'accumulateur W
MOVWF BSR        ; Déplace la valeur de l'accumulateur W vers le registre BSR pour sélectionner la banque 1

; Écriture de 'J' à l'adresse 'password'
MOVLW 'J'        ; Charge le caractère 'J' dans l'accumulateur W
MOVWF password   ; Écrit 'J' à l'adresse 'password'

; Écriture de 'U' à l'adresse suivante
MOVLW 'U'        ; Charge le caractère 'U' dans l'accumulateur W
MOVWF password+1 ; Écrit 'U' à l'adresse suivant 'password'

; Écriture de 'N' à l'adresse suivante
MOVLW 'N'        ; Charge le caractère 'N' dans l'accumulateur W
MOVWF password+2 ; Écrit 'N' à l'adresse suivant 'password+1'

; Écriture de 'I' à l'adresse suivante
MOVLW 'I'        ; Charge le caractère 'I' dans l'accumulateur W
MOVWF password+3 ; Écrit 'I' à l'adresse suivant 'password+2'

; Écriture de 'A' à l'adresse suivante
MOVLW 'A'        ; Charge le caractère 'A' dans l'accumulateur W
MOVWF password+4 ; Écrit 'A' à l'adresse suivant 'password+3'
 
; Cryptage du caractère à l'adresse 'password'
MOVF password, W  ; Déplace le contenu de 'password' dans l'accumulateur W
XORLW 0x55        ; Effectue une opération XOR entre le contenu de W et 0x55
MOVLB 0x02        ; Sélectionne la banque 2 pour l'accès aux registres
MOVWF crypto      ; Écrit le résultat XOR à l'adresse 'crypto'

; Cryptage du caractère suivant à l'adresse 'password+1'
MOVLB 0x01        ; Sélectionne la banque 1 pour l'accès aux registres
MOVF password+1, W ; Déplace le contenu de 'password+1' dans l'accumulateur W
XORLW 0x55         ; Effectue une opération XOR entre le contenu de W et 0x55
MOVLB 0x02         ; Sélectionne la banque 2 pour l'accès aux registres
MOVWF crypto+1     ; Écrit le résultat XOR à l'adresse 'crypto+1'
 
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

; Assurez-vous que la banque 2 est sélectionnée pour l'accès aux registres
MOVLB 0x02

; Déchiffrement de 'J' crypté
MOVF crypto, W     ; Déplace le contenu crypté de 'crypto' dans l'accumulateur W
XORLW 0x55         ; Effectue un XOR sur le contenu de W avec 0x55, ce qui déchiffre le caractère
MOVWF password     ; Stocke le caractère déchiffré à l'adresse 'password'

; Répétez le processus pour les autres caractères
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


; Définition de l'espace de données utilisateur pour les variables de la banque 3
group3 UDATA 0x300
decrypte RES 10   ; Réserve 10 emplacements mémoire pour 'decrypte'

; Assurez-vous que la banque 2 est sélectionnée pour accéder aux données cryptées
MOVLB 0x02

; Déchiffrement de 'J' crypté
MOVF crypto,0,1    ; Déplace le contenu crypté de 'crypto' dans l'accumulateur W
XORLW 0x55         ; Effectue un XOR sur le contenu de W avec 0x55, ce qui déchiffre le caractère
MOVLB 0x03         ; Change vers la banque 3 pour l'accès aux registres
MOVWF decrypte     ; Stocke le caractère déchiffré à l'adresse 'decrypte' dans la banque 3

; Répétez le processus pour les autres caractères
MOVLB 0x02         ; Sélectionne à nouveau la banque 2 pour le caractère suivant
MOVF crypto+1,0,1
XORLW 0x55
MOVLB 0x03
MOVWF decrypte+1   ; Stocke le caractère suivant dans 'decrypte+1'

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
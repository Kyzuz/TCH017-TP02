;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et dÃ©cryptage avec les gÃ©nÃ©rateurs pseudo-alÃ©atoires ---
;---------------------------------------------------------------------
         BR      Main 

;Variables globales
coefA:   .WORD 0             ;Coefficient A
coefC:   .WORD 0             ;Coefficient C
terme:   .WORD 0             ;Terme

;Registre
regs:    .EQUATE 4           ;taille des registres
regA:    .EQUATE -2          ;pos. rel. du registre dans la fonction
regX:    .EQUATE -4          ;pos. rel. du registre dans la fonction

;--------------------------------------------------------------------            
;FONCTION : Main (prefixe 8)
;--------------------------------------------------------------------
;Nommage des variables du Main :
;xxxx_X : X = préfixe appelé, xxxx = type de variable
  
tabTai:  .EQUATE 256         ;taille de tous les tableaux
strMax:  .EQUATE 25
msgCla:  .EQUATE 0           ;dÃ©but de la zone/tab du message clair
msgChi:  .EQUATE 256         ;dÃ©but de la zone/tab du message chiffrÃ©
msgDec:  .EQUATE 512         ;dÃ©but de la zone/tab du message dÃ©chiffrÃ©

;ParamÃ¨tres de : InitGen(1)--
arg1_1: .EQUATE 12           ;pos. rel. de (a) DANS Main
arg2_1: .EQUATE 10           ;pos. rel. de (c) DANS Main
arg3_1: .EQUATE 8            ;pos. rel. de (terme) DANS Main

;ParamÃ¨tres de : GenVal(2)---               
res1_2: .EQUATE -2           ;pos. rel. de val. ret. DANS Main

;ParamÃ¨tres de : GenCle(3)---
args_3: .EQUATE 4            ;taille des arguments de GenCle
arg1_3: .EQUATE -2000        ;pos. rel. de l'adr. de clé
arg2_3: .EQUATE -2200        ;pos. rel. de la taile de clé

;ParamÃ¨tres de : Xor16(4)----
arg1_4:  .EQUATE 12
arg2_4:  .EQUATE 14
res1_4:  .EQUATE -2

;Paramètres de : Chiff(5)----

;Paramètres de : Dechiff(6)--

;Paramètres de : AffMsg(7)---


;--------------------------------------------------------
Main:    STRO    m_init,d    ;printf("Message original\n") 
         LDX     0,i         ;X = 0

str_inpt:CHARI   -1,s
         LDBYTEA -1,s
         ANDA    0x00FF,i    ;masque sur octet fort

         CPA     10,i        ;if (input == '10' == LF){
         BREQ    e_strin          

         CPX     strMax,i    ;elseif (X == 256 == strMax)
         BREQ    e_strin
         
         STBYTEA msgCla,sxf  ;else msgCla[X] = CHARI
         ADDX    1,i         ;X++
         BR      str_inpt,i  ;}

e_strin: LDBYTEA 0,i         ;dernier octet = '\x00' 
         STBYTEA msgCla,sxf
         CHARO   "\n",i
;------------------------------------------------------
         STRO    m_carGen,d  ;printf("Caractéristiques du générateur\n") 
         STRO    m_coefA,d   ;récupération du coefficient a
         DECI    arg1_1,s   

         STRO    m_coefC, d  ;récupération du coefficient c
         DECI    arg2_1,s

         STRO    m_grain,d   ;récupération de la graine/terme
         DECI    arg3_1,s


         ;--- Appel de InitGen (1) ---
         STA     arg1_1,s    ;placement des arguments dans la pile
         STA     arg2_1,s
         STA     arg3_1,s  
 
         SUBSP   prms_1,i    ;allocation des arguments
         CALL    InitGen,i
         ADDSP   prms_1,i    ;libération arguments
         ;--------- Fin appel --------



         BR      F_PEP8,i


;---------------------------------------------------------------------
;FONCTION : InitGen (prefixe 1)
;SpÃ©cifie les caractÃ©ristiques du gÃ©nÃ©rateur et la graine Ã  utiliser
;RÃ©cupÃ¨re et place les caractÃ©ristiques du gÃ©nÃ©rateur sur la pile
prms_1:  .EQUATE 6
prm1_1:  .EQUATE -2          ;a       
prm2_1:  .EQUATE -4          ;c
prm3_1:  .EQUATE -6          ;graine

InitGen: STA     regA,s      ;Allocation registre
         STX     regX,s
         SUBSP   regs,i
         ;-----------------
         LDA     prm1_1,s    ;placement sur la pile de a
         STA     coefA,d

         LDA     prm2_1,s    ;placement sur la pile de c
         STA     coefC,d

         LDA     prm3_1,s    ;placement sur la pile de la graine/terme
         STA     terme,d
         ;-----------------
         ADDSP   regs,i      ;LibÃ©ration registre
         LDX     regX,s
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
;FONCTION : GenVal (prefix 2)
;Produit la prochaine valeur du générateur et la retourne
;Générateur utilisée : LCG

;Variables locales ----------
locs_2:  .EQUATE 4           ;taille des variables locales 
loc1_2:  .EQUATE 0           ;var. locale (a) dans la fonction
loc2_2:  .EQUATE 2           ;résultat de multiplication (a*Un)

;Variables de retour --------
rets_2:  .EQUATE 2           ;taille de la variable de retour
ret1_2:  .EQUATE 10          ;pos. rel. de la var. de ret. dans la fonction

GenVal:  STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_2,i
         ;-------------------
         LDA     0,i         ;a*Un = 0              
         STA     loc2_2,s

         LDA     coefA,d     ;compteur = a 
         STA     loc1_2,s

whi_2:   LDA     loc1_2,s    ;while cpt > 0 {
         CPA     0,i

         BREQ    eow_2            ;break 

         LDA     loc2_2,s         ;r_multi += terme
         ADDA    terme,d
         STA     loc2_2,s

         LDA     loc1_2,s         ;cpt--
         SUBA    1,i
         STA     loc1_2,s    ;}

         BR      whi_2       
        
eow_2:   LDA     loc2_2,s    ;a*Un += c
         ADDA    coefC,d 
         STA     ret1_2,s    ;valeur de retour = a*Un + c
         ;-------------------
         ADDSP   locs_2,i
         ADDSP   regs,i 
         LDX     regX,s         
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
;FONCTION : GenCle (prefix 3)
;Génère N valeurs pseudo-aléatoires et les places dans un tableau

;Paramètres -------------------
prms_3:  .EQUATE 4
prm1_3:  .EQUATE -2
prm2_3:  .EQUATE -4


locs_3:  .EQUATE 2
loc1_3:  .EQUATE 0
rets_3:  .EQUATE 2
res1_3:  .EQUATE -2

GenCle:  STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   p_locs,i 
         ;-----boucle-----------

         ;---- Call GenVal -----
         SUBSP   rets_3,i
         ;----------------------

         CALL    GenVal,i

         

         LDA     res1_3,s    ;récupère 
         STA     terme,d
         ;----------------------



         ADDSP   rets_3,i
         ;----- Fin GenVal -----
         ;----------------------
         ADDSP   p_locs,i
         LDX     regX,s
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
;FONCTION : Xor16 (prefix 4)  
;Effectue un XOR entre les deux valeurs 16 bits passées en paramètre
;et retourne le résultat. 
prms_4:  .EQUATE 4           ;taille des paramètres/arguments
prm1_4:  .EQUATE 12          ;pos. rel. de la première valeur (a=msg clair)     
prm2_4:  .EQUATE 14          ;pos. rel. de la deuxième valeur (b=clé) 

locs_4:  .EQUATE 6           ;taille des variables locales
loc1_4:  .EQUATE 0           ;OR
loc2_4:  .EQUATE 2           ;AND
loc3_4:  .EQUATE 4           ;NOT

rets_4:  .EQUATE 2           ;taille de la variable de retour
ret1_4:  .EQUATE 16          ;pos. rel. de la var. de ret. dans la fonction

Xor16:   STA     regA,s
         STA     regX,s
         SUBSP   regs,i
         SUBSP   locs_4,i
         ;-------------------

         LDA     prm1_4,s
         ORA     prm2_4,s
         STA     loc1_4,s

         LDA     prm1_4,s
         ANDA    prm2_4,s
         STA     loc2_4,s

         LDA     loc2_4,s
         NOTA
         STA     loc3_4,s

         LDA     loc3_4,s
         ANDA    loc1_4,s   
         STA     ret1_4,s
       
         ;-------------------
         ADDSP   locs_4,i
         ADDSP   regs,i
         LDA     regA,s
         LDX     regX,s
         RET0

;---------------------------------------------------------------------
;FONCTION: Chiff (prefix 5)



;----------------------------------------------------------------------
;FONCTION: Dechiff (prefix 6)


;---------------------------------------------------------------------
;FONCTION: AffMsg (prefix 7)
;zone parametres
prms_7:  .EQUATE 6
;ZONE variable locale
locs_7:  .EQUATE 2

;parametres/variables
prm1_7:  .EQUATE 12          ; addresse du tab
prm2_7:  .EQUATE 10          ; taille du tab
prm3_7:  .EQUATE 8           ; affichage ASCII ou caracteres(-1)
loc1_7:  .EQUATE 0           ; compteur

AffMsg:  STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_7,i

;----------------------------------
         LDA     prm3_7,s    ;affichage caractere ou ASCII
         CPA     -1,i        ;if(prm3_7 != -1){
         BREQ    aff_car,i
         LDA     0,i
         STA     loc1_7,s

affASCII:LDX     loc1_7,s    ;    for(int i=0; i<prm2_7; i++){
         CPX     prm2_7,s
         BREQ    f_AffMsg,i

         LDBYTEA prm1_7,sxf  ;        printf("%d", (int*)msg[i])
         ANDA    0x00FF,i
         STA     -2,s
         DECO    -2,s
         CHARO   ' ',i       ;        printf(" ")

         ADDX    1,i
         STX     loc1_7,s
         BR      affASCII,i  ;    }
                    

aff_car:STRO     prm1_7      ;else{
                             ;    printf("%s",prm1_7)}
f_AffMsg:CHARO   '\n',i      ;printf("\n")

;-----------------------------------

         ADDSP   locs_7,i
         ADDSP   regs,i
         LDX     regX,s
         LDA     regA,s

         RET0

;---------------------------------------------------------------------
;Message Ã  l'utilisateur (variables globales)
m_init:  .ASCII  "Message original : \x00" 
m_carGen:.ASCII  "Caractéristiques du gÃ©nÃ©rateur LCG : \x00"   
m_coefA: .ASCII  "Coeff. a : \x00"
m_coefC: .ASCII  "Coeff. c : \x00"
m_grain: .ASCII  "Graine : \x00"
m_tCle:  .ASCII  "Taille de la clé : \x00"
m_chi:   .ASCII  "Message chiffrée : \x00"
m_dchi:  .ASCII  "Message déchiffré : \x00"
m_errmsg:.ASCII  "Votre message est trop long \x00"

F_PEP8:  STOP
         .END




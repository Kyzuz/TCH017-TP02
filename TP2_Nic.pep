;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et décryptage avec les générateurs pseudo-aléatoires ---
;---------------------------------------------------------------------
         BR      Main 
;-------------------------   ARGUMENTS   -----------------------------
;Nommage des variables
;xxxx_X : X = prefixe de l'appele, xxxx = type de variable

;ARGUMENTS = Position relative des arguments DANS l'appelant
;PARAMETES = Position relative des parametres DANS l'appelé

;Termes de : InitGen(1)--
args_1: .EQUATE 6
arg1_1: .EQUATE -2           ;pos. rel. de (a)
arg2_1: .EQUATE -4           ;pos. rel. de (c)
arg3_1: .EQUATE -6           ;pos. rel. de (terme)

;Termes de : GenVal(2)---               
res1_2: .EQUATE -2           ;pos. rel. de val. ret.

;Termes de : GenCle(3)---
args_3: .EQUATE 4            ;taille des arguments de GenCle
arg1_3: .EQUATE -2           ;pos. rel. de l'adr. de clé 
arg2_3: .EQUATE -4           ;pos. rel. de la taile de clé

;Termes de : Xor16(4)----
args_4:  .EQUATE 4
arg1_4:  .EQUATE -4
arg2_4:  .EQUATE -6

res1_4:  .EQUATE -2

;Termes de : Chiff(5)----
args_5:  .EQUATE 12
arg1_5:  .EQUATE -4
arg2_5:  .EQUATE -6
arg3_5:  .EQUATE -8
arg4_5:  .EQUATE -10
arg5_5:  .EQUATE -12
arg6_5:  .EQUATE -14

res1_5:  .EQUATE -2

;Termes de : Dechiff(6)--
args_6:  .EQUATE 14
arg1_6:  .EQUATE -2
arg2_6:  .EQUATE -4
arg3_6:  .EQUATE -6
arg4_6:  .EQUATE -8
arg5_6:  .EQUATE -10
arg6_6:  .EQUATE -12
arg7_6:  .EQUATE -14

;Termes de : AffMsg(7)---
args_7:  .EQUATE 6
arg1_7:  .EQUATE -2
arg2_7:  .EQUATE -4
arg3_7:  .EQUATE -6




;--------------------------------------------------------------------            
;FONCTION : Main (prefixe 8)
;--------------------------------------------------------------------
   
tabTai:  .EQUATE 256         ;taille de chaque les tableaux
strMax:  .EQUATE 255         ;taille max d'un message [0,255]
msgCla:  .EQUATE 768         ;debut de la zone/tab du message clair
msgChi:  .EQUATE 512         ;debut de la zone/tab du message chiffre
msgDec:  .EQUATE 256         ;debut de la zone/tab du message dechiffre

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

;---variables locales-----

;-------------------------------------------------------------------- 
Main:    SUBSP   tabTai,i    ;allocation du tab du message clair
         SUBSP   tabTai,i    ;allocation du tab du message chiffre
         SUBSP   tabTai,i    ;allocation du tab du message dechiffre
         ;---------------


         ;---------  Lecture du message original  --------
         STRO    m_init,d    ;printf("Message original\n") 
         LDX     0,i         ;X = 0

str_inpt:CHARI   -1,s        ;for (int i=0;i<strMax, i++) {
         LDBYTEA -1,s        ;    scanf("%c",msgCla[x])
         ANDA    0x00FF,i    ;    masque sur octet fort

         CPA     10,i        ;    if (input == '10' (LF)){
         BREQ    e_strin     ;        goto e_strin     

         CPX     strMax,i    ;    elseif (X == 256 == strMax)
         BREQ    e_strin     ;        goto e_strin
         
         STBYTEA msgCla,sxf  ;    else (msgCla[X] = CHARI)
         ADDX    1,i         ;    X++
         BR      str_inpt,i  ;}

e_strin: LDBYTEA 0,i         ;msgCla[255] = '\x00' 
         STBYTEA msgCla,sxf
         CHARO   "\n",i

         ;--- Lecture caracteristique/graine/taille de la cle -------
         STRO    m_carGen,d  ;printf("Caractéristiques du générateur\n") 
         STRO    m_coefA,d   ;recuperation du coefficient a
         DECI    arg1_1,s   

         STRO    m_coefC, d  ;recuperation du coefficient c
         DECI    arg2_1,s

         STRO    m_grain,d   ;recuperation de la graine/terme
         DECI    arg3_1,s
         ;-----------------  Fin lecture usager  --------------------


         ;----chiffrer le message---------
         ;--- Appel de Chiff (6) ---
;placement des arguments dans la pile
         ;LDA     







         


         BR      F_PEP8,i    ;Fin programme
;---------------------------------------------------------------------
;FONCTION : InitGen (prefixe 1)
;Spécifie les caractéristiques du générateur et la graine à utiliser
;Récupère et place les caractéristiques du générateur sur la pile

;Paramètres -----------------
prms_1:  .EQUATE 6
prm1_1:  .EQUATE 12          ;a       
prm2_1:  .EQUATE 10          ;c
prm3_1:  .EQUATE 8           ;graine

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
         ADDSP   regs,i      ;Libération registre
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
ret1_2:  .EQUATE 10          ;prochaine valeur généré

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
;GenCle appel GenVal

;Paramètres ------------------
prms_3:  .EQUATE 4           ;taille des paramètres
prm1_3:  .EQUATE 14          ;adresse du début de la clé
prm2_3:  .EQUATE 12          ;taille N de la clé
                             
;Variables locales -----------
locs_3:  .EQUATE 6           ;taille des variables locales
loc1_3:  .EQUATE 0           ;prochaine val. gen
;loc2_3:  .EQUATE 2           ;compteur général
loc3_3:  .EQUATE 4           ;compteur clé

GenCle:  STA     regA,s      ;préparation de GenVal
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_3,i 
         ;--------------------
         LDX     0,i
         ;STX     loc2_3,s    ;compteur clé = 0 
         STX     loc3_3,s    ;compteur général = 0
         
for_3:   LDX     loc2_3,s    ;while (compteur clé < taile clé) { ;ERROR: Symbol loc2_3 is used but not defined.
         CPX     prm2_3,i
         BREQ    eof_3,i          ;goto 3_eof

 
         ;------------------- Call GenVal ---------------------------
         SUBSP   rets_2,i    ;taille var. ret. GenVal
         ;--------------------
         CALL    GenVal,i

         LDA     loc1_3,s    ;récupère la valeur généré
         STA     prm1_3,sxf  ;clé[x] = valeur généré
         ;--------------------
         ADDSP   rets_2,i
         ;-------------------- Fin GenVal ---------------------------
         LDX     loc2_3,s    ;compteur clé++
         ADDX    1,i
         STX     loc2_3,s

         BR      for_3,i
         ;--------------------
eof_3:   ADDSP   locs_3,i    ;sortie GenVal
         ADDSP   regs,i
         LDX     regX,s
         LDA     regA,s
         RET0                ;return
;---------------------------------------------------------------------
;FONCTION : Xor16 (prefix 4)  
;Effectue un XOR entre les deux valeurs 16 bits pass?es en param?tre
;et retourne le résultat. 
prms_4:  .EQUATE 4           ;taille des parametres/arguments
prm1_4:  .EQUATE 12          ;pos. rel. de la première valeur (a=msg clair)     
prm2_4:  .EQUATE 14          ;pos. rel. de la deuxième valeur (b=clé) 

locs_4:  .EQUATE 6           ;taille des variables locales
loc1_4:  .EQUATE 0           ;OR
loc2_4:  .EQUATE 2           ;AND
loc3_4:  .EQUATE 4           ;NOT

rets_4:  .EQUATE 2           ;taille de la variable de retour
ret1_4:  .EQUATE 16          ;pos. rel. de la var. de ret. dans la fonction

Xor16:   STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_4,i
         ;-------------------
         LDA     prm1_4,s    ; OR = a || b
         ORA     prm2_4,s
         STA     loc1_4,s

         LDA     prm1_4,s    ; AND = a && b
         ANDA    prm2_4,s
         STA     loc2_4,s

         LDA     loc2_4,s    ; NOT = ~AND
         NOTA
         STA     loc3_4,s

         LDA     loc3_4,s    ; return XOR = NOT && OR
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

;Parametres de Chiff
prms_5:  .EQUATE 12
prm1_5:  .EQUATE 278         ;addresse du message clair
prm2_5:  .EQUATE 276         ;a
prm3_5:  .EQUATE 274         ;c
prm4_5:  .EQUATE 272         ;graine
prm5_5:  .EQUATE 270         ;taille N de la cle
prm6_5:  .EQUATE 268         ;addresse ou placer le message chiffre

;Variables locales
locs_5:  .EQUATE 260
loc1_5:  .EQUATE 260         ;compteur general (longueur du message)
loc2_5:  .EQUATE 258         ;compteur de la taille de la cle
loc3_5:  .EQUATE 256         ;debut tab de la cle

;Valeurs de retour
rets_5:  .EQUATE 2
ret1_5:  .EQUATE 280         ;longueur du message


Chiff:   STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_5,i
         ;------------------ 

         ;--- Appel de InitGen (1) ---
;placement des arguments dans la pile
         LDA     prm2_5,s    ;InitGen( a, c, graine);
         STA     arg1_1,s
         LDA     prm3_5,s    
         STA     arg2_1,s
         LDA     prm4_5,s
         STA     arg3_1,s  
 
         SUBSP   prms_1,i    ;allocation des arguments
         CALL    InitGen,i
         ADDSP   prms_1,i    ;liberation arguments
         ;--------- Fin appel --------


         ;--- Appel de GenCle (3) ---
;placement des arguments dans la pile
         LDA     loc3_5,s    ;GenCle( *tab_cle, taille_N);
         STA     arg1_3,s
         LDA     prm5_5,s    
         STA     arg2_3,s  
 
         SUBSP   prms_3,i    ;allocation des arguments

         CALL    InitGen,i

         ADDSP   prms_3,i    ;liberation arguments
         ;--------- Fin appel --------



bou_chi: LDX     0,i
         STX     loc1_5,s    ;int cmpt_gen, cmpt_cle =0;
         STX     loc2_5,s

         LDX     loc1_5,s    ;while (msgCla[cmpt_gen] != 'x\00')
         LDBYTEA prm1_5,sxf
         ANDA    0x00FF,i

         BREQ    fin_chi,i

         LDX     loc2_5,s    ;    if( cmpt_cle < taille_N ){
         CPX     prm5_5,i
         BREQ    fin_cle,i

deb_XOR: LDX     loc2_5,s 
                             ;        msgChi[cmpt_gen] = msgCla[cmpt_gen] ^ tabcle[cmpt_cle];
         ;----Appel Xor16 (4)------
         LDA     prm1_5,s 
         STA     arg1_4,s
         STX     arg2_4,s

         SUBSP   rets_4,i
         SUBSP   prms_4,i
         CALL    Xor16,i
         ADDSP   prms_4,i
         ADDSP   rets_4,i

         ;----Fin appel Xor16----

         LDX     loc1_5,s
         LDA     res1_4,s        ;retour de xor
         ANDA    0x00FF,i 
         STBYTEA prm6_5,sxf

         ADDX    1,i         ;        cmpt_gen ++;
         STX     loc1_5,s

         LDX     loc2_5,s    ;        cmpt_cle ++;
         ADDX    1,i
         STX     loc2_5,s    ;    

         BR      bou_chi,i   ; 

fin_cle: LDX     0,i         ;    }else{
         STX     loc2_5,s    ;        cmpt_cle = 0; }
         BR      deb_XOR,i

fin_chi: LDA     loc1_5,s
         STA     ret1_5,s    ; return lng_msg = cmpt_gen;

         ;-----------------
         ADDSP   locs_5,i
         ADDSP   regs,i
         LDA     regA,s
         LDX     regX,s
         RET0

;----------------------------------------------------------------------
;FONCTION: Dechiff (prefix 6)

;Parametres de Dechiff
prms_6:  .EQUATE 14
prm1_6:  .EQUATE 280         ;addresse du message chiffre
prm2_6:  .EQUATE 278         ;taille du message chiffre
prm3_6:  .EQUATE 276         ;a
prm4_6:  .EQUATE 274         ;c
prm5_6:  .EQUATE 272         ;graine
prm6_6:  .EQUATE 270         ;taille N de la cle
prm7_6:  .EQUATE 268         ;addresse du message dechiffre

;Variables locales
locs_6:  .EQUATE 260
loc1_6:  .EQUATE 260         ;compteur general (longueur du message)
loc2_6:  .EQUATE 258         ;compteur de la taille de la cle
loc3_6:  .EQUATE 256         ;debut tab de la cle


Dechiff: STA     regA,s
         STX     regX,s
         SUBSP   regs,i
         SUBSP   locs_5,i
         ;------------------ 

         ;--- Appel de InitGen (1) ---
;placement des arguments dans la pile
         LDA     prm3_6,s    ;InitGen( a, c, graine);
         STA     arg1_1,s
         LDA     prm4_6,s    
         STA     arg2_1,s
         LDA     prm5_6,s
         STA     arg3_1,s  
 
         SUBSP   prms_1,i    ;allocation des arguments
         CALL    InitGen,i
         ADDSP   prms_1,i    ;liberation arguments
         ;--------- Fin appel --------


         ;--- Appel de GenCle (3) ---
;placement des arguments dans la pile
         LDA     loc3_6,s    ;GenCle( *tab_cle, taille_N);
         STA     arg1_3,s
         LDA     prm6_6,s    
         STA     arg2_3,s  
 
         SUBSP   prms_3,i    ;allocation des arguments

         CALL    InitGen,i

         ADDSP   prms_3,i    ;liberation arguments
         ;--------- Fin appel --------



bou_dec: LDX     0,i
         STX     loc1_6,s    ;int cmpt_gen, cmpt_cle =0;
         STX     loc2_6,s

         LDX     loc1_6,s    ;for(cmpt_gen = 0; cmpt_gen <= lng_msg; cmpt_gen ++){
         CPX     prm2_6,s
         BREQ    fin_dec,i

         LDX     loc2_6,s    ;    if( cmpt_cle < taille_N ){
         CPX     prm6_6,i
         BREQ    fincle_6,i

debXOR_6:LDX     loc2_6,s 
                             ;        msgDec[cmpt_gen] = msgChi[cmpt_gen] ^ tabcle[cmpt_cle];
         ;----Appel Xor16 (4)------
         LDA     prm1_6,s
         STA     arg1_4,s
         STX     arg2_4,s

         SUBSP   rets_4,i
         SUBSP   prms_4,i
         CALL    Xor16,i
         ADDSP   prms_4,i
         ADDSP   rets_4,i

         ;----Fin appel Xor16----

         LDX     loc1_6,s
         LDA     res1_4,s        ;retour de xor
         ANDA    0x00FF,i 
         STBYTEA prm7_6,sxf

         ADDX    1,i         ;        cmpt_gen ++;
         STX     loc1_6,s

         LDX     loc2_6,s    ;        cmpt_cle ++;
         ADDX    1,i
         STX     loc2_6,s    ;    

         BR      bou_dec,i   ; 

fincle_6:LDX     0,i         ;    }else{ 
         STX     loc2_6,s    ;        cmpt_cle = 0; }
         BR      debXOR_6,i


         ;---------------
fin_dec: ADDSP   locs_6,i
         ADDSP   regs,i
         LDA     regA,s
         LDX     regX,s
         RET0


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
         CPA     -1,i        ;if( aff != -1){
         BREQ    aff_car,i
         LDA     0,i
         STA     loc1_7,s

affASCII:LDX     loc1_7,s    ;    for(int i=0; i< taille_msg; i++){
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
                    

aff_car:STRO     prm1_7,sf   ;else{ 
                             ;    printf("%s",str_msg)}
f_AffMsg:CHARO   '\n',i      ;printf("\n")

;-----------------------------------

         ADDSP   locs_7,i
         ADDSP   regs,i
         LDX     regX,s
         LDA     regA,s

         RET0

;---------------------------------------------------------------------
;Message a  l'utilisateur (variables globales)
m_init:  .ASCII  "Message original : \x00" 
m_carGen:.ASCII  "Caracteristiques du generateur LCG : \x00"   
m_coefA: .ASCII  "Coeff. a : \x00"
m_coefC: .ASCII  "Coeff. c : \x00"
m_grain: .ASCII  "Graine : \x00"
m_tCle:  .ASCII  "Taille de la cle : \x00"
m_chi:   .ASCII  "Message chiffre : \x00"
m_dchi:  .ASCII  "Message dechiffre : \x00"

F_PEP8:  STOP
         .END



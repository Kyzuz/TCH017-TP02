;----------------------    TCH017 - TP02    --------------------------
;--- Cryptage et décryptage avec les générateurs pseudo-aléatoires ---
;---------------------------------------------------------------------
         BR      main

;Message à l'utilisateur (variables globales)
m_init:  "Message original : \x00"
m_carGen:"Caractéristiques du générateur LCG : \x00"   
m_coefA:"Coeff. a : \x00"
m_coefC:"Coeff. c : \x00"
m_grain:"Graine : \x00"
m_tCle: "Taille de la clé : \x00"
m_chi:  "Message chiffré : \x00"
m_dchi: "Message déchiffré : \x00"
             

;---------------------------------------------------------------------
InitGen: 






;---------------------------------------------------------------------
GenVal:  
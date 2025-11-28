         BR      main,i
;------------------------------------

m_try:   .ASCII  "Est-ce que je peut le voir sur GitHub?\x00"


;------------------------------------

main:    STRO    m_try,d

         STOP


.END
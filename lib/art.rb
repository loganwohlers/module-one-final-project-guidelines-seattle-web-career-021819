module Art

  def self.greeting_message
    puts <<~GREETING_MESSAGE


      FFFFF   II   NN    NN   DDD        TTTTTTTT   HH  HH       AA     TTTTTTTT
      FF      II   NNN   NN   DD  DD        TT      HH  HH     AA  AA      TT
      FFFFF   II   NN N  NN   DD   D        TT      HHHHHH    AAAAAAAA     TT
      FF      II   NN  N NN   DD  DD        TT      HH  HH    AA    AA     TT
      FF      II   NN   NNN   DDD           TT      HH  HH   AA      AA    TT


                      PPPPP      AA       RRRRR     KK   KK
                      PP   P   AA  AA     RR   R    KK  KK
                      PPPPP   AAAAAAAA    RRRRR     KKK
                      PP      AA    AA    RR  RR    KK  KK
                      PP     AA      AA   RR   RR   KK   KK


              Powered by Data From the National Parks Service API

                CCC                            0000
                CCC  CC                       000000            CCC
                CCC  CC                        0000          C  CCC  C
             C  CCCCC                                         CCCCCCC
              C CCC                C  C                         CCC
                CCC                 CC                          CCC
      ----------CCC-----------------CC--------------------------CCC-------------




    GREETING_MESSAGE
  end

  def self.goodbye_message
    puts <<~GOODBYE_MESSAGE


        GGGGG      OOO       OOO     DDD      BBB    YY     YY   EEEEE
       GG        OO   OO   OO   OO   DD  DD   BB  BB   YY  YY    EE
       GG  GGG   OO   OO   OO   OO   DD   D   BBB        YY      EEEEE
       GG    G   OO   OO   OO   OO   DD  DD   BB  BB     YY      EE
        GGGG       000       OOO     DDD      BBB        YY      EEEEE


                             Please Come Again

                  And Get More Ideas For Your next Adventure,

          OOOO             The World is Waiting!
         OOOOOO
          OOOO


              CCC
              CCC  CC                                         CCC
              CCC  CC                                      C  CCC  C
           C  CCCCC                                         CCCCCCC
            C CCC                C  C                         CCC
              CCC                 CC                          CCC
    ----------CCC-----------------CC--------------------------CCC-------------

    GOODBYE_MESSAGE
  end

  def self.mountain_art
    puts <<-MOUNTAIN_ART

                VVVVVV                      0000               V
              V        V        V          000000            V   V
             V          V     V   V         0000            V     V
            V             V  V     V                       V       V
           V               V        V                     V         V
          V                 V        V                   V           V

    MOUNTAIN_ART
  end
end

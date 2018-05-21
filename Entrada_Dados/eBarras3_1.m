%lEITURA BARRAS - FLUXO DE POT�NCIA - INICIALIZA��O FLAT START

%  Revis�es:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA   

function eBarras3_1

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tens�o        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2        1               0         -0.90       -0.30       3
                3        1               0         -0.60       -0.20       3
         ];
     
global Linhas
%LinhasValores     BarraOrigem    BarraDestino         Resist�ncia         Reat�ncia 
Linhas = [              1               2                  0.018             0.035
                        1               3                  0.013             0.027
                        2               3                  0.009             0.018
         ];

end
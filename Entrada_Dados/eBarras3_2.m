%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA   

function eBarras3_2

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2        0.98            0        -0.15          0         2
                3        1               0        -0.05        -0.02       3
         ];
     
global Linhas
%LinhasValores     BarraOrigem    BarraDestino         Resistência         Reatância 
Linhas = [              1               2                  0.20                2
                        1               3                  0.10                1
                        2               3                  0.10                1
         ];

end
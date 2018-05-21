%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA   

function eBarras5

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1.06            0          0            0         1
                2        1.06            0          0            0         2
                3        1               0        -0.2         -0.05       3
                4        1               0        -0.2         -0.05       3
                5        1               0        -0.35        -0.07       3
         ];
     
global Linhas
%LinhasValores     BarraOrigem    BarraDestino         Resistência       Reatância 
Linhas = [              1               3                  0                0.1
                        3               2                  0                0.1
                        3               5                  0.10              1
                        2               4                  0.10              1
                        4               5                  0.10              1
         ];

end
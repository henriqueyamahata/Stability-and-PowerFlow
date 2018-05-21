%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA       

function Barras4

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2       1.02             0         3.18          0         2
                3        1               0        -1.7         -1.05       3
                4        1               0         -2          -1.23       3

         ];

%LinhasValores     BarraOrigem    BarraDestino         Resistência         Reatância 
global Linhas
Linhas = [              1               3                0.01008             0.05040
                        1               4                0.00744             0.03720
                        2               3                0.00744             0.03720
                        2               4                0.01272             0.06360
         ];
end
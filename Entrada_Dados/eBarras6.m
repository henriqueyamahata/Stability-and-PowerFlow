%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA   

function eBarras6

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2        1               0        -0.2           0         2
                3        1               0        -0.3         -0.10       3
                4        1               0        -0.15        -0.05       3
                5        1               0        -0.1         -0.10       3
                6        1               0        -0.1         -0.05       3
       ];
     
global Linhas
%LinhasValores     BarraOrigem    BarraDestino         Resistência       Reatância 
Linhas = [              1               4                  0.10             0.5
                        1               3                  0.10             0.5
                        4               2                  0.10             0.5
                        4               5                  0.10             0.5
                        3               5                  0.10             0.5
                        3               6                  0.10             0.5
                        4               5                  0.10             0.5
                        5               6                  0.10             0.5
         ];

end
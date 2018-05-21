%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA   

function eBarras3_0

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2        1               0         0.8           0         2
                3        1               0         -2          -0.75       3
         ];
     
global Linhas
%LinhasValores     BarraOrigem    BarraDestino         Resistência         Reatância 
Linhas = [              1               2                  0.01                0.1
                        1               3                  0.01                0.1
                        2               3                  0.01                0.1
         ];

end
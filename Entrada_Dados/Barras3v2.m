%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA          

function Barras3v2

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1.025           0          0            0         1
                2        1.03            0          3            0         2
                3        1               0         -4           -2         3
         ];

%LinhasValores     BarraOrigem    BarraDestino         Resistência         Reatância 
global Linhas
Linhas = [              1               2                   0                0.025
                        1               3                   0                0.05
                        2               3                   0                0.025
         ];

end
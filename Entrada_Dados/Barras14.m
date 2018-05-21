%lEITURA BARRAS - FLUXO DE POTÊNCIA - INICIALIZAÇÃO FLAT START
%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA                

function Barras14

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tensão        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0        1
                2        1.04            0          1            0        2
                3        1.07            0          1            0        2
                4        1.03            0          1            0        2
                5        1.06            0          1            0        2
                6        1.05            0          1            0        2
                7        1.02            0          1            0        2
                8        1.01            0          1            0        2
                9        1               0          -1          -1        3
               10        1               0          -1          -1        3
               11        1               0          -1          -1        3
               12        1               0          -1          -1        3
               13        1               0          -1          -1        3
               14        1               0          -1          -1        3];

%LinhasValores     Barra Origem    Barra Destino         Resistência         Reatância 
global Linhas
Linhas = [             1                2                  0.1             0.1    
                       1                5                  0.1             0.1 
                       2                3                  0.1             0.1
                       2                4                  0.1             0.1   
                       2                5                  0.1             0.1  
                       3                4                  0             0.1
                       4                5                  0             0.1
                       4                7                  0             0.1
                       4                9                  0             0.1
                       5                6                  0             0.1
                       6               11                  0             0.1
                       6               12                  0             0.1
                       6               13                  0             0.1 
                       7                8                  0             0.1
                       7                9                  0             0.1
                       9               10                  0             0.1
                       9               14                  0             0.1
                      10               11                  0             0.1
                      12               13                  0             0.1
                      13               14                  0             0.1
                      ];
end

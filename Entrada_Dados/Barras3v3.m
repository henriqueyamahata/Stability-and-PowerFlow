%lEITURA BARRAS - FLUXO DE POT�NCIA - INICIALIZA��O FLAT START

%  Revis�es:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA          

function Barras3v2

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tens�o        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2        1.04            0         0.666         0         2
                3        1               0         -2.5         -1         3
         ];

%LinhasValores     BarraOrigem    BarraDestino         Resist�ncia         Reat�ncia 
global Linhas
Linhas = [              1               2                   0                0.1
                        1               3                   0                0.1
                        2               3                   0                0.1
         ];

end  
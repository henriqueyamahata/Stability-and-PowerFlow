%lEITURA BARRAS - FLUXO DE POT�NCIA - INICIALIZA��O FLAT START

%  Revis�es:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA           

function Barras2

% V? - 1 ; PV - 2 ; PQ - 3
global Barras
%Barraa        Nome    Tens�o        Fase(Graus)    P            Q        Tipo
Barras = [      1        1               0          0            0         1
                2        1               0         -0.4          0         2
         ];

global Linhas
%LinhasValores     BarraOrigem    BarraDestino         Resist�ncia         Reat�ncia 
Linhas = [              1               2                    0.2                1
         ];
end
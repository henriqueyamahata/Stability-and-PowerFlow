%METODO NEWTON-RAPHSON - FLUXO DE POTÊNCIA

%  Revisões:
%      Data                 Programador                
%      ====                 ===========                     
%    17/09/2017        HENRIQUE MONTEIRO YAMAHATA          

function Calculo_powerFlow
clc
tic
global Barras
global Linhas
     %Tamanho das Matrizes
     [numeroBARRAS,~] = size(Barras);
     [numeroCONEXOES,~]  = size(Linhas);
     
     %Valor do erro das iterações
     erro = 0.001;
     
     %Obtendo dados das Matrizes
     barras1 = 0;
     barras2 = 0;
     barras3 = 0;
     barras1V = 0;
     
     tipobarra = zeros(1,numeroBARRAS);
     theta = zeros(1,numeroBARRAS);
     V = zeros(1,numeroBARRAS);
     nomebarra = zeros(1,numeroBARRAS);
     Pativa = zeros(numeroBARRAS,1);
     Qreati = zeros(numeroBARRAS,1);
     thetaini = zeros(numeroBARRAS,1);
     tensaoini = zeros(numeroBARRAS,1);
     for cont1=1:numeroBARRAS
         tipobarra(cont1) = Barras(cont1,6);
         theta(cont1) = Barras(cont1,3);
         V(cont1) = Barras(cont1,2);
         nomebarra(cont1) = Barras(cont1,1);
         if Barras(cont1,6) == 3
             barras3 = barras3 + 1;
             Pativa(cont1,1) = Barras(cont1,4);
             Qreati(cont1,1) = Barras(cont1,5);
             thetaini(cont1,1) = Barras(cont1,3);
             tensaoini(cont1,1) = Barras(cont1,2);
         end
         if Barras(cont1,6) == 2
             barras2 = barras2 + 1;
             Pativa(cont1,1) = Barras(cont1,4);
             thetaini(cont1,1) = Barras(cont1,3);
         end
         if Barras(cont1,6) == 1
             barras1 = barras1 + 1;
             barras1V = barras1V + 1;
             
         end
     end
     BarraORIGEM = zeros(1,numeroBARRAS);
     BarraDESTINO = zeros(1,numeroBARRAS);
     resistencia = zeros(1,numeroBARRAS);
     reatancia = zeros(1,numeroBARRAS);
     for cont2=1:numeroCONEXOES
         BarraORIGEM(cont2) = Linhas(cont2,1); %captura o valor da barra de origem da matriz Linha
         BarraDESTINO(cont2) = Linhas(cont2,2); %captura o valor da barra de destino da matriz linha
         resistencia(cont2) = Linhas(cont2,3); %captura o valor da resistencia
         reatancia(cont2) = Linhas(cont2,4);% captura o valor da reatancia
     end
     
     %Montagem da matriz ZBARRA
     Zbarra = zeros(numeroCONEXOES,numeroCONEXOES);
     for cont3=1:numeroCONEXOES
         k = BarraORIGEM(cont3);
         m = BarraDESTINO(cont3);
         Zbarra(k,m) = resistencia(cont3)+ 1i*reatancia(cont3);
         Zbarra(m,k) = Zbarra(k,m);
     end
     
     %Montagem da matriz YBARRA
     %Montagem dos Elementos YBARRA
     Ybarra = zeros(numeroBARRAS,numeroBARRAS);
     for I=1:numeroBARRAS
         for j=1:numeroBARRAS
             if Zbarra(I,j) ~= 0 ;
                 Ybarra(I,j) = -1/Zbarra(I,j);
             else
                 Ybarra(I,j) = 0;
             end
         end
     end
     
     %Montagem da diagonal YBARRA
     for cont4=1:numeroBARRAS
         for cont5=1:numeroBARRAS
             if cont4 == cont5;
                 Ybarra(cont4,cont5) = -1*sum(Ybarra(cont4,:));
             end
         end
     end
     
     %Obter Matriz G e B
     G = real(Ybarra);
     B = imag(Ybarra);
     
     %%%MATRIZPQ ESPECIFICADO
     %ESPECIFICADO P
     barras1 = barras1+1;
     barras4 = barras1+barras2;
     Pativa = Pativa(barras1:end,:);
     [sizeESPP,~] = size(Pativa);
     TamESPP = barras2+2*barras3; % numero linhas deltapq
     SupM_ESPP = zeros((TamESPP-sizeESPP),1);
     Pativa = [Pativa;SupM_ESPP];
     %ESPECIFICADO Q
     [TamESPQ,~] = size(Qreati);
     SupM_ESPQ = zeros((barras2+2*barras3),1);
     [TamSUPESPQ,~] = size(SupM_ESPQ);
     SupM_ESPQ2 = zeros((TamSUPESPQ-TamESPQ),1);
     Qreati = [SupM_ESPQ2;Qreati];
     
     %MATRIZ PQ ESPECIFICADO:
     PQ_ESPECIFICADO = Pativa+Qreati;
     
     %Acertando o tamanho da matriz THETA INICIAL
     thetaini = thetaini(barras1:end,:);
     linhaDeltaPQ = barras2+2*barras3;
     [linhathetaini,~] = size(thetaini);
     Matrizsuporte = zeros((linhaDeltaPQ-linhathetaini),1);
     thetaini = [thetaini;Matrizsuporte];
     
     %Acertando o tamanho da matriz TENSAO INICIAL
     tensaoini = tensaoini(barras1:end,:);
     linhaDeltaPQ = barras2+2*barras3;
     [linhatensaoini,~] = size(tensaoini);
     Matrizsuporte2 = zeros((linhaDeltaPQ-linhatensaoini),1);
     tensaoini = [Matrizsuporte2;tensaoini] ;
     
     ThetaV_ini = thetaini+tensaoini;
     
     ite =0;
     ValorERRO = 1;
     while ValorERRO > erro
         %Calcula Matriz de Potência ativa
         MatrizPATIVA = zeros(numeroBARRAS,1);
         P = zeros(numeroBARRAS,1);
         for k=1:numeroBARRAS
             if tipobarra(1,k) ~= 1
                 for m=1:numeroBARRAS
                     P(k,1) = V(1,k)*(V(1,m)*(G(k,m)*cos(theta(k)-theta(m)) + B(k,m)*sin(theta(k)-theta(m))));
                     MatrizPATIVA(k,1) = MatrizPATIVA(k,1)+ P(k,1);
                 end
             end
         end
         
         %Calcula Matriz de Potência reativa
         if barras3~=0
             Q = zeros(numeroBARRAS,1);
             MatrizPREATIVA = zeros(numeroBARRAS,1);
             for k=1:numeroBARRAS
                 if tipobarra(1,k) == 3
                     for m=1:numeroBARRAS
                         Q(k,1) = V(1,k)*(V(1,m)*(G(k,m)*sin(theta(k)-theta(m)) - B(k,m)*cos(theta(k)-theta(m))));
                         MatrizPREATIVA(k,1) = MatrizPREATIVA(k,1)+ Q(k,1);
                     end
                 end
             end
         end
         
         %%%MATRIZPQ CALCULADO
         %CALCULADO P
         MatrizPATIVA = MatrizPATIVA(barras1:end,:);
         [sizeCALCP,~] = size(MatrizPATIVA);
         TamCALCP = barras2+2*barras3; % numero linhas deltapq
         SupM_CALCP = zeros((TamCALCP-sizeCALCP),1);
         MatrizPATIVA = [MatrizPATIVA;SupM_CALCP];
         if barras3 ~=0
         %CALCULADO Q
         %MatrizPREATIVA;
         [TamCALCQ,~] = size(MatrizPREATIVA);
         SupM_CALCQ = zeros((barras2+2*barras3),1);
         [TamSUPCALCQ,~] = size(SupM_CALCQ);
         SupM_CALCQ2 = zeros((TamSUPCALCQ-TamCALCQ),1);
         MatrizPREATIVA = [SupM_CALCQ2;MatrizPREATIVA];
         end
         if barras3~=0
         %MATRIZ PQ ESPECIFICADO:
         PQ_CALCULADO = MatrizPATIVA+MatrizPREATIVA;
         else
             PQ_CALCULADO = MatrizPATIVA;
         end
         
         %%%MATRIZ DELTAPQ
         DeltaPQ = PQ_ESPECIFICADO - PQ_CALCULADO;
         
         %Estruturar a matriz jacobiana
         %Tamanho das Matrizes que compoem a Jacobiana
         H = zeros(numeroBARRAS-1,numeroBARRAS-1);
         [~,~] = size(H);
         
         if barras3 ~= 0
             M = zeros(barras3,numeroBARRAS-1);
             N = zeros(numeroBARRAS-1,barras3);
             L = zeros(barras3,barras3);
         end
         
         %CALCULO MATRIZ H
         %Calculo Diagonal H
         MatrizHDiagonal = zeros(numeroBARRAS,1);
         for k=1:numeroBARRAS
             if tipobarra(1,k) ~= 1
                 for m=1:numeroBARRAS
                     MatrizHDiagonal(k,1) = MatrizHDiagonal(k,1)+ V(1,m)*(G(k,m)*sin(theta(k)-theta(m)) - B(k,m)*cos(theta(k)-theta(m)));
                 end
                 MatrizHDiagonal(k,1) =(-1)*V(1,k)*V(1,k)*B(k,k)- V(1,k)*MatrizHDiagonal(k,1);
             end
         end
         MatrizHDiagonal = MatrizHDiagonal(barras1:end,:);
         Hprincipal = diag(MatrizHDiagonal);
         
         %Calculo Elementos H
         dpk2_dtm = zeros(numeroBARRAS,numeroBARRAS);
         for testesteste=1:numeroCONEXOES
             ka  = BarraORIGEM(1,testesteste);
             eme = BarraDESTINO(1,testesteste);
             dpk2_dtm(ka,eme) = V(1,ka)*V(1,eme)*(G(ka,eme)*sin(theta(ka)-theta(eme))- B(ka,eme)*cos(theta(ka)-theta(eme)));
             dpk2_dtm(eme,ka) =(V(1,ka)*V(1,eme)*(-G(ka,eme)*sin(theta(ka)-theta(eme))-B(ka,eme)*cos(theta(ka)-theta(eme))));
         end
         
         dpk2_dtm = dpk2_dtm(barras1:end,barras1:end);
         
         %Formar Matriz H
         H =  Hprincipal + dpk2_dtm;
         
         %CALCULO MATRIZ N
         %Calculo DIAGONAL N
         if barras3 ~=0;
             Diagonal_N = zeros(numeroBARRAS,1);
             Pt1 = zeros(numeroBARRAS,1);
             
             for k=1:numeroBARRAS
                 if tipobarra(1,k) ~= 1
                     Pt1(k,1) = V(1,k)*G(k,k);
                     for m=1:numeroBARRAS
                         Diagonal_N(k,1) = Diagonal_N(k,1)+ V(1,m)*(G(k,m)*cos(theta(k)-theta(m)) - B(k,m)*sin(theta(k)-theta(m)));
                     end
                     Diagonal_N(k,1) = Diagonal_N(k,1) + Pt1(k,1);
                 end
             end
             Diagonal_N = Diagonal_N(barras4:end,:);
             Nprincipal = diag(Diagonal_N);
             
             % Calculo Elementos N
             Elementos_N = zeros(numeroBARRAS,numeroBARRAS);
             for testesteste=1:numeroCONEXOES
                 ka  = BarraORIGEM(1,testesteste);
                 eme = BarraDESTINO(1,testesteste);
                 Elementos_N(ka,eme) = V(1,ka)*(G(ka,eme)*cos(theta(ka)-theta(eme))+ B(ka,eme)*sin(theta(ka)-theta(eme)));
                 Elementos_N(eme,ka) = V(1,eme)*(G(ka,eme)*cos(theta(ka)-theta(eme))+ B(ka,eme)*sin(theta(ka)-theta(eme)));
             end
             Elementos_N = Elementos_N(barras1:end,barras4:end);
             
             %Formar Matriz N
             [LinhaN,~] = size(Nprincipal);
             DimensaoMatrizN = zeros(numeroBARRAS-LinhaN-1,barras3);
             Nprincipal = [DimensaoMatrizN;Nprincipal];
             N = Nprincipal + Elementos_N;
         end
         
         %CALCULO MATRIZ L
         %Calculo DIAGONAL L
         if barras3~=0 % Para existir Matriz L, precisa ter ao menos 1 barra3 PQ
             Diagonal_L = zeros(numeroBARRAS,1);
             PtL = zeros(numeroBARRAS,1);
             for k=1:numeroBARRAS
                 if tipobarra(1,k) ~= 1
                     PtL(k,1) = -V(1,k)*B(k,k);
                     for m=1:numeroBARRAS
                         Diagonal_L(k,1) = Diagonal_L(k,1)+ V(1,m)*(G(k,m)*sin(theta(k)-theta(m)) - B(k,m)*cos(theta(k)-theta(m)));
                     end
                     Diagonal_L(k,1) = Diagonal_L(k,1) + PtL(k,1);
                 end
             end
             Diagonal_L = Diagonal_L(barras4:end,:);
             Lprincipal = diag(Diagonal_L);
             
             % Calculo Elementos L
             Elementos_L = zeros(numeroBARRAS,numeroBARRAS);
             for testesteste=1:numeroCONEXOES
                 ka  = BarraORIGEM(1,testesteste);
                 eme = BarraDESTINO(1,testesteste);
                 Elementos_L(ka,eme) = V(1,ka)*(G(ka,eme)*sin(theta(ka)-theta(eme))-B(ka,eme)*cos(theta(ka)-theta(eme)));
                 Elementos_L(eme,ka) = V(1,eme)*(G(ka,eme)*sin(theta(ka)-theta(eme))-B(ka,eme)*cos(theta(ka)-theta(eme)));
                 
             end
             Elementos_L = Elementos_L(barras4:end,barras4:end);
             %Formar Matriz L
             L = Lprincipal + Elementos_L;
         end
         
         %CALCULO MATRIZ M
         %Calculo Diagonal M
         if barras3~=0 % Para existir Matriz M, precisa ter ao menos 1 barra3 PQ
             Diagonal_M = zeros(numeroBARRAS,1);
             for k=1:numeroBARRAS
                 if tipobarra(1,k) ~= 1
                     for m=1:numeroBARRAS
                         Diagonal_M(k,1) = Diagonal_M(k,1)+ V(1,m)*(G(k,m)*cos(theta(k)-theta(m)) + B(k,m)*sin(theta(k)-theta(m)));
                     end
                     Diagonal_M(k,1) =(-1)*V(1,k)*V(1,k)*G(k,k)+ V(1,k)*Diagonal_M(k,1);
                 end
             end
             Diagonal_M = Diagonal_M(barras4:end,:);
             Diagonal_M = diag(Diagonal_M);
             
             % Calculo Elementos M
             Elementos_M = zeros(numeroBARRAS,numeroBARRAS);
             for testesteste=1:numeroCONEXOES
                 ka  = BarraORIGEM(1,testesteste);
                 eme = BarraDESTINO(1,testesteste);
                 Elementos_M(ka,eme) = -V(1,ka)*V(1,eme)*(G(ka,eme)*cos(theta(ka)-theta(eme))+B(ka,eme)*sin(theta(ka)-theta(eme)));
                 Elementos_M(eme,ka) = -V(1,ka)*V(1,eme)*(G(ka,eme)*cos(theta(ka)-theta(eme))-B(ka,eme)*sin(theta(ka)-theta(eme)));
             end
             Elementos_M = Elementos_M(barras4:end,barras1:end);
             
             %Formar Matriz M
             [~,ColunasN] = size(Elementos_M); % pegar o tamanho da matriz elementosM
             [~,ColunadN] = size(Diagonal_M); % pegar o tamanho da matriz defasada em colunas
             DimensaoMatrizM = zeros(barras3,ColunasN-ColunadN); % formar matriz com as linhas que faltam na diagonalm
             Mprincipal = [DimensaoMatrizM Diagonal_M];
             M = Mprincipal + Elementos_M;
         end
         
         %                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% JACOBIANA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %                  %%%%                                                                  %%%%
         %                  %%%%                        [    H      N    ]                        %%%%
         %                  %%%%                        [    M      L    ]                        %%%%
         %                  %%%%                                                                  %%%%
         %                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
         if barras3 ==0
             J = H;
         end
         if barras3 ~= 0
             J = [ H N ; M L ];
         end
         
         %Calculando Delta Theta,tensao
         DeltaTV = J\DeltaPQ;
         
         %     %calculo ERRRO
         ThetaV_ini = ThetaV_ini + DeltaTV;
         
         %Separar ThetaV_ini em 1 matriz Angulo e outra Tensao
         %Isolando Matriz Angulos
         Mang = flipud(ThetaV_ini);
         Mang = Mang((barras3+1:end),1);
         Mang = flipud(Mang);
         %Tornando matriz angulos do tamanho do sistema
         [tamSist,~] = size(barras1V);
         Sup_Mang = zeros((tamSist),1);
         Mang = [Sup_Mang;Mang];
         Mang = Mang';
         
         %Isolando Matriz Tensoes
         Mten = ThetaV_ini((barras2+barras3+1:end),1);
         Sup_Mten = zeros((barras1V+barras2),1);
         Mten = [Sup_Mten;Mten];
         Mten = Mten';
         
         %%Novos valores Angulos e Tensoes
         %%Novos Angulos
         for k=1:numeroBARRAS
             if tipobarra(k) ~=1
                 theta(1,k) = Mang(1,k);
             end
         end
         %%Novas Tensoes
         for k=1:numeroBARRAS
             if tipobarra(k) == 3
                 V(1,k) = Mten(1,k);
             end
         end
         

         ModuloDeltaTV = abs(DeltaTV);
         ValorERRO = max(ModuloDeltaTV);
         ite = ite+1;
     end
     
     %POTENCIA ATIVA EM CADA BARRA APOS ITERAÇÕES
     PAtiva_final = zeros(numeroBARRAS,1);
     Pf = zeros(numeroBARRAS,1);
     for k=1:numeroBARRAS
         for m=1:numeroBARRAS
             Pf(k,1) = V(1,k)*(V(1,m)*(G(k,m)*cos(theta(k)-theta(m)) + B(k,m)*sin(theta(k)-theta(m))));
             PAtiva_final(k,1) = PAtiva_final(k,1)+ Pf(k,1);
         end
     end
     %POTENCIA REATIVA EM CADA BARRA APOS ITERAÇÕES
     Qf = zeros(numeroBARRAS,1);
    % if barras3~=0
         PReativa_final = zeros(numeroBARRAS,1);
         for k=1:numeroBARRAS
             for m=1:numeroBARRAS
                 Qf(k,1) = V(1,k)*(V(1,m)*(G(k,m)*sin(theta(k)-theta(m)) - B(k,m)*cos(theta(k)-theta(m))));
                 PReativa_final(k,1) = PReativa_final(k,1)+ Qf(k,1);
             end
         end
     %end
     %POTENCIA ATIVA ENTRE AS BARRAS
     P_entrebarras = zeros(numeroCONEXOES,1);
     Q_entrebarras = zeros(numeroCONEXOES,1);
     Pperdas= zeros(numeroCONEXOES,1);
     Qperdas= zeros(numeroCONEXOES,1);
     for btw=1:numeroCONEXOES
         K = BarraORIGEM(1,btw);
         M = BarraDESTINO(1,btw);
         P_entrebarras(btw,1) =  G(K,M)*V(1,K)^2 - G(K,M)*V(1,K)*V(1,M)*cos(theta(K)-theta(M))-B(K,M)*V(1,K)*V(1,M)*sin(theta(K)-theta(M));
         Q_entrebarras(btw,1) = -B(K,M)*V(1,K)^2 - G(K,M)*V(1,K)*V(1,M)*sin(theta(K)-theta(M))+B(K,M)*V(1,K)*V(1,M)*cos(theta(K)-theta(M));
         Pperdas(btw,1) =   G(K,M)*(V(1,K)^2 + V(1,M)^2)-2*G(K,M)*V(1,K)*V(1,M)*cos(theta(K)-theta(M)); 
         Qperdas(btw,1) =  -B(K,M)*(V(1,K)^2 + V(1,M)^2)+2*B(K,M)*V(1,K)*V(1,M)*cos(theta(K)-theta(M));
     end
     
     fprintf(' Número de iterações: %d \n',ite)
     fprintf(' Valor do maior erro: %.5f \n',ValorERRO)
     
     %IMPRESSÃO DOS RESULTADOS VALORES DAS BARRAS
     theta_graus = zeros(1,numeroBARRAS);
     fprintf('\n Nome    TipoBarra    Tensão(pu)    Ângulo(º)    Potencia Ativa(pu)    Potencia Reativa(pu)\n');
     for print=1:numeroBARRAS
         theta_graus(1,print) = theta(1,print)*180/pi;
         fprintf(' %2d %10d %14.4f %12.2f %16.3f %22.3f \n',nomebarra(1,print),tipobarra(print),V(1,print),theta_graus(1,print),PAtiva_final(print,1),PReativa_final(print,1))
     end
     
     %IMPRESSÃO DOS RESULTADOS FLUXO DE POTENCIA     
     fprintf('\n Origem    Destino    Potencia Ativa(pu)    Potencia Reativa(pu)    Perdas Reativa(pu)    Perdas Ativa(pu)\n');
     for print2=1:numeroCONEXOES
         fprintf(' %4d %9d %16.3f %22.3f %22.3f %22.3f\n',BarraORIGEM(1,print2),BarraDESTINO(1,print2),P_entrebarras(print2,1),Q_entrebarras(print2,1),Qperdas(print2,1),Pperdas(print2,1))
     end   
     fprintf('\nPotência Ativa produzida/consumida + perdas LT: ');
     Ativa = sum(PAtiva_final) + sum(Pperdas);disp(Ativa)
     fprintf('Potência Reativa produzida/consumida + perdas LT: ');
     Reativa = sum(PReativa_final) + sum(Qperdas);disp(Reativa)    
    toc
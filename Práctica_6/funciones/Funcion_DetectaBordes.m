function Icarretera = Funcion_DetectaBordes(I)
%FUNCION_DETECTABORDES Summary of this function goes here
%   Detailed explanation goes here

    %% 1)
    Igray = rgb2gray(I);
    [M, N] = size(Igray);
    
   

%% 2)

    Hx = [-1 0 1;-2 0 2;-1 0 1];
    Hy = [-1 -2 -1;0 0 0;1 2 1];

    [Gx Gy ModG] = Funcion_Calcula_Gradiente(Igray,Hx,Hy);

    maximo = max(ModG(:));
    umbral = 0.3;

    Ib = abs(Gx) > maximo*umbral;
    
    %% 3)
    
    [H,theta,rho] = hough(Ib);
    [m n] = find(H == max(H(:))); % n para saber el valor de rho y m para el de theta

    vtheta = theta(n);
    vrho = rho(m);
    
    %% 4)
    NumRectas = 5; Umbral = ceil(0.3*max(H(:)));
    P = houghpeaks(H,NumRectas,'threshold',Umbral);	
	
    %% 5)
    lines = houghlines(Ib,theta,rho,P,'FillGap',5,'MinLength',7);
    
    
    %% 6)

    Ibin = ones(M,N)*255;

    for i=1:NumRectas
        distancia = rho(P(i,1));
        angulo = theta(P(i,2)); 

        % Seleccionamos las coordenadas que representan la línea
        X = 1:N;
        Y = round((distancia-cosd(angulo)*X)/sind(angulo));

        % Seleccionamos las que están dentro de nuestra imagen
        selec = find(Y>0 & Y<=M);
        Xi = X(selec);
        Yi = Y(selec);

        % Pintamos 
        for j=1:length(Xi)
            Ibin(Yi(j),Xi(j)) = 0;
        end
    end
    
    Ifilt = Funcion_FiltroMinimos(Ibin);
    
    Ilabel = bwlabel(Ifilt);

    xCentro = floor(M/2);
    yCentro = floor(N/2);
    labelCentro = Ilabel(xCentro, yCentro);

    IbinCarretera = Ilabel == labelCentro;
    
    R = I(:,:,1); G = I(:,:,2); B = I(:,:,3); 
    Icarretera = uint8(IbinCarretera.*double(R));
    Icarretera = cat(3,Icarretera,IbinCarretera.*double(G));
    Icarretera = cat(3,Icarretera,IbinCarretera.*double(B));

    
    figure, hold on
        subplot(2,3,1), imshow(I), title('Imagen original'),
        subplot(2,3,2), imshow(Igray), title('Imagen de intensidad'),
        subplot(2,3,3), imshow(Ib), title('Imagen de bordes'),
        subplot(2,3,4), imshow(Ifilt), title('Representacion de las rectas'),
        subplot(2,3,5), imshow(IbinCarretera), title('Seccion de carretera binaria'),
        subplot(2,3,6), imshow(Icarretera), title('Seccion de carretera a color'),
        hold off;
end


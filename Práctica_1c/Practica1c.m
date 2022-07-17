%% ------------------------------------------------------
%   PRÁCTICA 1c
% -------------------------------------------------------

% Usando roipily extraemos de la imagen la información central contenida en
% el cuadro

I = imread("P1b.jpg");
ROI = roipoly(I);

% Observamos que posiciones pertenecen al cuadro
[row,col] = find(ROI);
nI = I(min(row):max(row),min(col):max(col));
figure, imshow(nI)

% Debemos determinar el brillo y el contraste de la nueva imagen generada
% El *brillo* viene dado por el valor medio de los niveles de gris(una imagen
% brillante tendrá una media alta). El *contraste* viene dado por la
% dispersión de los alrededores de la media y proporciona información sobre
% el contraste de una imagen(varianza alta -> contraste alto)

[N,M] = size(nI);
brillo = sum(nI(:)) / (N*M);
varianza = sum((nI(:)-brillo).^2) / (N*M);

% Ahora debemos hacer una imagen más brillante y otra menos brillante
brillo_var = 100;
nI_brilloAlto = nI + brillo_var;
nI_brilloBajo = nI - brillo_var;

brillo_alto = sum(nI_brilloAlto(:)) / (N*M);
brillo_bajo = sum(nI_brilloBajo(:)) / (N*M);

figure, hold on
    %title("Diferencias de brillo en " + num2str(brillo_var)),
    subplot(1,3,1), imshow(nI),  title("Brillo: " + num2str(brillo)),
    subplot(1,3,2), imshow(nI_brilloAlto), title("Brillo: " + num2str(brillo_alto)), 
    subplot(1,3,3), imshow(nI_brilloBajo), title("Brillo: " + num2str(brillo_bajo));
    
% Ahora hacemos una imagen con más contraste y otra con menos
contraste_var = 20;

pmax = max(nI(:)); % Valor máximo de gris de la imagen original
pmin = min(nI(:)); % Valor mínimo de gris de la imagen original
qmax1 = pmax + contraste_var; % Nuevo valor de gris después de la transformación
qmin1 = pmin - contraste_var; % Nuevo valor de gris después de la transformación
qmax2 = pmax - contraste_var; % Nuevo valor de gris después de la transformación
qmin2 = pmin + contraste_var; % Nuevo valor de gris después de la transformación

if qmax1 > 255
    qmax = 255;
end

if qmax2 > 255
    qmax = 255;
end

if qmin1 < 0 
    qmin = 0;
end

if qmin2 < 0 
    qmin = 0;
end

nI_contrasteAlto = qmin1 + ((qmax1-qmin1) / (pmax-pmin)) * [nI - pmin]; 
nI_contrasteBajo = qmin2 + ((qmax2-qmin2) / (pmax-pmin)) * [nI - pmin]; 

varianza_alto = sum((nI_contrasteAlto(:)-brillo).^2) / (N*M);
varianza_bajo = sum((nI_contrasteBajo(:)-brillo).^2) / (N*M);

figure, hold on
    %title("Diferencias de contraste en " + contraste_var),
    subplot(1,3,1), imhist(nI), title("Contraste: " + num2str(varianza))
    subplot(1,3,2), imhist(nI_contrasteAlto), title("Contraste Alto: " + num2str(varianza_alto))
    subplot(1,3,3), imhist(nI_contrasteBajo), title("Contraste Bajo: " + num2str(varianza_bajo));

figure, hold on
    title("Diferencias de contraste en " + contraste_var),
    subplot(1,3,1), imshow(nI), title("Contraste: " + num2str(varianza)),
    subplot(1,3,2), imshow(nI_contrasteAlto), title("Contraste: " + num2str(varianza_alto))
    subplot(1,3,3), imshow(nI_contrasteBajo), title("Contraste: " + num2str(varianza_bajo));
        
    

% Ahora debemos de comprobar los distintos modos de operación de la
% instrucción imfilter

% Primero creamos un filtro
h = fspecial('motion', 50, 45);
Im1 = imfilter(nI,h);
figure, imshow(Im1)

HP = ones(5,5)/25; 
HL = [-1 -1 -1;-1 8 -1;-1 -1 -1];
Im2 = imfilter(nI,HP);
Im3 = imfilter(nI,HL);
figure, imshow(Im2)
figure, imshow(Im3)

HP = ones(9,9)/81; 
Im4 = imfilter(nI,HP);
figure, imshow(Im4)

% Comprobamos que la función que hemos creado funciona

HP = ones(5,5)/25; 
Im1 = imfilter(nI,HP);
Im2 = myfilter(nI,HP);
figure, hold on
    subplot(1,2,1), imshow(Im1), title("imfilter"),
    subplot(1,2,2), imshow(Im2), title("myfilter");
    
HP = ones(9,9)/81; 
Im1 = imfilter(nI,HP);
Im2 = myfilter(nI,HP);
figure, hold on
    subplot(1,2,1), imshow(Im1), title("imfilter"),
    subplot(1,2,2), imshow(Im2), title("myfilter");   
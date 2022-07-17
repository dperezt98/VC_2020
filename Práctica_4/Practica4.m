%% ------------------------------------------------------
%   PRÁCTICA 4
% -------------------------------------------------------

clear 
clc
addpath("./funciones");

%% PRIMERA PARTE: Simulación de ruidos
% *************************************************************************

%% 1).- Leemos la imagen "P4.tif"
I = imread("./P4.tif");
[M,N] = size(I);
Id = double(I);

%% 2).- Corrompemos la imagen anterior con ruido de tipo de sal y pimienta
p = 0.9;  q = 0.95;
Isyp = ruido_salypimienta(I,p,q);
media = 1; desv = 10;
Igau = ruido_gaussiano(I,media,desv);

%% 3).- Visualizamos las imágenes ruidosas A y B. Y representamos la línea 
% central de las imagenes en una gráfica

mitadM = M/2;

figure, hold on
    subplot(2,2,1), imshow(I), title("Imagen original"),
    subplot(2,2,2), imshow(Isyp), title("Imagen con ruido sal y pimienta"),
    subplot(2,2,3), imshow(Igau), title("Imagen con ruido gaussiano"), hold off;
    
figure, hold on
    plot(Isyp(mitadM,:),'-b'),xlabel("Columna"), ylabel("Nivel de gris"),
    plot(Igau(mitadM,:),'-g'),
    plot(I(mitadM,:),'-r'), legend("Imagen sal y pimienta","Imagen gaussiana", "Imagen original"),
    hold off;

    
%% SEGUNDA PARTE: Implementación de filtros gaussiano, mediana y adaptativo
% *************************************************************************

% Filtro Gaussiano
IgaussianaSyp = filtro_gaussiano(Isyp,5,1);

fspecialH = fspecial('gaussian',5,1);
IspecialSyp = imfilter(Isyp,fspecialH);

figure, hold on,
    subplot(1,2,1), imshow(IgaussianaSyp), title('Filtro gaussiano sobre Isyp');
    subplot(1,2,2), imshow(IspecialSyp), title('fspecial sobre Isyp'), 
    hold off;

comp = IgaussianaSyp == IspecialSyp;
comprueba = min(comp(:))

IgaussianaGau = filtro_gaussiano(Igau,5,1);

fspecialH = fspecial('gaussian',5,1);
IspecialGau = imfilter(Igau,fspecialH);
figure, imshow(IspecialGau)

comp = IgaussianaGau == IspecialGau;
comprueba = min(comp(:))

figure, hold on,
    subplot(1,2,1), imshow(IgaussianaGau), title('Filtro gaussiano sobre Igau');
    subplot(1,2,2), imshow(IspecialGau), title('fspecial sobre Igau'), 
    hold off;


% Filtro Mediana
ImedianaSyp = Funcion_FiltroMediana(Isyp,5,5);

Imedfilt2Syp = medfilt2(Isyp,[5 5]);

comp = ImedianaSyp == Imedfilt2Syp;
comprueba = min(comp(:))

figure, hold on,
    subplot(1,2,1), imshow(ImedianaSyp), title('Filtro mediana sobre ImedianaSyp');
    subplot(1,2,2), imshow(Imedfilt2Syp), title('fspecial sobre Imedfilt2Syp'), 
    hold off;
    
ImedianaGau = Funcion_FiltroMediana(Igau,5,5);

Imedfilt2Gau = medfilt2(Igau,[5 5]);

comp = ImedianaGau == Imedfilt2Gau;
comprueba = min(comp(:))

figure, hold on,
    subplot(1,2,1), imshow(ImedianaGau), title('Filtro mediana sobre ImedianaGau');
    subplot(1,2,2), imshow(Imedfilt2Gau), title('fspecial sobre Imedfilt2Gau'), 
    hold off;
     
    
% Filtro Adaptativo
ruido = double(Isyp)-double(I); % Imagen original menos sal y pimienta
VarRuido = std(ruido(:))^2;
Iadaptativo = Funcion_FiltAdapt(Isyp,5,5,VarRuido);
figure, imshow(Iadaptativo)

figure, hold on,
        plot(Isyp(mitadM,:),'-b'), xlabel("Columna"), ylabel("Nivel de gris"),
        plot(Iadaptativo(mitadM,:),'-r'), legend('Imagen syp','filtro adaptativo'),
        hold off;

%% TERCERA PARTE: Evaluación de eficiencia de filtros gaussiano, mediana y adaptativo
% *************************************************************************

%% 1).- Usa la imagen P4.tif para crear imagenes con ruido gaussiano con
% desviación típica 5,10 y 35

clear 
clc
addpath("./funciones");

I = imread("./P4.tif");
[M,N] = size(I);
mitadM = M/2;

ruidoGau5 = ruido_gaussiano(I,0,5);
ruidoGau10 = ruido_gaussiano(I,0,10);
ruidoGau35 = ruido_gaussiano(I,0,35);

figure, sgtitle('P4.tif con ruido gaussiano'), hold on,
    subplot(1,3,1), imshow(ruidoGau5), title('Desviación típica 5'),
    subplot(1,3,2), imshow(ruidoGau10), title('Desviación típica 10'),
    subplot(1,3,3), imshow(ruidoGau35), title('Desviación típica 35'), hold off;
figure, sgtitle('P4.tif con ruido gaussiano'), hold on,    
    plot(ruidoGau35(mitadM,:),'-b'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(ruidoGau10(mitadM,:),'-g'),
    plot(ruidoGau5(mitadM,:),'-r'), legend("Desv 35","Desv 10","Desv 5"),
    hold off;
   
%% 2).- Filtra cada una de las imágenes ruidosas anteriores con filtros de tipo gaussiano, de tipo
% mediana y adaptativo, considerando tamaños 3x3 y 7x7 para cada filtro. Visualiza las
% distintas imágenes ruidosas y filtradas.

%% Para desviación típica 5
ruido = double(I)-double(ruidoGau5); % Imagen original menos imagen con ruido
varRuidoGau5 = std(ruido(:))^2;

% --------------------------------------------
filtro5gau3 = filtro_gaussiano(ruidoGau5,3,1);
filtro5med3 = Funcion_FiltroMediana(ruidoGau5,3,3);
filtro5ada3 = Funcion_FiltAdapt(ruidoGau5,3,3,varRuidoGau5);
% --------------------------------------------

figure, sgtitle('Desviación típica 5 - Filtro gaussiano Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau5), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro5gau3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 5 - Filtro gaussiano Ventana 3x3'), hold on,
    plot(ruidoGau5(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro5gau3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 5 - Filtro Mediana Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau5), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro5med3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 5 - Filtro Mediana Ventana 3x3'), hold on,
    plot(ruidoGau5(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro5med3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 5 - Filtro Adaptativo Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau5), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro5ada3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 5 - Filtro Adaptativo Ventana 3x3'), hold on,
    plot(ruidoGau5(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro5ada3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;

% --------------------------------------------
filtro5gau7 = filtro_gaussiano(ruidoGau5,7,1);
filtro5med7 = Funcion_FiltroMediana(ruidoGau5,7,7);
filtro5ada7 = Funcion_FiltAdapt(ruidoGau5,7,7,varRuidoGau5);
% --------------------------------------------

    
figure, sgtitle('Desviación típica 5 - Filtro gaussiano Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau5), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro5gau7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 5 - Filtro gaussiano Ventana 7x7'), hold on,
    plot(ruidoGau5(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro5gau7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 5 - Filtro Mediana Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau5), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro5med7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 5 - Filtro Mediana Ventana 7x7'), hold on,
    plot(ruidoGau5(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro5med7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 5 - Filtro Adaptativo Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau5), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro5ada7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 5 - Filtro Adaptativo Ventana 7x7'), hold on,
    plot(ruidoGau5(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro5ada7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;

%% Para desviación típica 10

ruido = double(I)-double(ruidoGau10); % Imagen original menos imagen con ruido
varRuidoGau10 = std(ruido(:))^2;

% --------------------------------------------
filtro10gau3 = filtro_gaussiano(ruidoGau10,3,1);
filtro10med3 = Funcion_FiltroMediana(ruidoGau10,3,3);
filtro10ada3 = Funcion_FiltAdapt(ruidoGau10,3,3,varRuidoGau10);
% --------------------------------------------

figure, sgtitle('Desviación típica 10 - Filtro gaussiano Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau10), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro10gau3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 10 - Filtro gaussiano Ventana 3x3'), hold on,
    plot(ruidoGau10(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro10gau3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 10 - Filtro Mediana Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau10), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro10med3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 10 - Filtro Mediana Ventana 3x3'), hold on,
    plot(ruidoGau10(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro10med3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 10 - Filtro Adaptativo Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau10), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro10ada3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 10 - Filtro Adaptativo Ventana 3x3'), hold on,
    plot(ruidoGau10(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro10ada3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;

% --------------------------------------------
filtro10gau7 = filtro_gaussiano(ruidoGau10,7,1);
filtro10med7 = Funcion_FiltroMediana(ruidoGau10,7,7);
filtro10ada7 = Funcion_FiltAdapt(ruidoGau10,7,7,varRuidoGau10);
% --------------------------------------------

figure, sgtitle('Desviación típica 10 - Filtro gaussiano Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau10), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro10gau7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 10 - Filtro gaussiano Ventana 7x7'), hold on,
    plot(ruidoGau10(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro10gau7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 10 - Filtro Mediana Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau10), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro10med7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 10 - Filtro Mediana Ventana 7x7'), hold on,
    plot(ruidoGau10(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro10med7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 10 - Filtro Adaptativo Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau10), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro10ada7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 10 - Filtro Adaptativo Ventana 7x7'), hold on,
    plot(ruidoGau10(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro10ada7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
%% Para desviación típica 35

ruido = double(I)-double(ruidoGau35); % Imagen original menos imagen con ruido
varRuidoGau35 = std(ruido(:))^2;

% --------------------------------------------
filtro35gau3 = filtro_gaussiano(ruidoGau35,3,1);
filtro35med3 = Funcion_FiltroMediana(ruidoGau35,3,3);
filtro35ada3 = Funcion_FiltAdapt(ruidoGau35,3,3,varRuidoGau35);
% --------------------------------------------

figure, sgtitle('Desviación típica 35 - Filtro gaussiano Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau35), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro35gau3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 35 - Filtro gaussiano Ventana 3x3'), hold on,
    plot(ruidoGau35(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro35gau3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 35 - Filtro Mediana Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau35), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro35med3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 35 - Filtro Mediana Ventana 3x3'), hold on,
    plot(ruidoGau35(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro35med3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 35 - Filtro Adaptativo Ventana 3x3'), hold on,
    subplot(1,2,1), imshow(ruidoGau35), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro35ada3), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 35 - Filtro Adaptativo Ventana 3x3'), hold on,
    plot(ruidoGau35(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro35ada3(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
% --------------------------------------------
filtro35gau7 = filtro_gaussiano(ruidoGau35,7,1);
filtro35med7 = Funcion_FiltroMediana(ruidoGau35,7,7);
filtro35ada7 = Funcion_FiltAdapt(ruidoGau35,7,7,varRuidoGau35);
% --------------------------------------------

figure, sgtitle('Desviación típica 35 - Filtro gaussiano Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau35), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro35gau7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 35 - Filtro gaussiano Ventana 7x7'), hold on,
    plot(ruidoGau35(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro35gau7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 35 - Filtro Mediana Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau35), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro35med7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 35 - Filtro Mediana Ventana 7x7'), hold on,
    plot(ruidoGau35(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro35med7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;
    
figure, sgtitle('Desviación típica 35 - Filtro Adaptativo Ventana 7x7'), hold on,
    subplot(1,2,1), imshow(ruidoGau35), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(filtro35ada7), title('Imagen filtrada'), hold off;
figure, sgtitle('Desviación típica 35 - Filtro Adaptativo Ventana 7x7'), hold on,
    plot(ruidoGau35(mitadM,:),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(filtro35ada7(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen filtrada"),
    hold off;

%% 3).- Evalúa la eficiencia de cada proceso de filtrado midiendo la relación señal-ruido (ISNR)

G = cat(3,ruidoGau5,ruidoGau10,ruidoGau35);
Ie5 = cat(3,filtro5gau3,filtro5med3,filtro5ada3,filtro5gau7,filtro5med7,filtro5ada7);
Ie10 = cat(3,filtro10gau3,filtro10med3,filtro10ada3,filtro10gau7,filtro10med7,filtro10ada7);
Ie35 = cat(3,filtro35gau3,filtro35med3,filtro35ada3,filtro35gau7,filtro35med7,filtro35ada7);

% Para desviación típica 5
isnr5 = [];
superior = (double(I)-double(G(:,:,1))).^2;
sumSuperior = sum(superior(:)); % Error de la imagen con ruido respecto a la original
for i=1:6
    inferior = (double(I)-double(Ie5(:,:,i))).^2;
    sumInferior = sum(inferior(:)); % Error de la imagen con filtrada respecto a la original
    res = 10*log10(sumSuperior/sumInferior);
    isnr5 = [isnr5;res];
end

display(' ');
disp('   Desviación típica 5');
disp('    gau3      med3      ada3      gau7      med7      ada7');
disp(isnr5');

% Para desviación típica 10
isnr10 = [];
superior = (double(I)-double(G(:,:,2))).^2;
sumSuperior = sum(superior(:));
for i=1:6
    inferior = (double(I)-double(Ie10(:,:,i))).^2;
    sumInferior = sum(inferior(:));
    res = 10*log10(sumSuperior/sumInferior);
    isnr10 = [isnr10;res];
end

display(' ');
disp('   Desviación típica 10');
disp('    gau3      med3      ada3      gau7      med7      ada7');
disp(isnr10');

% Para desviación típica 35
isnr35 = [];
superior = (double(I)-double(G(:,:,3))).^2;
sumSuperior = sum(superior(:));
for i=1:6
    inferior = (double(I)-double(Ie35(:,:,i))).^2;
    sumInferior = sum(inferior(:));
    res = 10*log10(sumSuperior/sumInferior);
    isnr35 = [isnr35;res];
end

display(' ');
disp('   Desviación típica 35');
disp('    gau3      med3      ada3      gau7      med7      ada7');
disp(isnr35');

% Resultados totales

display(' ');
disp('            gau3        med3       ada3         gau7        med7        ada7');
disp(['Desv  5     ',num2str(isnr5')]);
disp(['Desv 10     ',num2str(isnr10')]);
disp(['Desv 35     ',num2str(isnr35')]);

%% 4).- A partir de los resultados obtenidos, realiza un informe de conclusiones.

%% 5).- Genera, a partir de la imagen inicial, 10 imágenes ruidosas con ruido blanco gaussiano y
% desviación típica 35. Visualiza una de estas imágenes.

n = 10;
imagenesRuidosas = [];
for i=1:n
    if i==1
        imagenesRuidosas = ruido_gaussiano(I,0,35);
    end
    aux = ruido_gaussiano(I,0,35);
    imagenesRuidosas = cat(3,imagenesRuidosas,aux);
end

figure, imshow(imagenesRuidosas(:,:,n))
%% 6).- Aplica un promediado a estas imágenes y observa la imagen resultante

[M,N] = size(I);
promedio = zeros(M,N);
for i=1:n
    promedio = promedio + double(imagenesRuidosas(:,:,i));
end
promedio = uint8(promedio/10);

figure, imshow(promedio), title('Imagen promedio')

figure, hold on 
    subplot(1,2,1), imshow(imagenesRuidosas(:,:,n)), title('Imagen ruidosa'),
    subplot(1,2,2), imshow(promedio), title('Imagen promedio'),
    hold off;
figure, sgtitle('Comparación imagenes ruidosa e imagen promedio'), hold on,
    plot(imagenesRuidosas(mitadM,:,n),'-r'), xlabel("Columna"), ylabel("Nivel de gris"),
    plot(promedio(mitadM,:),'-g'), legend("Imagen ruidosa","Imagen promedio"),
    hold off;
    
evaPromedio = funcion_evaluacion(I,imagenesRuidosas(:,:,n),promedio);
display(' ');
disp(['Evaluación de la imagen promedio: ' num2str(evaPromedio)]);
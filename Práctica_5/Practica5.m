%% ------------------------------------------------------
%   PRÁCTICA 5
% -------------------------------------------------------

clear all
clc
addpath("./funciones");

%% PRIMERA PARTE: Generación de imágenes. Análisis de perfiles de intensidad
% *************************************************************************

%% 1).- Leemos la imagen "P5.tif"
I = imread("./P5.tif");
Igray = rgb2gray(I);
Igauss = filtro_gaussiano(Igray,5,1);

figure, hold on
    subplot(3,1,1), imshow(I), title("Imagen normal"),
    subplot(3,1,2), imshow(Igray), title("Imagen intensidad"),
    subplot(3,1,3), imshow(Igauss), title("Imagen filtro gaussiano"),
    hold off;
    
[N M ~] = size(I);

perfil1 = round(0.25*N); perfil2 = round(0.50*N); perfil3 = round(0.75*N);

fila1 = perfil1*ones(1,M);
fila2 = perfil2*ones(1,M);
fila3 = perfil3*ones(1,M);

figure, hold on
    subplot(2,2,1), imshow(Igray), title('Imagen intensidad'),
        line(1:M,fila1,'color','r'), line(1:M,fila2,'color','g'), line(1:M,fila3,'color','b'),
    subplot(2,2,2), imshow(Igauss), title('Imagen filtro gaussiano'),
        line(1:M,fila1,'color','r'), line(1:M,fila2,'color','g'), line(1:M,fila3,'color','b'),
    hold off,
    subplot(2,2,3), hold on, plot(Igray(perfil1,:),'r'), plot(Igray(perfil2,:),'g'),
        plot(Igray(perfil3,:),'b'), axis([0 M 0 255]), title('Perfil de intensidad imagen de intensidad'),
    hold off,
    subplot(2,2,4), hold on, plot(Igauss(perfil1,:),'r'), plot(Igauss(perfil2,:),'g'),
        plot(Igauss(perfil3,:),'b'), axis([0 M 0 255]), title('Perfil de intensidad imagen suavizada'),
        
    hold off;

%% SEGUNDA PARTE: Implementación de algoritmo de detección de bordens basado
% en primera derivada
% *************************************************************************
%% 3).- Implementamos un detector de bordes basado en primera derivada


%% 4).- Aplicamos un detector de bordes de Sobel a la imagen de intensidad I
% utilizando la función anterior y considerando como umbrales el 10, 25, 50
% y 75% del valor máximo de la matriz magnitud del vector gradiente

Hx = [-1 0 1;-2 0 2;-1 0 1];
Hy = [-1 -2 -1;0 0 0;1 2 1];

[Gx Gy ModG] = Funcion_Calcula_Gradiente(Igray,Hx,Hy);

umbrales = [10;25;50;75];
maximo = max(ModG(:));

Igrayd = double(Igray);

for i=1:size(umbrales,1)
    % Comprobamos que valores de Gx y Gy superan el umbral
    BinGx = abs(Gx) > maximo*(umbrales(i)/100);
    BinGy = abs(Gy) > maximo*(umbrales(i)/100);
    BinMod = ModG > maximo*(umbrales(i)/100);
    
    UmbralGx = Igrayd.*BinGx;
    UmbralGy = Igrayd.*BinGy;
    UmbralMod = Igrayd.*BinMod;
    
    % Utilizamos mat2gray para tener todos los valores en el mismo rango
    ResultGx = mat2gray(UmbralGx,[min(UmbralMod(:)) max(UmbralMod(:))]);
    ResultGy = mat2gray(UmbralGy,[min(UmbralMod(:)) max(UmbralMod(:))]);
    ResultMod = mat2gray(UmbralMod,[min(UmbralMod(:)) max(UmbralMod(:))]);
    
    figure, hold on
        subplot(3,2,2), imshow(BinGx), title('Magnitud bordes verticales binarizados'),
        subplot(3,2,1), imshow(ResultGx), title('Gx - Magnitud para bordes verticales'),
        subplot(3,2,4), imshow(BinGy), title('Magnitud bordes horizontales binarizados'),
        subplot(3,2,3), imshow(ResultGy), title('Gy - Magnitud para bordes horizontales'),
        subplot(3,2,6), imshow(BinMod), title('Magnitud gradiente binarizada'),
        subplot(3,2,5), imshow(ResultMod), title('Mod - Magnitud gradiente'),
        
        sgtitle(['Valor umbral ' num2str(umbrales(i)) '%']);
        hold off;
end

%% 5).- Aplicamos un detector de bordes de Sobel a la imagen suavizada Igauss
% utilizando la función calcula gradiente y considerando como umbrales el 10, 25, 50
% y 75% del valor máximo de la matriz magnitud del vector gradiente

Hx = [-1 0 1;-2 0 2;-1 0 1];
Hy = [-1 -2 -1;0 0 0;1 2 1];

[Gx Gy ModG] = Funcion_Calcula_Gradiente(Igauss,Hx,Hy);

umbrales = [10;25;50;75];
maximo = max(ModG(:));

Igaussd = double(Igauss);

for i=1:size(umbrales,1)
    % Comprobamos que valores de Gx y Gy superan el umbral
    BinGx = Gx > maximo*(umbrales(i)/100);
    BinGy = Gy > maximo*(umbrales(i)/100);
    BinMod = ModG > maximo*(umbrales(i)/100);
    
    UmbralGx = Igaussd.*BinGx;
    UmbralGy = Igaussd.*BinGy;
    UmbralMod = Igaussd.*BinMod;
    
    % Utilizamos mat2gray para convertir los umbrales a valores binarios
    ResultGx = mat2gray(UmbralMod,[min(UmbralMod(:)) max(UmbralMod(:))]);
    ResultGy = mat2gray(UmbralMod,[min(UmbralMod(:)) max(UmbralMod(:))]);
    ResultMod = mat2gray(UmbralMod,[min(UmbralMod(:)) max(UmbralMod(:))]);
    
    figure, hold on
        subplot(3,2,2), imshow(BinGx), title('Magnitud bordes verticales binarizados'),
        subplot(3,2,1), imshow(ResultGx), title('Gx - Magnitud para bordes verticales'),
        subplot(3,2,4), imshow(BinGy), title('Magnitud bordes horizontales binarizados'),
        subplot(3,2,3), imshow(ResultGy), title('Gy - Magnitud para bordes horizontales'),
        subplot(3,2,6), imshow(BinMod), title('Magnitud gradiente binarizada'),
        subplot(3,2,5), imshow(ResultMod), title('Mod - Magnitud gradiente'),
        
        sgtitle(['Valor umbral ' num2str(umbrales(i)) '%']);
        hold off;
end

%% 6).- Genera una imagen binaria de bordes donde se detecten lo máximo posible las líneas
% blancas que delimitan la carretera y lo mínimo posible la línea horizontal correspondiente
% al horizonte de la imagen

% Tras comprobar todos los resultados en los 2 puntos anteriores, que mejor
% resultado nos da es la imagen BinMod

Hx = [-1 0 1;-2 0 2;-1 0 1];
Hy = [-1 -2 -1;0 0 0;1 2 1];
umbrales = [10;25;50;75];

[Gx Gy ModG] = Funcion_Calcula_Gradiente(Igauss,Hx,Hy);

maximo = max(ModG(:));
BinMod = ModG > maximo*(umbrales(4)/100);

figure, imshow(BinMod);

%% TERCERA PARTE: Detección de bordes mediante la función edge de MATLAB
% *************************************************************************
%% 7).- Usamos la función edge

% Imagen de intensidad
[IgraySobel,umbralgray] = edge(Igray,'sobel','nothinning');

nuevoUmbral = 0.4*umbralgray;

[IgraySobel2,umbralgray2] = edge(Igray,'sobel',nuevoUmbral,'nothinning');

[IgraySobel3,~] = edge(Igray,'sobel');
[IgraySobel4,~] = edge(Igray,'sobel',nuevoUmbral);

figure, hold on
    subplot(2,2,1), imshow(IgraySobel), title(['Detector Sobel Umbral: ' num2str(umbralgray)]),
    subplot(2,2,2), imshow(IgraySobel2), title(['Detector Sobel Umbral: ' num2str(umbralgray2)]),
    subplot(2,2,3), imshow(IgraySobel3), title(['Detector Sobel Adelgazada Umbral: ' num2str(umbralgray)]),
    subplot(2,2,4), imshow(IgraySobel4), title(['Detector Sobel Adelgazada Umbral: ' num2str(umbralgray2)]),
    hold off;

% Imagen suavizada


[IgaussSobel,umbralgauss] = edge(Igauss,'sobel','nothinning');

nuevoUmbral = 0.4*umbralgauss;

[IgaussSobel2,umbralgauss2] = edge(Igray,'sobel',nuevoUmbral,'nothinning');

[IgaussSobel3,~] = edge(Igauss,'sobel');
[IgaussSobel4,~] = edge(Igauss,'sobel',nuevoUmbral);

figure, hold on
    subplot(2,2,1), imshow(IgaussSobel), title(['Detector Sobel Umbral: ' num2str(umbralgauss)]),
    subplot(2,2,2), imshow(IgaussSobel2), title(['Detector Sobel Umbral: ' num2str(umbralgauss2)]),
    subplot(2,2,3), imshow(IgaussSobel3), title(['Detector Sobel Adelgazada Umbral: ' num2str(umbralgauss)]),
    subplot(2,2,4), imshow(IgaussSobel4), title(['Detector Sobel Adelgazada Umbral: ' num2str(umbralgauss2)]),
    hold off;
    
%% 8).- Usamos la función edge con el metodo Canny

umbralSuperior = umbralgray;
umbralInferior = nuevoUmbral;

[Icanny,umbralcanny] = edge(Igray,'Canny',[umbralInferior umbralSuperior]);
figure, imshow(Icanny)

%% 9).- Usamos la función edge con el metodo Laplaciana de la Gaussiana

[Ilapla, umbralLapla] = edge(Igray,'log');
figure, imshow(Ilapla)

[Ilapla2, umbralLapla2] = edge(Igray,'log',umbralLapla*6);
figure, imshow(Ilapla2)

%% ------------------------------------------------------
%   PRÁCTICA 7
% -------------------------------------------------------

clear all
clc
addpath("./ImagenesPractica/PrimeraParte");
addpath("./funciones");

%% PRIMERA PARTE: Implementación de correlación bidimensional normalizada
% *************************************************************************

%% 1).- Leemos la imagen "Imagen.tif" y "Plantilla.tif"

I = imread("Imagen.tif");
T = imread("Plantilla.tif");

figure, hold on
    subplot(1,2,1), imshow(I), title("Imagen"),
    subplot(1,2,2), imshow(T), title("Plantilla"),
    hold off;
    
%% 2).- Implementa una función que mida para cada píxel de la imagen de 
% entrada I la similitud entre los valores de su entorno de vencindad y la
% plantilla proporcionada T. El grado de similitud se cuantificará a través
% de la correlación cruzada normalizada.

%% 3).- Aplica la función funcion_NormCorr2 para localizar el punto de la imagen
% Imagen.tif que tiene la mayor semejanza con la plantilla dada por Plantilla.tif.

NC2 = funcion_NormCorr2(I,T);
[fY, fX] = find(NC2 == max(NC2(:)));

vM = size(T,1);
if rem(vM,2) == 0
    vM = vM - 1;
end
aM = floor(vM/2);

vN = size(T,2);
if rem(vN,2) == 0
    vN = vN - 1;
end
aN = floor(vN/2);

si = [fX-aN fY-aM]; % Esquina superior izquierda
sd = [fX+aN fY-aM]; % Esquina superior derecha

ii = [fX-aN fY+aM]; % Esquina inferior izquierda
id = [fX+aN fY+aM]; % Esquina inferior derecha

figure, hold on,
    imshow(NC2), title('Región de mayor semejanza'),
    line(si,sd,'Color','red'), % Línea arriba
    line(id,sd,'Color','red'), % Línea derecha
    line(ii,id,'Color','red'), % Línea abajo
    line(ii,si,'Color','red'), % Línea izquierda
    hold on, plot(fX,fY,'.r'), % Punto central
    hold off;
    
%% 4).- Repetir el apartado anterior utilizando la función de matlab normxcorr2

[NI MI]=size(I); % Filas y columnas de la imagen
[NT MT]=size(T); % Filas y columnas de la plantilla
   
ncc = normxcorr2(T,I); % Normalized cross correlation
[Nncc Mncc]=size(ncc);
% Observar las dimensiones de ncc. Hay que ajustar su tamaño para hacer
% coincidir la información de sus puntos con los píxeles de la imagen I
ncc=ncc(1+floor(NT/2):Nncc-floor(NT/2),1+floor(MT/2):Mncc-floor(MT/2)); 

[fY, fX] = find(ncc == max(ncc(:)));

vM = size(T,1);
if rem(vM,2) == 0
    vM = vM - 1;
end
aM = floor(vM/2);

vN = size(T,2);
if rem(vN,2) == 0
    vN = vN - 1;
end
aN = floor(vN/2);

si = [fX-aN fY-aM]; % Esquina superior izquierda
sd = [fX+aN fY-aM]; % Esquina superior derecha

ii = [fX-aN fY+aM]; % Esquina inferior izquierda
id = [fX+aN fY+aM]; % Esquina inferior derecha

figure, hold on,
    imshow(ncc), title('Región de mayor semejanza normxcorr2'),
    line(si,sd,'Color','red'), % Línea arriba
    line(id,sd,'Color','red'), % Línea derecha
    line(ii,id,'Color','red'), % Línea abajo
    line(ii,si,'Color','red'), % Línea izquierda
    hold on, plot(fX,fY,'.r'), % Punto central
    hold off;

%% 5).- Comparar los valores de correlación obtenidos mediante ambas funciones (función
% implementada funcion_NormCorr2 y función de matlab normxcorr2), considerando
% únicamente los valores de correlación calculados con un solapamiento total entre los
% valores de I y T

% Antes de comparar, debemos poner Cero los contornos de ncc donde no
% ha habido solapamiento total.
[NI MI]=size(I); % Filas y columnas de la imagen
[NT MT]=size(T); % Filas y columnas de la plantilla
ncc(1:floor(NT/2),:)=0; ncc(NI-floor(NT/2)+1:NI,:)=0;
ncc(:,1:floor(MT/2))=0; ncc(:,MI-floor(MT/2)+1:MI)=0;

[fpY fpX] = find(NC2 == max(NC2(:))); % funcion propia Y/X
[fmY fmX] = find(ncc == max(ncc(:))); % funcion matlab Y/X

figure, hold on,
    subplot(1,2,1), imshow(NC2), title(['Función propia - X=' num2str(fpX) ' Y=' num2str(fpY)]),
    hold on, plot(fpX,fpY,'.r'),
    subplot(1,2,2), imshow(ncc), title(['Función matlab - X=' num2str(fmX) ' Y=' num2str(fmY)]),
    hold on, plot(fmX,fmY,'.g'),
    hold off;
    
difMax = max(max(abs(NC2-ncc)));

% La orden de magnitud de la diferencia máxima es 0.1436

%% SEGUNDA PARTE: Ilustración de la correlación normalizada como descriptor  
% de similitud
% *************************************************************************

clear all
clc
addpath("./ImagenesPractica/SegundaParte");
addpath("./ImagenesPractica/SegundaParte/plantillas");
addpath("./funciones");

imagenes{1} = imread('1.bmp');
imagenes{2} = imread('2.bmp');

nombres = {'AlejandroB','AlejandroH','Carlos','Cesar','Daniel','Fran',...
    'Ihar','Ivan','Jesus','Jose','Manuel','Victor'}

for i=1:12
    plantillas{i} = imread([nombres{i} '.tif'])
end

for i=1:size(plantillas,2)
    for j=1:size(imagenes,2)
        
        I = rgb2gray(imagenes{j}); % Imagen 
        T = rgb2gray(plantillas{i}); % Plantilla

        [NI MI]=size(I); % Filas y columnas de la imagen
        [NT MT]=size(T); % Filas y columnas de la plantilla

        ncc = normxcorr2(T,I); % Normalized cross correlation
        [Nncc Mncc]=size(ncc);
        % Observar las dimensiones de ncc. Hay que ajustar su tamaño para hacer
        % coincidir la información de sus puntos con los píxeles de la imagen I
        ncc=ncc(1+floor(NT/2):Nncc-floor(NT/2),1+floor(MT/2):Mncc-floor(MT/2)); 


        [fY, fX] = find(ncc == max(ncc(:)));

        vM = size(T,1);
        if rem(vM,2) == 0
            vM = vM - 1;
        end
        aM = floor(vM/2);

        vN = size(T,2);
        if rem(vN,2) == 0
            vN = vN - 1;
        end
        aN = floor(vN/2);

%         si = [fX-aN fY-aM]; % Esquina superior izquierda
%         sd = [fX+aN fY-aM]; % Esquina superior derecha
%        
%         id = [fX+aN fY+aM]; % Esquina inferior derecha
%         ii = [fX-aN fY+aM]; % Esquina inferior izquierda
%         
%        
        selecX = [fX-aN fX+aN fX+aN fX-aN fX-aN];
        selecY = [fY-aM fY-aM fY+aM fY+aM fY-aM];
        
        figure, hold on,
            imshow(imagenes{j}), title(['Plantilla ' nombres{i} ' - Imagen ' num2str(j)]),
            line(selecX,selecY,'Color','red'),
            hold on, plot(fX,fY,'.r'), % Punto central
            hold off;
            
    end
end

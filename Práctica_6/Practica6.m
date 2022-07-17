%% ------------------------------------------------------
%   PRÁCTICA 6
% -------------------------------------------------------

clear all
clc
addpath("./funciones");
addpath("./ImagenesPractica/PrimeraParte");

%% PRIMERA PARTE: Segmentación de carreteras mediante la aplicación de la 
% Transformada de Hough para detectar líneas rectas
% **************************************************************************

%% 1).- Leemos la imagen "P6_1.tif"

I = imread('P6_1.tif');
Igray = rgb2gray(I);
[M, N] = size(Igray);
figure, imshow(Igray)


%% 2).- Genneramos una imagen binaria de bordes Ib usando un detector Sobel

Hx = [-1 0 1;-2 0 2;-1 0 1];
Hy = [-1 -2 -1;0 0 0;1 2 1];

[Gx Gy ModG] = Funcion_Calcula_Gradiente(Igray,Hx,Hy);

% Consideramos el 30% del valor máximo ded la matriz magnitud del vector
% gradiente obtenida

maximo = max(ModG(:));
umbral = 0.3;

% Para detectar borde verticales usamos Gx
Ib = abs(Gx) > maximo*umbral;

figure, hold on
    subplot(2,1,1), imshow(Igray), title('Imagen de intensidad'),
    subplot(2,1,2), imshow(Ib), title('Imagen de bordes'),
    hold off;

%% 3).- Aplicamos a Ib la Transformada de Hough para detectar líneas rectas
% utilizando la función de matlab hough

[H,theta,rho] = hough(Ib);

% ¿Qué representa theta y rho?
% ----------------------------
% Theta representa el ángulo en grados entre el eje y el vector. Mientras
% que rho representa la distancia desde el origen hasta la línea a lo largo
% de un vector perpendicular a la línea

% ¿Cuál es el significado de los valores almacenados en H?
% --------------------------------------------------------
% H es la matriz de transformación de Hough, en la cual cada celda es un
% acumulador iniciado a cero. A continuación, para cada punto que no sea de
% fondo de la imagen, se obtendrá el valor rhotheta más cercano a la línea

%% ¿Cómo es la discretización que se realiza del espacio de parámetros en 
% esta configuración por defecto?
% -------------------------------------------------------------------------
% Los valores de theta comprendidos en tre -90º <= 0 < 90º. Mientras que
% rho son -maximarho hasta maximarho

%% Ayudandote de la función de Matlab find, escibe la ecuación de la recta 
% que pasa por más puntos de la imagen binaria Ib

[n m] = find(H == max(H(:))); % n para saber el valor de rho y m para el de theta

vtheta = theta(m);
vrho = rho(n);

display('');
display(['Ecuación solicitada: ' num2str(vrho) ' = x*cos(' num2str(vtheta) ') + y*sin(' num2str(vtheta) ')']);

%% 4).- Encuentra los parámetros representativos de las 5 rectas más votadas
NumRectas = 5; Umbral = ceil(0.3*max(H(:)));
P = houghpeaks(H,NumRectas,'threshold',Umbral);

%% ¿Qué información contiene el parámetro de salida P?
% Contiene las coordenadas de la fila y columna de los picos de la
% transformacion de Hough

%% ¿Qué significado tiene la inclusión del parámetro de entrada Umbral en la función?
% Representa el valor mínimo que se debe considerar un pico, especificado
% como un número escalar no negativo

%% ¿Qué efecto tiene en los resultados finales fijar Umbral con un valor
% ceil(0.5*max(H(:)))?
Umbral = ceil(0.5*max(H(:)));
P = houghpeaks(H,NumRectas,'threshold',Umbral);
% Si aumentamos el umbral a la mitad del valor máximo que tiene un punto
% rhotheta solo encontrara dos puntos como resultado

%% 5).- Muestra los segmentos de puntos de Ib que incluyen las 5 rectas detectadas
lines = houghlines(Ib,theta,rho,P,'FillGap',5,'MinLength',7);
figure, imshow(Ib), hold on
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % Determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

%% ¿Qué información contiene la variable lines?
% Líneas encontradas, devueltas como una matriz de estructura cuya longitud
% es igual al número de segmentos de línea combinados encontrados

%% ¿Qué significado tienen las opciones elegidas en la llamada de la función
% "'FillGap',5,'MinLength',7"?
% FillGap es la distancia entre dos segmentos de línea asociados con la
% misma ubiacación de transformación Hough, especificada como un escalar
% real positivo. Tiene como valor predeterminado 20, mientras que en el
% ejercicio hemos usado 5
% MinLength es la longitud mínima de la línea, especificada como un escalar
% real positivo. Descarta las líneas que son más cortas que el valor
% especificado, en nuestro ejemplo 7. Por defecto 40

%% 6).- A partir de la información obtenida en los pasos anteriores, 
% realiza la segmentación de la carretera siguiendo los siguiente pasos


% Sobre una imagen binaria inicializada a 1 (inicialmente "blanca") de las mismas
% dimensiones que la imagen de intensidad original, asigna un valor 0 a todos los
% píxeles presentes en las rectas detectadas en P. Visualiza la imagen binaria
% resultante

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

% Aplica un filtro de mínimos 3x3 a la imagen binaria anterior para unir los puntos de
% las líneas detectadas y delimitar regiones candidatas a ser la zona principal de la
% carretera. Visualiza la imagen binaria resultante.
Ifilt = Funcion_FiltroMinimos(Ibin);
figure, imshow(Ifilt);

% Genera y visualiza la imagen binaria que representa la segmentación de la carretera
% asumiendo que es la región que contiene al píxel central de la imagen.
Ilabel = bwlabel(Ifilt);

xCentro = floor(M/2);
yCentro = floor(N/2);
labelCentro = Ilabel(xCentro, yCentro);

IbinCarretera = Ilabel == labelCentro;
figure, imshow(IbinCarretera)

% Visualiza el resultado a través de una imagen que muestre únicamente los valores
% de intensidad de los píxeles detectados (el resto de los píxeles se visualizarán en
% negro)
R = I(:,:,1); G = I(:,:,2); B = I(:,:,3); 
Icarretera = uint8(IbinCarretera.*double(R));
Icarretera = cat(3,Icarretera,IbinCarretera.*double(G));
Icarretera = cat(3,Icarretera,IbinCarretera.*double(B));
figure, imshow(Icarretera)

figure, hold on
        subplot(2,3,1), imshow(I), title('Imagen original'),
        subplot(2,3,2), imshow(Igray), title('Imagen de intensidad'),
        subplot(2,3,3), imshow(Ib), title('Imagen de bordes'),
        subplot(2,3,4), imshow(Ifilt), title('Representacion de las rectas'),
        subplot(2,3,5), imshow(IbinCarretera), title('Seccion de carretera binaria'),
        subplot(2,3,6), imshow(Icarretera), title('Seccion de carretera a color'),
        hold off;

%% 7).- Aplica todos los pasos anteriores, con idéntica configuración, para 
% segmentar las imágenes P6_2.tif y P6_3.tif, incluidas en la carpeta 
% facilitada: ImagenesPractica/PrimeraParte

addpath('./ImagenesPractica/PrimeraParte')
I2 = imread('P6_2.tif');
I3 = imread('P6_3.tif');

Funcion_DetectaBordes(I);
Funcion_DetectaBordes(I2);
Funcion_DetectaBordes(I3);

%% SEGUNDA PARTE:  Segmentación de señales de tráfico mediante la aplicación de la
% Transformada de Hough para detectar circunferencias.
% **************************************************************************

clear
clc
addpath("./funciones");
addpath("./Funciones_THCircular");
addpath("./ImagenesPractica/SegundaParte");

%% 8).- Genera y visuzaliza una imagen binaria Ib a partir de Signal_1.tif

I = imread('Signal1_1.tif');
figure, imshow(I)

R = I(:,:,1); G = I(:,:,2); B = I(:,:,3); 
Rmin = min(R(:)); Rmax = max(R(:));
Gmin = min(G(:)); Gmax = max(G(:));
Bmin = min(B(:)); Bmax = max(B(:));

factor = 0.35;
UmbralRojo = factor*(Rmin+Rmax);
UmbralVerde = factor*(Gmin+Gmax);
UmbralAzul = factor*(Bmin+Bmax);

Ir = R >= UmbralRojo;
Ig = G < UmbralVerde;
Ia = B < UmbralAzul;

Ib = (Ir & Ig & Ia);
figure, hold on,
    subplot(1,2,1), imshow(I), title('Imagen original'),
    subplot(1,2,2), imshow(Ib), title('Imagen binaria de puntos rojos'),
    hold off;

%% 9).- Aplica a Ib la Transformada de Hough para detectar contornos circulares

radii = 5:2:35; % Radios posibles de las circunferencias buscadas.
% Todas las imágenes tienen la misma resolución. Conocimiento a priori:
% los objetos circulares buscados tienen sus radios limitados en ese
% rango.
H = circle_hough(Ib, radii, 'same');
% Opción 'same': los centros de las circunferencias buscadas deben ser
% puntos de la imagen, no se permiten circunferencias cuyos centros se
% sitúan fuera de la imagen.

%% Interpreta las dimensiones de la matriz de salida H. ¿Cuál es el significado de los
% valores almacenados en dicha matriz?
% H devuelve una matriz con 3 componentes, donde las 2 primeras son el
% centro de una circunferencia dados por x e y. Y la tercera, su radio.
% En cada posición enonctramos el número de votos de cada curva

%% Ayudándote de la función de Matlab find , escribe la ecuación de la circunferencia
% que pasa por más puntos en la imagen binaria Ib, especificando su radio y las
% coordenadas (x,y) de su centro. ¿Cuántos puntos de Ib contiene esta
% circunferencia?
maxIb = max(H(:));
[a b r] = find(H == maxIb);

display(['(x-' num2str(b) ')^2 + (y-' num2str(a) ')^2 = ' num2str(radii(r)) '^2'])

%% 10).- Encuentra los parámetros representativos de la circunferencia más votada aplicando la
% función facilitada circle_houghpeaks

P = circle_houghpeaks(H, radii,'npeaks',1);

%% ¿Qué información contiene el parámetro de salida P?
% Un vector con las caracteristicas de la circunferencia más votada: x, y, 
% radio y el número de curvas que pasan por ese punto

%% 11).- A partir de la información contenida en P, genera una imagen binaria, Ib_circunf

xCentro = P(2);
yCentro = P(1);
r = P(3);
numVotos = P(4);

[y x] = circlepoints(r); % genera las coordenadas (x,y) que pertenecen a
% la circunferencia de radio r y centro en el origen del sistema de
% coordenadas (0,0)
[M N] = size(I(:,:,1));
Ib_circunf = false(M,N);
for i=1:length(y)
   Ib_circunf(xCentro+x(i),yCentro+y(i)) = true; 
end
    
figure ,hold on
    subplot(1,2,1), imshow(I), title('Imagen original')
    subplot(1,2,2), imshow(Ib_circunf), title('Circunferencia detectada')
    hold off
    
%% 12).-  Genera y visualiza la imagen binaria que representa la segmentación de la señal de
% tráfico, Ib_circulo   
Ib_circulo = imfill(Ib_circunf,'holes');

Icirculo = uint8(zeros(M,N,3));
Icirculo(:,:,1) = Ib_circulo.*double(R);
Icirculo(:,:,2) = Ib_circulo.*double(G);
Icirculo(:,:,3) = Ib_circulo.*double(B);

figure ,hold on
    subplot(1,3,1), imshow(Ib_circulo), title('Circunferencia detectada binaria')
    subplot(1,3,2), imshow(Icirculo), title('Circunferencia detectada')
    subplot(1,3,3), imshow(I), title('Imagen original')
    hold off
    
%% 13).- Aplica todos los pasos anteriores, con idéntica configuración, para segmentar las señales
% de limitación de velocidad presentes en las imágenes Signal1_2.tif , Signal1_3.tif
% , Signal1_4.tif , Signal2_1.tif , Signal2_2.tif , Signal3_1.tif y
% Signal3_2.tif, facilitadas en la carpeta ImagenesPractica/SegundaParte.

% Imagen 1
I1_2 = imread('Signal1_2.tif');
Funcion_DetectaSenal(I1_2,'rojo');
I1_3 = imread('Signal1_3.tif');
Funcion_DetectaSenal(I1_3,'rojo');
I1_4 = imread('Signal1_4.tif');
Funcion_DetectaSenal(I1_4,'rojo');

% Imagen 2
I2_1 = imread('Signal2_1.tif');
Funcion_DetectaSenal(I2_1,'rojo');
I2_2 = imread('Signal2_2.tif');
Funcion_DetectaSenal(I2_2,'rojo');

% Imagen 3
I3_1 = imread('Signal3_1.tif');
Funcion_DetectaSenal(I3_1,'rojo');
I3_2 = imread('Signal3_2.tif');
Funcion_DetectaSenal(I3_2,'rojo');

%% 14).- Genera y visualiza la imagen binaria que representa la segmentación de la señal de tráfico
% presente en las imágenes "Signal4_1.tif y Signal4_2.tif" facilitadas en la carpeta
% ImagenesPractica/SegundaParte

I4_1 = imread('Signal4_1.tif');
figure, imshow(I4_1)

% Modificamos detecta señal para que detecte el azul en lugar del rojo
Funcion_DetectaSenal(I4_1,'azul');
I4_2 = imread('Signal4_2.tif');
Funcion_DetectaSenal(I4_2,'azul');

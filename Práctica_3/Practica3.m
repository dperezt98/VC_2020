%% ------------------------------------------------------
%   PRÁCTICA 3
% -------------------------------------------------------

clear 
clc

addpath("./funciones");
I = imread("./P3.tif");
[M,N] = size(I);
Id = double(I);

%% PRIMERA PARTE: Manipulación de contraste mediante transformaciones locales
% ***************************************************************************

% Veamos como es la imagen
figure, hold on,
    subplot(1,2,1), imshow(I), title("Función Raiz Cuadrada - Brillo: "...
    + num2str(calculaBrillo(I)) + " | Varianza: " + num2str(calculaVarianza(I))...
    + " - Pmin: " + num2str(min(I(:))) + " - Pmax: " + num2str(max(I(:)))),
    subplot(1,2,2), imhist(I), title("Función Raiz Cuadrada - Brillo: "...
    + num2str(calculaBrillo(I)) + " | Varianza: " + num2str(calculaVarianza(I))...
    + " - Pmin: " + num2str(min(I(:))) + " - Pmax: " + num2str(max(I(:))));

%% 1).- Obtenemos distintas imágenes de salida resultados de la aplicación de las
% siguientes transformaciones locales de manipulaución de contraste

% - Amplitud de Contraste
IamplitudContraste = amplitudContraste(I,[0,255]);

% - Funciones Cuadrada y Cúbica
IfuncionCuadrada = funcionCuadradaContraste(I);
IfuncionCubica = funcionCubicaContraste(I);

% - Funciones Raíz Cuadrada y Raíz Cúbica
IfuncionRaizCuadrada = funcionRaizCuadradaContraste(I);
IfuncionRaizCubica = funcionRaizCubicaContraste(I);

% - Funciones Sigmoide (con alpha=0.85)
alpha = 0.85; 
IfuncionSigmoide = funcionSigmoideContraste(I,alpha);
IfuncionSigmoideIntermedio = IfuncionSigmoide(:,:,1);
IfuncionSigmoideExtremo = IfuncionSigmoide(:,:,2);


%% 2).- Para cada una de las imagenes, medir el brillo y el contraste.
% Además de visualizar su histograma

% - Amplitud de Contraste
IamplitudContrasteBri = calculaBrillo(IamplitudContraste);
IamplitudContrasteVar = calculaVarianza(IamplitudContraste);
figure, hold on, 
    subplot(1,2,1), imshow(IamplitudContraste), title("Amplitud de Contraste - Brillo: "...
    + num2str(IamplitudContrasteBri) + " | Varianza: " + num2str(IamplitudContrasteVar)),
    subplot(1,2,2), imhist(IamplitudContraste), title("Amplitud de Contraste - Brillo: "...
    + num2str(IamplitudContrasteBri) + " | Varianza: " + num2str(IamplitudContrasteVar));

% - Funciones Cuadrada y Cúbica
IfuncionCuadradaBri = calculaBrillo(IfuncionCuadrada);
IfuncionCuadradaVar = calculaVarianza(IfuncionCuadrada);

IfuncionCubicaBri = calculaBrillo(IfuncionCubica);
IfuncionCubicaVar = calculaVarianza(IfuncionCubica);

figure, hold on
    subplot(2,2,1) , imshow(IfuncionCuadrada), title("Función Cuadrada - Brillo: "...
    + num2str(IfuncionCuadradaBri) + " | Varianza: " + num2str(IfuncionCuadradaVar)),
    subplot(2,2,2) , imshow(IfuncionCubica), title("Función Cúbica - Brillo: "...
    + num2str(IfuncionCubicaBri) + " | Varianza: " + num2str(IfuncionCubicaVar)),
    subplot(2,2,3) , imhist(IfuncionCuadrada), title("Función Cuadrada - Brillo: "...
    + num2str(IfuncionCuadradaBri) + " | Varianza: " + num2str(IfuncionCuadradaVar)),
    subplot(2,2,4) , imhist(IfuncionCubica), title("Función Cúbica - Brillo: "...
    + num2str(IfuncionCubicaBri) + " | Varianza: " + num2str(IfuncionCubicaVar)), hold off;

% - Funciones Raíz Cuadrada y Raíz Cúbica
IfuncionRaizCuadradaBri = calculaBrillo(IfuncionRaizCuadrada);
IfuncionRaizCuadradaVar = calculaVarianza(IfuncionRaizCuadrada);

IfuncionRaizCubicaBri = calculaBrillo(IfuncionRaizCubica);
IfuncionRaizCubicaVar = calculaVarianza(IfuncionRaizCubica);

figure, hold on
    subplot(2,2,1) , imshow(IfuncionRaizCuadrada), title("Función Raiz Cuadrada - Brillo: "...
    + num2str(IfuncionRaizCuadradaBri) + " | Varianza: " + num2str(IfuncionRaizCuadradaVar)),
    subplot(2,2,2) , imshow(IfuncionRaizCubica), title("Función Raiz Cúbica - Brillo: "...
    + num2str(IfuncionRaizCubicaBri) + " | Varianza: " + num2str(IfuncionRaizCubicaVar)),
    subplot(2,2,3) , imhist(IfuncionRaizCuadrada), title("Función Raiz Cuadrada - Brillo: "...
    + num2str(IfuncionRaizCuadradaBri) + " | Varianza: " + num2str(IfuncionRaizCuadradaVar)),
    subplot(2,2,4) , imhist(IfuncionRaizCubica), title("Función Raiz Cúbica - Brillo: "...
    + num2str(IfuncionRaizCubicaBri) + " | Varianza: " + num2str(IfuncionRaizCubicaVar)), hold off;

% - Funciones Sigmoide (con alpha=0.85)
IfuncionSigmoideIntermedioBri = calculaBrillo(IfuncionSigmoideIntermedio);
IfuncionSigmoideIntermedioVar = calculaVarianza(IfuncionSigmoideIntermedio);

IfuncionSigmoideExtremoBri = calculaBrillo(IfuncionSigmoideExtremo);
IfuncionSigmoideExtremoVar = calculaVarianza(IfuncionSigmoideExtremo);

figure, hold on
    subplot(2,2,1) , imshow(IfuncionSigmoideIntermedio), title("Función Sigmoide1 - Brillo: "...
    + num2str(IfuncionSigmoideIntermedioBri) + " | Varianza: " + num2str(IfuncionSigmoideIntermedioVar)),
    subplot(2,2,2) , imshow(IfuncionSigmoideExtremo), title("Función Sigmoide2 - Brillo: "...
    + num2str(IfuncionSigmoideExtremoBri) + " | Varianza: " + num2str(IfuncionSigmoideExtremoVar)),
    subplot(2,2,3) , imhist(IfuncionSigmoideIntermedio), title("Función Sigmoide Intermedio - Brillo: "...
    + num2str(IfuncionSigmoideIntermedioBri) + " | Varianza: " + num2str(IfuncionSigmoideIntermedioVar)),
    subplot(2,2,4) , imhist(IfuncionSigmoideExtremo), title("Función Sigmoide Estremo - Brillo: "...
    + num2str(IfuncionSigmoideExtremoBri) + " | Varianza: " + num2str(IfuncionSigmoideExtremoVar)), hold off;

%% 3).- Realizar un breve informe de conslusiones

% - Amplitud de contraste: A la imagen no se le puede realzar el contraste
% porque ya esta entre los valores [0,255]. Se podría contraer

% - Funciones Cuadrada y Cúbica: la imagen tiende a oscurecerse, los
% píxeles oscuros de la imagen disminuyen su contraste. Se aumenta el
% contrastes de los píxeles claros

% - Funciones Raiz Cuadrada y Raiz Cúbica: la imagen tiende a aclarse, los
% píxeles claros de la imagen disminuyen su contraste. Se aumenta el
% contraste de los píxeles oscuros

% - Función Sigmoide: Se favorecen niveles claros en perjuicio de los
% oscuros o viceversa. La función q1 empleada favorece valores intermedios
% respecto a los más claros y oscuros. La función q2 empleada favorece
% vlaores extremos respecto a los intermedios.


%% SEGUNDA PARTE: Ecualización uniforme o igualación de histograma
% ***************************************************************************

%% 4).- Implementar la funcion: H = funcion_HistAcum(h)
% Hagamos un ejemplo sencillo
% h = [2 4 4 4 6 5 0 0 0 0]
% H = funcion_HistAcum(h)

%% 5).- Implementar la funcion: Ieq = funcion_EcualizaImagen(I,modo)

% Modos de la función
%-1: Implementación píxel a píxel de la imagen y calcular la función de
%transformación para cada píxel para generar la imagen de salida
%-2: Realizar el cálculo de la función de transformaicón para cada nivel de
%gris posible y, recorriendo la imagen píxel a píxel, aplicarla para
%generar la imagen de salida.
%-3: Realizar el cálculo de la función de transformación para cada nivel de
%gris posible y, haciendo barrido en los 256 posibles nivels de gris,
%aplicarla para generar la imagen de salida.

Ieq1 = funcion_EcualizaImagen(I,1);
Ieq2 = funcion_EcualizaImagen(I,2);
Ieq3 = funcion_EcualizaImagen(I,3);
figure, hold on
    subplot(1,3,1), imshow(Ieq1), title("Modo 1"),
    subplot(1,3,2), imshow(Ieq2), title("Modo 2"),
    subplot(1,3,3), imshow(Ieq3), title("Modo 3"), hold off;


%% 6).- Aplicar las funciones anterioes para ecualizar la imagen P3.tif y  
% medir su tiempo computacional

tiempo = [0 0 0];

tic
Ieq1 = funcion_EcualizaImagen(I,1);
tiempo(1) = toc;

tic
Ieq2 = funcion_EcualizaImagen(I,2);
tiempo(2) = toc;

tic
Ieq3 = funcion_EcualizaImagen(I,3);
tiempo(3) = toc;

tiempo

%% 7).- Realizar una ecualización unifroma zonal a la imagen P3.tif. Para ello 
% se ha de dividir la imagen en 9 subimágenes de las mismas dimensiones y
% aplicar la función del apartado anterior a cada una de ellas

[M,N] = size(I);
partes = 9; parte = 3;
Mparte = round(M/parte); Nparte = round(N/parte); 

Ieq = uint8(zeros(M,N));
prinM = 1; prinN = 1;
finM = 0; finN = 0;

for i=1:parte
    finM = Mparte*i;
    if i == parte && Mparte*i ~= M % Comprobamos que se coja la última fila de la imagen
        finM = M;
    end
    
    for j=1:parte
        finN = Nparte*j;
        if j == parte && Nparte*j ~= N % Comprobamos que se coja la última columna de la imagen
            finN = N;
        end  
        
        selec = I(prinM:finM,prinN:finN);
        Ieq(prinM:finM,prinN:finN) = funcion_EcualizaImagen(selec,2);
        prinN = prinN + Nparte;
    end
    
    prinN = 1;
    prinM = prinM + Mparte;
end

figure, hold on,
    subplot(1,2,1), imshow(I), title("Imagen Normal"),
    subplot(1,2,2), imshow(Ieq), title("Ecualización Uniforme Zonal"), hold off;
    
    
%% 8).- Implementar la función: funcion_EcualizacionLocal(I,NumFilVent,NumColVent,OpcionRelleno)
% donde I es la imagen de entrada, NumFilVent son el número de filas que
% tendrá la ventana a utilizar y NumColVent el número de columnas. Y la
% opción de relleno permitirá aplicar "symetric", "replicate" o "zeros"
% como opciones de relleno a todos aquellos píxeles que no existen en la
% imagen, pero puedan incluirse en el entorno ded vencidad de los píxeles
% del o cercanos al contorno de la imagen.

%% 9).- Aplicar esta función para exualizar la imagen P3.tif considerando el siguiente tamaño de 
% ventana de vecindad: NumFilVent = 1/3 del número de filas de la imagen ; 
% NumColVent = 1/3 del número de columnas de la imagen.

Ieq_local = funcion_EcualizaLocal(I,M/3,N/3,"symmetric");
figure, imshow(Ieq_local)

%% 10).- Implementar una nueva versión de la función funcion_EcualizaLocal en la que no se calcula
% una ecualización individual y específica para cada píxel. En esta
% versión, la ecualización se deberá calcular por ventanas de 5x5

%% 11).- Compara la efeciencia computacional de las dos versiones de la función

tiempo = [0 0];

tic
Ieq1 = funcion_EcualizaLocal(I,M/3,N/3,"symmetric");
tiempo(1) = toc;

tic
Ieq2 = funcion_EcualizaLocalV2(I,M/3,N/3,"symmetric");
tiempo(2) = toc;

tiempo

figure, hold on
    subplot(2,2,1), imshow(Ieq1), title("funcionEcualizaLocal - " + num2str(tiempo(1) + "s")),
    subplot(2,2,2), imshow(Ieq2), title("funcionEcualizaLocalV2 - " + num2str(tiempo(2) + "s")),
    subplot(2,2,3), imhist(Ieq1), title("funcionEcualizaLocal)"),
    subplot(2,2,4), imhist(Ieq2), title("funcionEcualizaLocalV2"), hold off;


%% 12).- Para cada una de las imágenes generadas en esta segunda parte de la
% práctica, medir el brillo y el contraste. Además de mostrar su histograma


%% 13).- Utilizando como referencia los correspondientes a las componentes 
% roja, verde y azul de la imagen ColorPatron.tif, aplicar la función de
% transformación proporcionada por la función de matlab para uniformizar el
% color de las imágenes Color1.tif, Color2.tif, Color3.tif y Color4.tif.
% Unicamente debe considerarse la información de los píxeles de la retina.

I2 = imread("ColorPatron.bmp");

% Calculamos la máscara que vamos a usar

umbral = 150;
Ib = funcion_mascaraUmbral(I2,umbral);
R = I2(:,:,1); G = I2(:,:,2); B = I2(:,:,3); 

histR = imhist(R(Ib)); histG = imhist(G(Ib)); histB = imhist(B(Ib));
h_patron = [histR histG histB];

figure, imshow(Ib)

numeroImagenes = 4;
imagenes = [];
imagenesEq = [];
Ieq = [];

for i=1:numeroImagenes
    nI = imread("Color" + num2str(i) + ".bmp");
    Ibi = funcion_mascaraUmbral(nI,150);
        
    for j=1:3
       color = nI(:,:,j);
       [Ioutput T] = histeq(color(Ib),h_patron(:,j));
       
       %Actualizamos la imagen
       color(Ib) = Ioutput;
       if j==1
           Ieq = color;
       else
           Ieq = cat(3,Ieq,color);
       end 
    end
    
    if i==1
        imagenes = nI;
        imagenesEq = Ieq;
    else
        imagenes = cat(4,imagenes,nI);
        imagenesEq = cat(4,imagenesEq,Ieq);
    end
    
    Ieq = [];
end

%% 14).- Representamos los histogramas de los canales rodo, verde y azul de
% la imagen patrón. Hacemos lo mismo para las imágenes originales de
% entrada al proceso y para las de salida que han sido especificadas

figure, hold on
    subplot(1,3,1), imhist(I2(:,:,1)), title("Hist. R"),
    subplot(1,3,2), imhist(I2(:,:,2)), title("Hist. G"),
    subplot(1,3,3), imhist(I2(:,:,3)), title("Hist. B"), hold off;

% Mostramos las imagenes ecualizadas y sus histogramas
for i=1:numeroImagenes
    %Vemos el histograma de la imagen ecualizada por canaler
    figure, hold on
        subplot(3,3,1), imhist(I2(:,:,1)), title("ColorPatron - Canal R"),
        subplot(3,3,2), imhist(I2(:,:,2)), title("ColorPatron - Canal G"),
        subplot(3,3,3), imhist(I2(:,:,3)), title("ColorPatron - Canal B"), 
        subplot(3,3,4), imhist(imagenes(:,:,1,i)), title("Color" + num2str(i) + ".bmp - Canal R"),
        subplot(3,3,5), imhist(imagenes(:,:,2,i)), title("Color" + num2str(i) + ".bmp - Canal G"),
        subplot(3,3,6), imhist(imagenes(:,:,3,i)), title("Color" + num2str(i) + ".bmp - Canal B"),
        subplot(3,3,7), imhist(imagenesEq(:,:,1,i)), title("Color" + num2str(i) + ".bmp Eq. - Canal R"),
        subplot(3,3,8), imhist(imagenesEq(:,:,2,i)), title("Color" + num2str(i) + ".bmp Eq. - Canal G"),
        subplot(3,3,9), imhist(imagenesEq(:,:,3,i)), title("Color" + num2str(i) + ".bmp Eq. - Canal B"), hold off;
        
    % Mostramos la imagen ecualizada y su histograma general
    figure, hold on
        subplot(2,3,1), imshow(imagenes(:,:,:,i)), title("Color" + num2str(i) + ".bmp"),
        subplot(2,3,2), imshow(imagenesEq(:,:,:,i)), title("Color" + num2str(i) + ".bmp Ecualizada"),
        subplot(2,3,3), imshow(I2), title("ColorPatron.bmp"),
        subplot(2,3,4), imhist(imagenes(:,:,:,i)), title("Color" + num2str(i) + ".bmp Hist."),
        subplot(2,3,5), imhist(imagenesEq(:,:,:,i)), title("Color" + num2str(i) + ".bmp Ecualizada Hist."),
        subplot(2,3,6), imhist(I2), title("ColorPatron Hist."), hold off;
end

close all

%% 15).- Breve informe de consclusiones

% Habiendo aplicado el ecualizado las imágenes con la imagén patrón, hemos
% obtenido para cada imagen un canal ajustado al histograma de original.
% Obteniendo así, imagenes con la misma tonalidad de colores que la
% original


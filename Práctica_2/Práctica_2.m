%% PRÁCICA 2

%% ***********************************************************************
%% =======================================================================
%% ETAPA 1
%% =======================================================================
%% ***********************************************************************

addpath('./Material_Imagenes/01_MuestrasColores')

numeroImagenes = 3;
CC = [255 128 64 32]; % Codificación utilizada para distinguir las distintas
                      % muestras de color en las imágenes de segmetación

% Inicializamos las variables
ValoresColores = [];
ValoresColoresNormalizados = [];
CodifValoresColores = [];
                      
for i=1:numeroImagenes
    
    foto = ['Color' num2str(i) '.jpeg'];
    fotoMuestra = ['Color' num2str(i) '_MuestraColores.tif'];
    I = imread(foto);
    Im = imread(fotoMuestra);
    
    
    
    % HACEMOS LA CONVERSIÓN DE LA IMAGEN A LOS DISTINTOS FORMATOS CON LOS QUE
    % VAMOS A TRABAJAR
    I = double(I);
    I_RGB = I; % Imagen en RGB
    I_HSV = rgb2hsv(I); % Convertimos imagen en RGB a HSI
    I_CIE = rgb2lab(I); % Convertimos la imagen en RGB a CIE Lab

    R = I_RGB(:,:,1);
    G = I_RGB(:,:,2);
    B = I_RGB(:,:,3);
    %Normalizamos RGB - Valores de 0 a 256
    codifR = R/255; codifG = G/255; codifB = B/255; 

    H = I_HSV(:,:,1);
    S = I_HSV(:,:,2);
    I = (R + G + B)/3;
    %Normalizamos HSI - H y S ya están normalizados
    codifH = H; codifS = S; codifI = I/255;

    Y = (0.299*codifR) + (0.587*codifG) + (0.114*codifB);
    U = 0.492*(codifB-Y);
    V = 0.877*(codifR-Y);
    %YUV ya está normalizado
    codifY = mat2gray(Y,[0,1]); codifU = mat2gray(U,[-1,1]); codifV = mat2gray(V,[-1,1]);


    L = I_CIE(:,:,1);
    a = I_CIE(:,:,2);
    b = I_CIE(:,:,3);
    %Normalizamos Lab con la función mat2gray
    codifL = mat2gray(L,[0,100]); codifa = mat2gray(a,[-128 127]); 
    codifb = mat2gray(b,[-128 127]); 
    
    
    for j=1:size(CC,2)
        Ib = Im == CC(j);
        nPixeles = sum(Ib(:));
        ValoresColores = [ValoresColores; R(Ib) G(Ib) B(Ib) H(Ib) S(Ib) I(Ib)... 
                                          Y(Ib) U(Ib) V(Ib) L(Ib) a(Ib) b(Ib)];
        ValoresColoresNormalizados = [ValoresColoresNormalizados; codifR(Ib) codifG(Ib)...
                                        codifB(Ib) codifH(Ib) codifS(Ib) codifI(Ib)...
                                        codifY(Ib) codifU(Ib) codifV(Ib) codifL(Ib)... 
                                        codifa(Ib) codifb(Ib)];
        CodifValoresColores = [CodifValoresColores; CC(j)*ones(nPixeles,1)];
    end
end

% Corregimos el valor de H para los valores menores a 0.5 y mayores a 0.5
menor = ValoresColores(:,4) <= 0.5;
mayor = ValoresColores(:,4) > 0.5;
ValoresColores(menor,4) = 1 - 2*ValoresColores(menor,4);
ValoresColores(mayor,4) = 2 * (ValoresColores(mayor,4)-0.5);

% Actualizamos también los valores de los normalizados
ValoresColoresNormalizados(:,4) = ValoresColores(:,4);

%% =======================================================================
%% REPRESENTAMOS LOS PÍXELES SELECCIONADOS
%% =======================================================================

nColoresSegmentados = 4;
colores = {'.r' '.g' '.b' '.k'};
nombreDescriptores{1} = 'R';
nombreDescriptores{2} = 'G';
nombreDescriptores{3} = 'B';
nombreDescriptores{4} = 'Hmod';
nombreDescriptores{5} = 'S';
nombreDescriptores{6} = 'I';
nombreDescriptores{7} = 'Y';
nombreDescriptores{8} = 'U';
nombreDescriptores{9} = 'V';
nombreDescriptores{10} = 'L';
nombreDescriptores{11} = 'a';
nombreDescriptores{12} = 'b';

%% GRÁFICA RGB
espacioCcas = [1 2 3];
figure, hold on
for i=1:nColoresSegmentados
    % Tomamos los valores representativos de cada grupo de píxeles 
    selecPixeles = CodifValoresColores == CC(i);
    valoresR = ValoresColores(selecPixeles,espacioCcas(1));
    valoresG = ValoresColores(selecPixeles,espacioCcas(2));
    valoresB = ValoresColores(selecPixeles,espacioCcas(3));
    
    plot3(valoresR,valoresG,valoresB,colores{i})
end
title('Representación de las muestras RGB')
xlabel(nombreDescriptores{espacioCcas(1)}), ylabel(nombreDescriptores{espacioCcas(2)})...
, zlabel(nombreDescriptores{espacioCcas(3)})
valorMin = 0; valorMax = 255; axis([valorMin valorMax valorMin valorMax valorMin valorMax])
legend('Rojo Fresa','Verde Fresa','Verde Planta','Negro Lona'), hold off

%% GRÁFICA HS
espacioCcas = [4 5];
figure, hold on
for i=1:nColoresSegmentados
    % Tomamos los valores representativos de cada grupo de píxeles 
    selecPixeles = CodifValoresColores == CC(i);
    valoresH = ValoresColores(selecPixeles,espacioCcas(1));
    valoresS = ValoresColores(selecPixeles,espacioCcas(2));
    
    plot(valoresH,valoresS,colores{i})
end
title('Representación de las muestras HS')
xlabel(nombreDescriptores{espacioCcas(1)}), ylabel(nombreDescriptores{espacioCcas(2)})
%valorMin = 0; valorMax = 255; axis([valorMin valorMax valorMin valorMax valorMin valorMax])
legend('Rojo Fresa','Verde Fresa','Verde Planta','Negro Lona'), hold off

%% GRÁFICA UV
espacioCcas = [8 9];
figure, hold on
for i=1:nColoresSegmentados
    % Tomamos los valores representativos de cada grupo de píxeles 
    selecPixeles = CodifValoresColores == CC(i);
    valoresH = ValoresColores(selecPixeles,espacioCcas(1));
    valoresS = ValoresColores(selecPixeles,espacioCcas(2));
    
    plot(valoresH,valoresS,colores{i})
end
title('Representación de las muestras UV')
xlabel(nombreDescriptores{espacioCcas(1)}), ylabel(nombreDescriptores{espacioCcas(2)})
%valorMin = 0; valorMax = 255; axis([valorMin valorMax valorMin valorMax valorMin valorMax])
legend('Rojo Fresa','Verde Fresa','Verde Planta','Negro Lona'), hold off

%% GRÁFICA ab
espacioCcas = [11 12];
figure, hold on
for i=1:nColoresSegmentados
    % Tomamos los valores representativos de cada grupo de píxeles 
    selecPixeles = CodifValoresColores == CC(i);
    valoresH = ValoresColores(selecPixeles,espacioCcas(1));
    valoresS = ValoresColores(selecPixeles,espacioCcas(2));
    
    plot(valoresH,valoresS,colores{i})
end
title('Representación de las muestras ab')
xlabel(nombreDescriptores{espacioCcas(1)}), ylabel(nombreDescriptores{espacioCcas(2)})
%valorMin = 0; valorMax = 255; axis([valorMin valorMax valorMin valorMax valorMin valorMax])
legend('Rojo Fresa','Verde Fresa','Verde Planta','Negro Lona'), hold off

%% =======================================================================
%% DISEÑO DEL CLASIFICADOR
%% =======================================================================

% Calculamos la media y la desviación para cada color
CodifColorMean = [];
CodifColorStd = [];

for i=1:nColoresSegmentados
   CodifColorMean = [CodifColorMean; mean(ValoresColoresNormalizados(CodifValoresColores == CC(i),:))];
   CodifColorStd = [CodifColorStd; std(ValoresColoresNormalizados(CodifValoresColores == CC(i),:))];
end

% APLICACIÓN DEL CLASIFICADOR

espacioCcas = [1 2 3];
RDrgb = [];
matrices = [];
codifRGB = cat(3,codifR,codifG,codifB);

% Implementamos la regla de decision, si hay pixeles que se clasifiquen en
% más de una categoría de color debemos usar el siguiente orden de
% prioridades: rojo fresa, verde fresa, verde planta y negro lona.
% Por lo tanto, empezaremos a mirar a que color pertenecen por negro lona
% primero
RDrgb = uint8(zeros(size(R,1),size(R,2)));
for i=nColoresSegmentados:-1:1
    medR = CodifColorMean(i,1); desvR = CodifColorStd(i,1);
    medG = CodifColorMean(i,2); desvG = CodifColorStd(i,2);
    medB = CodifColorMean(i,3); desvB = CodifColorStd(i,3);
    
    comprueba = ((medR-2*desvR<codifR) & (codifR <=medR+2*desvR)) & ((medG-2*desvG< codifG) & (codifG <=medG+2*desvG))...
                & ((medB-2*desvB< codifB) & (codifB <=medB+2*desvB));
    
    RDrgb(comprueba) = CC(i);
%     figure,imshow(RDrgb)
end

%% =======================================================================
%% VISUALIZACIÓN DE RESULTADOS
%% =======================================================================

addpath('./Funciones')
color = [0 0 0;0 0 255;255 255 0;255 0 0];
VisualizaColores(uint8(I_RGB),RDrgb,CC(4:-1:1),color)


%% ***********************************************************************
%% =======================================================================
%% ETAPA 2
%% =======================================================================
%% ***********************************************************************

% Cuantificamos la separabilidad que proporcionan los espacios de color en
% los distintos canales

% Debemos hacer la distinción de los píxeles que son rojo fresa y el resto

selecFresa = CodifValoresColores == CC(1);
selecOtro = CodifValoresColores ~= CC(1);
CodifValoresColores(selecFresa) = 1;
CodifValoresColores(selecOtro) = 0;

% numDescriptores = 12;
% dimensiones = 3;
% 
% tabla = [];
% for i=dimensiones:6
%     aux = funcion_selecciona_vector_ccas_dim(ValoresColores,CodifValoresColores,numDescriptores,i);
%     tabla = [tabla; aux];
% end

% Seleccionamos los siguientes descriptores: R G B L a b
X = [ValoresColoresNormalizados(:,1:3) ValoresColoresNormalizados(:,10:12)];
Y = CodifValoresColores;
% Calculamos la mejor combinación con 3 descriptores
numDescriptores = 6;
dimensiones = 3;
[espacioCcas, JespacioCcas] = funcion_selecciona_vector_ccas_dim(X,CodifValoresColores,numDescriptores,dimensiones);

% Calculamos la mejor combinación con 4, 5 y 6 descriptores
dimensiones = 4;
tabla = [];
for i=dimensiones:6
    [espacioCcas JespacioCcas] = funcion_selecciona_vector_ccas_dim(ValoresColores,CodifValoresColores,numDescriptores,i);
    [espacioCcas JespacioCcas]
end

%% CLASIFICACIÓN BASADA EN KNN


[N M]=size(R); % R matriz rojo. Sólo para saber dimensiones de la imagen.
KNNrgb = zeros(N,M);
SVMrgb = zeros(N,M);
NNrgb = zeros(N,M); % Inicializamos matriz Resultado

% PARA HACER EFICIENTE EL CLASIFICADOR - SOLO LO LLAMAMOS UNA VEZ CON TODOS
% LOS DATOS. Recorremos por columna la matriz, y vamos poniendo la
% información de cada punto ( R G B ) en filas
input = [];
for j=1:M
    input_temp = [codifR(:,j) codifG(:,j) codifB(:,j)];
    input = [input ; input_temp];
end

KNN_model = fitcknn( X(:,1:3), Y,'NumNeighbors',5); % KNN
KNNrgb_vector = predict(KNN_model,input); % KNN

SVMModel = fitcsvm (X(:,1:3), Y); % SVM
SVMModel = compact(SVMModel); % SVM
SVMrgb_vector = predict(SVMModel , input); % SVM


% CREACIÓN DE ESTRUCTURA DE RED
[NeuronasCapaEntrada temp] = size(X(:,1:3)');

NeuronasCapaOculta1=15;
NeuronasCapaOculta2=15;
% Etc, etc, etc
CapasRed = [NeuronasCapaEntrada NeuronasCapaOculta1 NeuronasCapaOculta2];
% Con esta configuración se crea una RN de cuatro capas:
net=feedforwardnet(CapasRed); % Estructura de la red. 
view(net) % PARA VER LA ESTRUCTURA DE RED

% ENTRENAMIENTO CON TRAIN
net.trainParam.epochs=500; % numero maximo de epocas - normalmente para antes
% cuando el gradiente descendiente es mínimo o cuando el error en la muestra de validación que el
% se coge por defecto no disminuye en 6 épocas.
net=train(net,X(:,1:3)',Y');

NNrgb_vector = sim(net, input');

% Notar que las muestras en input están por filas
% ESCRIBIMOS LA INFORMACION EN LAS MATRICES RESULTADO TENIENDO EN CUENTA EL
% ORDEN EN QUE SE GENERARON LOS DATOS - ES DECIR, VAMOS GUARDANDO POR
% COLUMNA. Del vector salida del KNN, SVM o NN vamos extrayendo bloques del
% tamaño del número de filas y los vamos asignando a cada columna.


ind =1;
for j=1:M
    KNNrgb(:,j) =KNNrgb_vector(ind:ind+N-1);
    SVMrgb(:,j) =SVMrgb_vector(ind:ind+N-1);
    NNrgb(:,j) =NNrgb_vector(ind:ind+N-1);
    ind = ind+N;
end

aux = KNNrgb;
aux = 255*uint8(aux);
figure, imshow(aux)

aux = SVMrgb;
aux = 255*uint8(aux);
figure, imshow(aux)

aux = NNrgb;
aux = 255*uint8(aux);
figure, imshow(aux)



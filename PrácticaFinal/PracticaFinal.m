%% ------------------------------------------------------
%   PRÁCTICA FINAL - Daniel Pérez Rodríguez
% -------------------------------------------------------

clear all
clc
addpath("./Material_Imagenes_Plantillas/01_Training");
addpath("./funciones");

%% PRIMERA PARTE: Segmentación de caracteres
% *************************************************************************

%% 1).- Binarización

for i=1:4
    training{i} = imread(['Training_0' num2str(i) '.jpg']);
    %igure, imshow(training{i})
end

% Usaremos la primera imagen del training para explicar el método
% I = training{1};
% R = I(:,:,1); % Seleccionamos la componente roja

% Utilizamos el método de otsu para umbralizar la imagen
% umbral = graythresh(R);
% uX = umbral*255; % valor de X en el umbral
% mY = max(imhist(R)); % valor máximo de un tono de gris
% 
% Rb = imbinarize(R,umbral); % Binarizamos la imagen
% 
% figure, hold on,
%     subplot(4,1,1), imshow(I), title('Imagen original'),
%     subplot(4,1,2), imshow(R), title('Componente roja de la imagen')
%     subplot(4,1,3),imhist(R),line([uX uX],[mY 0],'Color','red'), 
%         title(['Umbral de otsu: ' num2str(uX)]),
%     subplot(4,1,4), imshow(Rb), title('Imagen binarizada')
%     hold off;
    

% Ahora lo probamos en todas las imagenes
for i=1:4
    I = training{i};
    R = I(:,:,1);
    
    umbral = graythresh(R);
    uX = umbral*255; % valor de X en el umbral
    mY = max(imhist(R)); % valor máximo de un tono de gris
    Rb = imbinarize(R,umbral); % Binarizamos la imagen
    figure, hold on,
        subplot(4,1,1), imshow(I), title(['Imagen original ' num2str(i)]),
        subplot(4,1,2), imshow(R), title('Componente roja de la imagen')
        subplot(4,1,3),imhist(R),line([uX uX],[mY 0],'Color','red'), 
            title(['Umbral de otsu: ' num2str(uX)]),
        subplot(4,1,4), imshow(Rb), title('Imagen binarizada')
        hold off;
        
   binary{i,1} = Rb; binary{i,2} = uX;
end

% binary almacena la imagen binarizada y el umbral utilizado

%% 2).- Eliminación de ruido
close all

% Como hemos visto en las imagenes anteriores, algunas presenta ruido de
% tipo sal y pimienta. Por lo que vamos a realizar filtro de mediana con
% diferentes tipos de ventana y vamos a quedarnos con el mejor resultado
% nos de


% vent = [5 10 20];
% for i=1:4
%     Ib = binary{i,1};
%     
%     figure, hold on,
%         subplot(4,1,1), imshow(Ib), title('Imagen binaria'),
%         
%     for j=1:size(vent,2)
%         IbFiltrada{j} = medfilt2(Ib,[vent(j) vent(j)]);
%         subplot(4,1,1+j), imshow(IbFiltrada{j}), title(['filtrado ventana ' num2str(vent(j))]),
%     end
%         
%         sgtitle(['Imagen ' num2str(i) ' - filtro mediana']),
%         hold off;
% end


% Observamos que la ventana que elimina mejor el ruido sin distorsionar los
% números es la de tamañao 10
vent = 10;
for i=1:4
    Ib = binary{i,1};
    filt{i} = medfilt2(Ib,[vent vent]);
    figure, hold on,
         subplot(2,1,1), imshow(Ib), title('Imagen binaria'),
         subplot(2,1,2), imshow(filt{i}), title('Imagen filtrada'),
         sgtitle(['Imagen ' num2str(i)]),
         hold off;
end

% Cambiamos el valor de los números de 0 a 1 en la matriz lógica
close all
for i=1:4
    filt{i} = funcion_invierte_binaria(filt{i});
    figure, imshow(filt{i}), title(['Imagen ' num2str(i)])
end
close all

% Aunque la mayoría de puntos de la imagen se han borrado aún queda algunos
% puntos. Para ello vamos a etiquetar todos los objetos en la imagen(pixeles
% con valor 1) y descartar todos aquellos que no tengan un tamaño mínimo

% for i=1:4
%     [L,numObj] = bwlabel(filt{i},4); % El 4 representa la vencindad
% 
%     % Vemos el tamaño de los objetos reconocidos
%     disp(['Tamaño de los objetos en la imagen ' num2str(i)])
%     for j=1:numObj
%         comp = j == L;
%         lista(j) = sum(sum(comp));
%         disp(['Objeto ' num2str(j) ': ' num2str(lista(j))])
%     end
%     figure, imshow(filt{i})
% end
% close all

% Podemos observar que si descartamos todos los objetos que tengan un área
% menos al 20% del objeto con área máxima. Podemos eliminar todo el ruido
% restante. Y además eliminar el primer el objeto que identifica, ya que
% siempre es la banda de la Unión Europea
segmen = filt;
for i=1:4
    [L,numObj] = bwlabel(filt{i},4); % El 4 representa la vencindad
    
    %Calculamos el tamaño de cada objeto
    for j=1:numObj
        comp = j == L;
        lista(j) = sum(sum(comp));
    end
    
    umbral = lista(1)*0.20;
    comp = lista < umbral; 
    pos = find(comp); % Tenemos los objetos a borrar en la imagen
    pos = [1 pos]; % El primer objeto tenemos que borrarlo
    for j=1:size(pos,2)
        posBorrado = pos(j) == L;
        segmen{i}(posBorrado) = 0;
    end
    
    figure, hold on,
        subplot(2,1,1), imshow(filt{i}), title(['Imagen ' num2str(i) ' filtrada']),
        subplot(2,1,2), imshow(segmen{i}), title(['Imagen ' num2str(i) ' segmentada']),
    disp(['Imagen ' num2str(i)])
    calcula_tamano_objetos(segmen{i});
end

%% 3).- A pesar de quitar los objetos más pequeños es posible que se se 
% encuentren objetos de gran tamaño al borde de las imagenes debido a que 
% la imagen de la matrícula no esta tomada correctamente. Para ello, vamos
% a seleccionar los objetos que tengan alguna región del mismo en la zona
% central de la imagen

segmenCentrado = segmen;
for i=1:4
    [L,numObj] = bwlabel(segmen{i},4);
    M = size(L,1);
    N = size(L,2);
    mitadM = floor(M/2);
    
    objEliminar = funcion_objetos_no_centrados(L);
    % Sabiendo que objetos tenemos eliminar prodecemos a realizarlo
    if isempty(objEliminar) == 0
        for j=1:size(objEliminar,1)
            posBorrado = objEliminar(j) == L;
            segmenCentrado{i}(posBorrado) = 0;
        end
    else
        segmenCentrado{i} = segmen{i};
    end
    
    figure, hold on
        subplot(2,1,1), imshow(segmen{i}), title('Imagen segmentada')
        subplot(2,1,2), imshow(segmenCentrado{i}), title('Imagen segmentada de objetos centrados'),
            % Pintamos la línea central que hemos tomado para hacer la
            % distinción
            % selecX = [0 N];
            % selecY = [mitadM mitadM];
            line([0 N],[mitadM mitadM],'Color','blue'),
            sgtitle(['Imagen ' num2str(i)]),
            hold off;
end

%% 4).- Ahora debemos identificar buscar la region que ocupa cada número en
% imagen, para ello usaremos regionprops
close all

for i=1:4
    [L,numObj] = bwlabel(segmen{i},4);
    stats = regionprops('table',L,'Centroid','BoundingBox');
    centroides = table2array(stats(:,1));
    bb = table2array(stats(:,2));
    
    lineas_bb = calcula_lineas_bb(bb);
    centroidesX = centroides(:,1);
    centroidesY = centroides(:,2);

    figure, hold on, 
        subplot(3,1,1), imshow(training{i}), title('Imagen original'),
        subplot(3,1,2), imshow(segmen{i}), title('Imagen segmentada'),
        subplot(3,1,3), imshow(segmen{i}), title('Objetos reconocidos'),
            hold on, 
            for j=1:size(lineas_bb,2)
                selec = lineas_bb{j};
                selecX = selec{1};
                selecY = selec{2};
                line(selecX,selecY,'Color','red')
                hold on, plot(centroidesX,centroidesY,'.r'),
                sgtitle(['Imagen ' num2str(i)])
            end
            hold off;
end

%% 5).- Fase de pruebas. Comprobamos que el algoritmo segmenta correctamente
% las matrículas en la fase de test

addpath("./Material_Imagenes_Plantillas/02_Test");

% detectObj = funcion_segmenta_matricula(training);

for i=1:20
    if i<10
        test{i} = imread(['Test_0' num2str(i) '.jpg']);
    else
        test{i} = imread(['Test_' num2str(i) '.jpg']);
    end
end

funcion_segmenta_matricula(test,true);
close all

%% SEGUNDA PARTE: Reconocimiento de caracteres
% *************************************************************************
clear all
clc
addpath("./Material_Imagenes_Plantillas/00_Plantillas");
addpath("./Material_Imagenes_Plantillas/02_Test");
addpath("./funciones");

for i=1:20
    if i<10
        test{i} = imread(['Test_0' num2str(i) '.jpg']);
    else
        test{i} = imread(['Test_' num2str(i) '.jpg']);
    end
end

[detectObj Isegmen] = funcion_segmenta_matricula(test,false);
close all

%% 1).- Ahora debemos reconocer los caracteres de las matrículas. Para ello 
% miraremos el grado de similutud entre los bounding box encontrados y las
% plantillas de los distintos carácteres generados previamente
load('Plantillas.mat');

Caracteres = ['0123456789ABCDFGHKLNRSTXYZ'];
numTipoPlantillas = size(Caracteres,2);
numAngulos = 7;
listaSimilitud = zeros(1,size(Caracteres,2));
caracteresReconocidos = [];
matriculas = {};
numI = size(test,2);

contador = 0;
numPlantillas = 182;
for i=1:numI
    detectSelec = detectObj{i};
    numObj = size(detectSelec,1);
    caracteresReconocidos = [];
    
    for j=1:numObj
        % detectSelec contiene los parametros del Bounding box en las
        % posiciones 3:6
        datosbb = detectSelec(j,3:6);
        xi = floor(datosbb(1)); yi = floor(datosbb(2)); ancho = datosbb(3); alto = datosbb(4);
        xf = floor(xi+ancho); yf = floor(yi+alto);
        
        if yi==0 % En una de las imagenes datosbb es 0.5 por lo tanto 0. Y eso no puede ocurrir
                yi = 1;
        end
        
        bb = Isegmen{i}(yi:yf,xi:xf);
        
        % Con el caracter encontrado debemos compararlo con cada una de las
        % plantillas
        listaSimilitud = zeros(1,size(Caracteres,2));
        for k=1:numTipoPlantillas
            for z=1:numAngulos
                % Seleccionamos la plantilla
                if k < 10;
                    numO = ['0' num2str(k)]; % Número de Objeto
                else
                    numO = [num2str(k)]; % Número de Objeto
                end
                nombrePlantilla = ['Objeto' numO 'Angulo0' num2str(z)];
                eval(['selecPlantilla = ' nombrePlantilla ';']);
                
                % Redimensionamos nuestro bb al tamaño de la plantilla
                % Para ello cogemos las dimensiones de la plantilla
                % seleccionada
                [m n] = size(selecPlantilla);
                bbresize = imresize(bb,[m n]);
                
                % Ahora comparamos las dos matrices
                valorCorrelacion = Funcion_CorrelacionEntreMatrices(selecPlantilla,bbresize);
                
                % Miramos si hemos obtenido con una plantilla del mismo
                % tipo de caracter, un mejor resultado previamente. Sino lo
                % actualizamos
                if listaSimilitud(k) < valorCorrelacion
                    listaSimilitud(k) = valorCorrelacion;
                end
                contador = contador+1;
                disp(['Imagen '  num2str(i) '-Objeto ' num2str(j) '-Plantilla ' num2str(contador) '/' num2str(numPlantillas)]);
            end
        end
        contador = 0;
        % Una vez comprobada la similutud con todas las plantillas
        % debemos comprobar cual es la que ha obtenido un mayor
        % resultado
        similitudMax = max(listaSimilitud);
        comp = similitudMax == listaSimilitud;
        posCaracter = find(comp);

        caracterReconocido = Caracteres(posCaracter);

        % Guardamos el caracter reconocido
        caracteresReconocidos = [caracteresReconocidos caracterReconocido]; 
    end
    
    matriculas{i} = caracteresReconocidos;
    
    % Mostamos la matrícula
    figure, hold on,
        imshow(Isegmen{i}), title(['Matricula: ' matriculas{i}]),
        for k=1:size(detectSelec,1)
            centroides = detectSelec(k,1:2);
            bb = detectSelec(k,3:6);
            lineas_bb = calcula_lineas_bb(bb);
            centroidesX = centroides(:,1);
            centroidesY = centroides(:,2);
            for j=1:size(lineas_bb,2)
                    selec = lineas_bb{j};
                    selecX = selec{1};
                    selecY = selec{2};
                    line(selecX,selecY,'Color','red')
                    hold on, plot(centroidesX,centroidesY,'.r'),
                    hold off;
            end
        end
end
close all

% Probramos la función anterior con la siguiente función
matriculas = funcion_reconoce_matricula(detectObj,Isegmen,false,test);
close all

%% TERCERA PARTE (Propia): Unión de funciones y prueba de rendimiento
% *************************************************************************
clear all
clc
addpath("./Material_Imagenes_Plantillas/02_Test");
addpath("./funciones");

for i=1:20
    if i<10
        test{i} = imread(['Test_0' num2str(i) '.jpg']);
    else
        test{i} = imread(['Test_' num2str(i) '.jpg']);
    end
end


matriculas = funcion_lee_matriculas({test{1}},false);
close all

% PRUEBA DE RENDIMIENTO

valor = [];
for i=1:20
    tic
    matriculas = funcion_lee_matriculas({test{i}},false)
    valor = [valor;toc];
end
media = mean(valor);
figure, plot([1:20],valor,'-*r'), title(['Tiempo de ejecución del algoritmo - Media: ' num2str(media)]),...
    , xlabel('Matrícula'), ylabel('Segundos')


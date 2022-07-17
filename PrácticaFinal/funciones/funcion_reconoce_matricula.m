function matriculas = funcion_reconoce_matricula(detectObj,Isegmen,info,varargin)
%FUNCION_RECONOCE_MATRICULA La función reconoce los caracteres de las
%imagenes almacenadas en Isegmen. Para ello es necesario la variable
%detectObj que contiene los centroides y su bounding box. La variable test
%se necesita para mostrar la imagen  La variable info
%es de tipo lógica y si está a true muestra por pantalla la imagen
%segmentada con los caracteres reconocidos. En la variable matriculas se
%almacenan todas las matriculas reconocidas de cada imagen
    
    addpath("./Material_Imagenes_Plantillas/00_Plantillas");
    load('Plantillas.mat');

    Caracteres = ['0123456789ABCDFGHKLNRSTXYZ'];
    numTipoPlantillas = size(Caracteres,2);
    numAngulos = 7;
    listaSimilitud = zeros(1,size(Caracteres,2));
    caracteresReconocidos = [];
    matriculas = {};
    
    numI = size(Isegmen,2);

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
                    
                    if info == true
                        contador = contador+1;
                        disp(['Reconocimiento de caracteres - Imagen '  num2str(i) '-Objeto ' num2str(j) '-Plantilla ' num2str(contador) '/' num2str(numPlantillas)]);
                    end
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
            if nargin == 4
                imshow(varargin{1}{i}), title(['Matricula: ' matriculas{i}]),
            else
                imshow(Isegmen{i}), title(['Matricula: ' matriculas{i}]),
            end
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
        
        % Para mostrar el progreso de la función
        disp(['Progreso ' num2str(floor((i/numI)*100)) '%']);
    end
end

function ValorCorrelacion = Funcion_CorrelacionEntreMatrices(M1,M2)
%FUNCION_CORRELACIONENTREMATRICES Summary of this function goes here
%   Detailed explanation goes here
    [m,n] = size(M1);

    MeanM1 = mean(M1(:));
    MeanM2 = mean(M2(:));
    AcumNum = 0;
    AcumDen = 0;
    
    for k=1:m
        for z=1:n
            AcumNum = AcumNum + (M1(k,z)-MeanM1) * (M2(k,z)-MeanM2);
            AcumDen = AcumDen + sqrt((M1(k,z)-MeanM1)^2) * sqrt((M2(k,z)-MeanM2)^2);
        end 
    end
    
    ValorCorrelacion = AcumNum/AcumDen;
end



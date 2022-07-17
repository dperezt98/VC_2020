function matriculas = funcion_lee_matriculas(Icell,info)
%FUNCION_LEE_MATRICULAS Función que apartir de la imagen de una matrícula,
%te reconoce los caracteres de la misma. La variable Icell debe contener
%las imagenes de las matrículas a reconocer(la variable debe estar en tipo 
%celda). La variable info muestra todos los pasos que va haciendo la
%función para encontrar los caracteres de la matrícula. La variable
%matriculas devuelve las matriculas reconocidas
    disp('Fase de segmentación - iniciada');
    [detectObj Isegmen] = funcion_segmenta_matricula(Icell,info);
    disp('Fase de segmentación - completada');
    disp('Fase de reconocimiento - iniciada');
    matriculas = funcion_reconoce_matricula(detectObj,Isegmen,info,Icell);
    disp('Fase de reconocimiento - completada');
end


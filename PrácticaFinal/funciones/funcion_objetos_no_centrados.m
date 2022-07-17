function objEliminar = funcion_objetos_no_centrados(L)
%FUNCION_OBJETOS_NO_CENTRADOS Le pasamos una matriz L con los objetos de la
%imagen etiquetados, y la función se encarga de devolver los objetos que no
%están centrados en la misma
    M = size(L,1);
    mitadM = floor(M/2);
    
    % Seleccionamos la línea central de la imagen
    selecLinea = L(mitadM,:);
    
    % Ahora comprobamos que objetos se encuentran en la misma
    comp = unique(selecLinea);
    
    % Eliminamos los objetos que están en la posición central
    objetos = unique(L);
    binCompGlobal = false(size(objetos,1),size(objetos,2));
    for j=1:size(comp,2)
        binComp = objetos == comp(j);% binaria comprueba
        binCompGlobal = binCompGlobal+binComp;
    end
    binObjEliminar = funcion_invierte_binaria(binCompGlobal);
    objEliminar = objetos(binObjEliminar);
end


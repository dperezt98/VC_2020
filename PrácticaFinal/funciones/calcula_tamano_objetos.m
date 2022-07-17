function lista = calcula_tamano_objetos(I)
%CALCULA_TAMANO_OBJETOS Comprueba el número de objetos que hay en una
%imagen y muestra el número y tamaño de dichos objetos

    [L,numObj] = bwlabel(I,4); % El 4 representa la vencindad

    % Vemos el tamaño de los objetos reconocidos
    disp(['La imagen tiene ' num2str(numObj) ' objetos']);
    disp('Tamaño de los objetos en la imagen')
    for j=1:numObj
        comp = j == L;
        lista(j) = sum(sum(comp));
        disp(['Objeto ' num2str(j) ': ' num2str(lista(j))])
    end
end


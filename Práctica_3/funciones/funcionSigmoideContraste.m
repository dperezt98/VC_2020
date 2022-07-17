function n2I = funcionSigmoideContraste(I,alpha)
%FUNCIONSIGMOIDECONTRASTE Aplica la función sigmoide. Para modificar
%el contraste de la imagen original. Devolviendo 2 imágenes, una para cada
%función
    
    Id = double(I);
    Iq1 = (255/2)*(1 + ( 1/(sin(alpha*pi/2) ) )*( sin(alpha*pi*((Id/255)-0.5 ))) );
    Iq2 = (255/2)*(1 + ( 1/(tan(alpha*pi/2) ) )*( tan(alpha*pi*((Id/255)-0.5 ))) );
    
    n2I = cat(3,uint8(Iq1),uint8(Iq2));
end


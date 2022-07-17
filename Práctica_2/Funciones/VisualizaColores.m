function VisualizaColores(I,RDrgb,CC,color)
%% La variable I es una imagen en RGB. La variable RDrgb es una matriz en uint8
% con los colores a modificar. CC contiene los valores de los cuales está
% compuesta RDrgb y color representa un color para cada valor de CC
    
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    
    for i=1:size(CC,2)
       R(RDrgb == CC(i)) = color(i,1);
       G(RDrgb == CC(i)) = color(i,2);
       B(RDrgb == CC(i)) = color(i,3);
    end
    
    imagen = cat(3,R,G,B);
    figure,imshow(imagen)
end


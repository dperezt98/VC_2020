function nI = ruido_gaussiano(I,media,desv)
%RUIDO_GAUSSIANO Produce pequeñas variaciones en los niveles de gris 
% "originales"("ideales") de una imagen. El valor dinal de píxel sería el
% ideal más una cantidad correspondiente al error, que puede describirse
% como una variable gaussiana. G(x,y) = I(x,y) + variable error gaussiana
    
    [M,N] = size(I);
    Id = double(I);
    randM = randn(M,N);
    randM = media + randM*desv;
    nI = uint8(Id + randM); 
end


function nI = funcionRaizCubicaContraste(I)
%FUNCIONRAIZCUBICACONTRASTE Aplica la función cúbica: q = (255^2*p).^(1/3) . Para modificar
%el contraste de la imagen

    Id = double(I);
    nI = uint8((255^2 * Id).^(1/3));
end


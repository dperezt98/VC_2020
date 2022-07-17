function nI = funcionCubicaContraste(I)
%FUNCIONCUBICACONTRASTE Aplica la función cúbica: q = p^3/(255^255) . Para modificar
%el contraste de la imagen

    Id = double(I);
    nI = uint8(Id.^3/(255^2));
end


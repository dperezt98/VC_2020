function Ifiltrada = Funcion_FiltAdapt(I,NumFilVent,NumColVent,VarRuido)
%FUNCION_FILTADAPT Summary of this function goes here
%   Detailed explanation goes here

    [M,N] = size(I);
    Id = double(I);
    nI = zeros(M,N);
    
    % Que tiene cada punto respecto a su vecindad
    h = (1/(NumFilVent*NumColVent)) * ones(NumFilVent,NumColVent);
    mediaLocal = imfilter(Id,h,'symmetric');
    
    varLocal = stdfilt(Id,ones(NumFilVent,NumColVent));
    varLocal2 = varLocal.^2;
    
    for i=1:M
        for j=1:N
            nI(i,j) = I(i,j) - (VarRuido/varLocal2(i,j))*(I(i,j)-mediaLocal(i,j));
        end 
    end
    
    Ifiltrada = uint8(nI);
end


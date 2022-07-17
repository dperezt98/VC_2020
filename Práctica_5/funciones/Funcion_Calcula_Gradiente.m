function [Gx Gy ModG] = Funcion_Calcula_Gradiente(I,Hx,Hy)
%FUNCION_CALCULA_GRADIENTE 
    
    Id = double(I);
    Gx = imfilter(Id,Hx,'symmetric');
    Gy = imfilter(Id,Hy,'symmetric');
    ModG = sqrt(Gx.^2 + Gy.^2);
end


function eva = funcion_evaluacion(I,Iruidosa,Ifiltrada)
%FUNCION_EVALUACION Evalua la efectividad del filtro usado
    Id = double(I);
    superior = (Id-double(Iruidosa)).^2; sumSuperior = sum(superior(:));
    inferior = (Id-double(Ifiltrada)).^2; sumInferior = sum(inferior(:));
    eva = 10*log10(sumSuperior/sumInferior);
end


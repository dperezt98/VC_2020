function NormCrossCorr = Funcion_CorrelacionEntreMatrices(IROI,T)
%FUNCION_CORRELACIONENTREMATRICES Summary of this function goes here
%   Detailed explanation goes here
    
    [m,n] = size(IROI);

    MeanI = mean(IROI(:));
    MeanT = mean(T(:));
    AcumNum = 0;
    AcumDen = 0;
    
    for k=1:m
        for z=1:n
            AcumNum = AcumNum + (IROI(k,z)-MeanI) * (T(k,z)-MeanT);
            AcumDen = AcumDen + sqrt((IROI(k,z)-MeanI)^2) * sqrt((T(k,z)-MeanT)^2);
        end 
    end
    
    NormCrossCorr = AcumNum/AcumDen;
end


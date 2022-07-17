function ValorCorrelacion = Funcion_CorrelacionEntreMatrices(M1,M2)
%FUNCION_CORRELACIONENTREMATRICES Summary of this function goes here
%   Detailed explanation goes here
    [m,n] = size(M1);

    MeanM1 = mean(M1(:));
    MeanM2 = mean(M2(:));
    AcumNum = 0;
    AcumDen = 0;
    
    for k=1:m
        for z=1:n
            AcumNum = AcumNum + (M1(k,z)-MeanM1) * (M2(k,z)-MeanM2);
            AcumDen = AcumDen + sqrt((M1(k,z)-MeanM1)^2) * sqrt((M2(k,z)-MeanM2)^2);
        end 
    end
    
    ValorCorrelacion = AcumNum/AcumDen;
end


function NormCrossCorr = funcion_NormCorr2(I,T)
%FUNCION_NORMCORR2 Summary of this function goes here
%   Detailed explanation goes here

    I = double(I);
    T = double(T);
    % Generamos la matriz IROI
    [m n] = size(T);
    [M N] = size(I);
    
    
    
    vM = m;
    if rem(vM,2) == 0
        vM = vM - 1;
    end
    aM = floor(vM/2);
    
    vN = n;
    if rem(vN,2) == 0
        vN = vN - 1;
    end
    aN = floor(vN/2);
    
    IROI = zeros(m,n);
    NormCrossCorr = zeros(M,N);
    
    for i=1+aM:M-aM
        for j=1+aN:N-aN
            IROI = I(i-aM:i+aM,j-aN:j+aN);
            ValorCorrelacion = Funcion_CorrelacionEntreMatrices(IROI,T);
            
            NormCrossCorr(i,j) = ValorCorrelacion;
        end
    end
end


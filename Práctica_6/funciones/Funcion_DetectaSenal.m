function Icirculo = Funcion_DetectaSenal(I,color)
%FUNCION_DETECTASENAL I es la imagen en la cual hay que detectar una señal
%y color el tipo de color que tiene la misma: rojo o azul
    Id = double(I);

    %% 1)
    R = I(:,:,1); G = I(:,:,2); B = I(:,:,3); 
    Rmin = min(R(:)); Rmax = max(R(:));
    Gmin = min(G(:)); Gmax = max(G(:));
    Bmin = min(B(:)); Bmax = max(B(:));

    factor = 0.35;
    UmbralRojo = factor*(Rmin+Rmax);
    UmbralVerde = factor*(Gmin+Gmax);
    UmbralAzul = factor*(Bmin+Bmax);

    if strcmp('rojo',color)
        Ir = R >= UmbralRojo;
        Ig = G < UmbralVerde;
        Ia = B < UmbralAzul;
    else
        Ir = R < UmbralRojo;
        Ig = G < UmbralVerde;
        Ia = B >= UmbralAzul;
    end

    Ib = (Ir & Ig & Ia);

    %% 2)
    radii = 5:2:35;
    H = circle_hough(Ib, radii, 'same');

    %% 3)
    P = circle_houghpeaks(H, radii,'npeaks',1);


    xCentro = P(2);
    yCentro = P(1);
    r = P(3);
    numVotos = P(4);

    [y x] = circlepoints(r);

    [M N] = size(I(:,:,1));
    Ib_circunf = false(M,N);
    for i=1:length(y)
       Ib_circunf(xCentro+x(i),yCentro+y(i)) = true; 
    end

    Ib_circulo = imfill(Ib_circunf,'holes');

    Icirculo = uint8(zeros(M,N,3));
    Icirculo(:,:,1) = Ib_circulo.*double(R);
    Icirculo(:,:,2) = Ib_circulo.*double(G);
    Icirculo(:,:,3) = Ib_circulo.*double(B);

    figure ,hold on
        subplot(1,3,1), imshow(Ib_circulo), title('Circunferencia detectada binaria')
        subplot(1,3,2), imshow(Icirculo), title('Circunferencia detectada')
        subplot(1,3,3), imshow(I), title('Imagen original')
        hold off
end


clc;
close all;
clear all;

f = rgb2gray(imread('Images/lena_noise.jpg'));
f = double(f)+1;
z = log(f);
Z = fft2(z);

[N,M] = size(f);

P = 2*N;
Q = 2*M;

gH = 0.5;
gL = 0.2;
dg = gH-gL;

Do  = 2;
Do2 = Do^2;
c   = 0.5;

D2 = zeros(P,Q);
H = D2;

for u=1:P
    for v=1:Q
        D2(u,v) = ((u-P/2)^2+(v-Q/2)^2);
    end
end

for u=1:P
    for v=1:Q
        H(u,v) = dg*(1-exp(-c*D2(u,v)/Do2))+gL;
    end
end

% Zero Padding
Ip = zeros(P,Q);
Ip(1:N,1:M) = z;

% Transformada de Fourier en 2D
II = fft2(Ip);

% Intercambio de cuadrantes
Ipf = fftshift(II);
figure
imshow(log(abs(Ipf)+1),[]);title('Fourier de imagen de entrada')

% Convolucion = multiplicacion en el dominio de la frecuencia
It = H.*Ipf;
figure
imshow(log(abs(It)+1),[]);title('Fourier de imagen filtrada')

% Intercambio de cuadrantes
T = fftshift(It);

% Transformada inversa de fourier
Jp = ifft2(T);

% Eliminacion de parte imaginaria (despreciable aprox = 0) y
% eliminacion de parte correspondiente al zero-padding
s = real(Jp(1:N,1:M));

%s = s-min2(s)+1;

J = exp(s);
figure
imshow(s,[])
figure
imshow(f,[]);title('Imagen Original');
figure
imshow(J./s,[]);title('Imagen Filtrada');


function [vall, indd] = min2(A)
    %   Function MIN2 finds value VALL of a smallest element in an 2D array  and 
    %   returns it's indices INDD(1) =row and INDD(2) = column. If A is a vector, 
    %   MIN2  equal standard Matlab MIN function. 
    %   ATT: This function like standard Matlab MAX first looks in column, 
    %   then  in rows to find its first min value.
    %__NEW______ function replaces -Inf to NaN
    %__________________________________________________
    % 	Sergei Koptenko, Resonant Medical Inc., Toronto  |
    %	sergei.koptenko@resonantmedical.com                |
    %______________March/30/2004_____________________|

    [rrow, ccol] = size(A);

    [i,j] = find(A == -Inf);
    A(i,j) = NaN;
    if (rrow ==1 || ccol ==1) 
        [vall, indd] = min(A);
    else
        [vall, jj] = min(A);    
        [vall, kk] = min(vall);    
        indd(2) = kk;    
        indd(1)= jj(kk);  
    end
end

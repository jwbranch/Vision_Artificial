%***********************************************************************************
%Institución universitaria Pascual Bravo.
%Juan Carlos Briñez de León  
%Algoritmo para la simulación de efectos de resolución 
%Usando: imresize in matlab
%======================================================================================
clear
close all
clc


%Ejercicio resolución
I = imread('Bumblebee.jpg');
Fig=figure;
pause(2)
cont=0;
for i=0:10
    cont=cont+1;
    I2=imresize(I(:,:,1:3),[2^i 2^i]);
    imagesc(I2)
    pbaspect([1 1 1])
    set(gca,'fontsize',14);
    xlabel('Pixels')
    ylabel('Pixels')
    axis on
    pause(0.01)
    saveas(Fig,['Fig_',num2str(cont)],'bmp')
end

v = VideoWriter('Vid_Resolución');
open(v)
for i = 1:1:11   
    Img = imread(['Fig_',num2str(i),'.bmp']);
    Img_B=im2frame(Img);
    for j=1:25
        writeVideo(v,Img_B)
    end
end
 close(v);
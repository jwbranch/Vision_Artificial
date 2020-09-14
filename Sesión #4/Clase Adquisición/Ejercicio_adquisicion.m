%***********************************************************************************
%Juan Carlos Briñez
%Doctorado Ing.Sistemas
%Facultad de Minas.
%Universidad Nacional de Colombia.
%======================================================================================
%Algoritmo: Contenido espectral de fuentes de iluminación
%Usando: Rawdata by Juan Sebastian
%======================================================================================
clc
clear
close all

%*************************************************************************
%Cargando datos de fuente de iluminación
load('Parametros\Iluminación\Sources_Botero_Lasser.mat');%Respuesta espectral del dispositivo
Lambda=linspace(390,760,371);
figure,
for i=1:15           
                Source_1 = 'Ideal';
                Source_2 = 'Incandescente';
                Source_3 = 'Fluorescente';
                Source_4 = 'Concord LED';
                Source_5 = 'Cooper LED';
                Source_6 = 'Cooper RXD2 LED';
                Source_7 = 'Philips 50W';
                Source_8 = 'Philips EnduraLED';
                Source_9 = 'Sylvania UltraLED';
                Source_10 = 'Toshiba ECore';
                Source_11 = 'Willard LED';
                Source_12 = 'Absoluto LCD';
                Source_13 = 'Neutral White LED';
                Source_14 = 'Cold White LED';
                Source_15 = 'Warm White LED';
  
  Source=Sources(:,i);
  plot(Lambda,Source)
  set(gca,'fontsize',14);
  xlabel('Lambda in nm')
  ylabel('Spectral content')
if i==1
      title(['Fuente:',Source_1])
  elseif i==2
      title(['Fuente:',Source_2])
  elseif i==3
      title(['Fuente:',Source_3])
  elseif i==4
      title(['Fuente:',Source_4])
  elseif i==5
      title(['Fuente:',Source_5])
  elseif i==6
      title(['Fuente:',Source_6])
  elseif i==7
      title(['Fuente:',Source_7])
  elseif i==8
      title(['Fuente:',Source_8])
  elseif i==9
      title(['Fuente:',Source_9])
  elseif i==10
      title(['Fuente:',Source_10])
  elseif i==11
      title(['Fuente:',Source_11])
  elseif i==12
      title(['Fuente:',Source_12])
  elseif i==13
      title(['Fuente:',Source_13])
  elseif i==14
      title(['Fuente:',Source_14])
  elseif i==15
      title(['Fuente:',Source_15])
end

  axis on
  axis([390 760 0 1])
  pause(1)
end
%**************************************************************************


%**************************************************************************
%%Diseñando reflectancia espectral de una escena (Sólo tres colores)
Img=imread('Cherry.jpg');
[Fi,Col,Can]=size(Img);
Gray=rgb2gray(Img);
figure,subplot(2,2,1),imshow(Img(:,:,:))
subplot(2,2,2),imshow(Img(:,:,1))
subplot(2,2,3),imshow(Img(:,:,2))
subplot(2,2,4),imshow(Img(:,:,3))
close all
Full_espectro=zeros(371,Fi,Col);
contador=0;
for i=1:Fi
    for j=1:Col
        contador=contador+1;
        C=0;
        if Img(i,j,1)>200&&Img(i,j,2)>200&&Img(i,j,3)>200
           Full_espectro(1:371,i,j)=1;
           C=1;
        end
        if Img(i,j,1)>180&&Img(i,j,2)<80
           Full_espectro(220:300,i,j)=1;
           C=1;
        else
            if Img(i,j,2)>150&&Img(i,j,3)<150
                Full_espectro(120:200,i,j)=1;
                C=1;
            end
        end
        if C==0
           Full_espectro(1:371,i,j)=0.2; 
        end
    end
end
%*********************************************************************

%********************************************************************
%Leyendo respuesta espectral del sensor de la cámara
 load('Parametros\Cámaras\Sensores_Hermes_2.mat');%Respuesta espectral del dispositivo
               %Sensores(:,:,1)  => Sensor_0.mat:    Ojo Humano
                %Sensores(:,:,2)  => Sensor_1.mat:    Cámara=DCC1240C           Sensor=e2v-EV76C560ACT
                %Sensores(:,:,3)  => Sensor_2.mat:    Cámara=DCC1645C           Sensor=Aptina-MT9M131
                %Sensores(:,:,4)  => Sensor_3.mat:    Cámara=DCC3260C           Sensor=Sony-IMX249LQJ-C
                %Sensores(:,:,5)  => Sensor_4.mat:    Cámara=exo304CU3          Sensor=Sony-IMX304LQR
                %Sensores(:,:,6)  => Sensor_5.mat:    Cámara=hr25CCL            Sensor=ON Semiconductor NOIP1SE025KA-GDI
                %Sensores(:,:,7)  => Sensor_6.mat:    Cámara= hr16050CFLCPC     Sensor=ON Semiconductor KAI-16050-C
                %Sensores(:,:,8)  => Sensor_7.mat:    Cámara=IDS-UI-3590CP      Sensor=AR1820HSSC00SHEA0
                %Sensores(:,:,9)  => Sensor_8.mat:    Cámara=PL-D755CU          Sensor=Sony IMX250
                %Sensores(:,:,10) => Sensor_9.mat:    Cámara=Manta G-223        Sensor=Allied Vision  CMOSIS/ams CMV2000
                %Sensores(:,:,11) => Sensor_10.mat:   Cámara=Manta G-507        Sensor=Sony IMX264
                %Sensores(:,:,12) => Sensor_11.mat:   Cámara=Ideal              Hermes
  for i=1:12              
      figure(1),plot(Lambda,Sensores(:,1,i),'r')
      hold on
      plot(Lambda,Sensores(:,2,i),'g')
      plot(Lambda,Sensores(:,3,i),'b')
      set(gca,'fontsize',14);
      xlabel('Lambda in nm')
      ylabel('Spectral content')
      title(['Cámara tipo: ',num2str(i)])
      axis on
      axis([390 760 0 1])
      pause(2)
      close all
  end
%******************************************************************
  

%***************************************************************** 
  %==============Simulando color
  Espectro(1:371,1)=390:760;
  Source=Sources(:,2)/max(Sources(:,1));
  Sensor=Sensores(:,:,3)/max(max(Sensores(:,:,1)));

  % Preparando datos espectrales
   r=zeros(371,1);
   g=zeros(371,1);
   b=zeros(371,1);
   r(:,1)=Sensor(1:371,1)/max(Sensor(1:371,1));%Respuesta en sensor r
   g(:,1)=Sensor(1:371,2)/max(Sensor(1:371,2));%Respuesta en sensor g
   b(:,1)=Sensor(1:371,3)/max(Sensor(1:371,3));%Respuesta en sensor b
   
   % Spectral interaction Camera-sensor
   Interaction_R=Source.*r;
   Interaction_G=Source.*g;
   Interaction_B=Source.*b;
   Interaction=zeros(371,3);
   Interaction(:,1)=Interaction_R;
   Interaction(:,2)=Interaction_G;
   Interaction(:,3)=Interaction_B;
   Interaction=Interaction/max(max(Interaction));
   % Iniciando matriz de imagen
   Img_r_1=zeros(Fi,Col);
   Img_g_1=zeros(Fi,Col);
   Img_b_1=zeros(Fi,Col);

   for i=1:Fi
       for j=1:Col
                for k=1:371
                                        
                    Img_r_1(i,j)=Img_r_1(i,j)+(Interaction(k,1)*Full_espectro(k,i,j));
                    Img_g_1(i,j)=Img_g_1(i,j)+(Interaction(k,2)*Full_espectro(k,i,j));
                    Img_b_1(i,j)=Img_b_1(i,j)+(Interaction(k,3)*Full_espectro(k,i,j));
            
                end
       end
   end

            %Normalización  sin balance de ganancia
            Imagen=zeros(Fi,Col,Can);
            Imagen(:,:,1)=Img_r_1;
            Imagen(:,:,2)=Img_g_1;
            Imagen(:,:,3)=Img_b_1;
            Imagen=Imagen/max2(Imagen);
            Imagen=255*Imagen;
            figure, imshow(uint8(Imagen))
            
%*************************************************
%Normalización  con balance de ganancia
            Imagen=zeros(Fi,Col,Can);
            Imagen(:,:,1)=Img_r_1/max(max(Img_r_1));
            Imagen(:,:,2)=Img_g_1/max(max(Img_g_1));
            Imagen(:,:,3)=Img_b_1/max(max(Img_b_1));

            Imagen=255*Imagen;
            figure, imshow(uint8(Imagen))
            
            
            
            
%****************************************************
%    Ejerciciio completo
Espectro(1:371,1)=390:760;
figure,
for y=1:5
for z=1:3
  Source=Sources(:,y)/max(Sources(:,y));
  Sensor=Sensores(:,:,z)/max(max(Sensores(:,:,z)));
  % Preparando datos espectrales
   r=zeros(371,1);
   g=zeros(371,1);
   b=zeros(371,1);
   r(:,1)=Sensor(1:371,1)/max(Sensor(1:371,1));%Respuesta en sensor r
   g(:,1)=Sensor(1:371,2)/max(Sensor(1:371,2));%Respuesta en sensor g
   b(:,1)=Sensor(1:371,3)/max(Sensor(1:371,3));%Respuesta en sensor b
   
   % Spectral interaction Camera-sensor
   Interaction_R=Source.*r;
   Interaction_G=Source.*g;
   Interaction_B=Source.*b;
   Interaction=zeros(371,3);
   Interaction(:,1)=Interaction_R;
   Interaction(:,2)=Interaction_G;
   Interaction(:,3)=Interaction_B;
   Interaction=Interaction/max(max(Interaction));
   % Iniciando matriz de imagen
   Img_r_1=zeros(Fi,Col);
   Img_g_1=zeros(Fi,Col);
   Img_b_1=zeros(Fi,Col);

   for i=1:Fi
       for j=1:Col
                for k=1:371
                                        
                    Img_r_1(i,j)=Img_r_1(i,j)+(Interaction(k,1)*Full_espectro(k,i,j));
                    Img_g_1(i,j)=Img_g_1(i,j)+(Interaction(k,2)*Full_espectro(k,i,j));
                    Img_b_1(i,j)=Img_b_1(i,j)+(Interaction(k,3)*Full_espectro(k,i,j));
            
                end
       end
   end

            %Normalización  sin balance de ganancia
            Imagen=zeros(Fi,Col,Can);
            Imagen(:,:,1)=Img_r_1;
            Imagen(:,:,2)=Img_g_1;
            Imagen(:,:,3)=Img_b_1;
            Imagen=Imagen/max2(Imagen);
            Imagen=255*Imagen;
            close all
            subplot(1,3,1),plot(Lambda,Source)
            pbaspect([1 1 1])
  set(gca,'fontsize',14);
  xlabel('Lambda in nm')
  ylabel('Spectral content')
if y==1
      title(['Fuente:',Source_1])
  elseif y==2
      title(['Fuente:',Source_2])
  elseif y==3
      title(['Fuente:',Source_3])
  elseif y==4
      title(['Fuente:',Source_4])
  elseif y==5
      title(['Fuente:',Source_5])
  elseif y==6
      title(['Fuente:',Source_6])
  elseif y==7
      title(['Fuente:',Source_7])
  elseif y==8
      title(['Fuente:',Source_8])
  elseif y==9
      title(['Fuente:',Source_9])
  elseif y==10
      title(['Fuente:',Source_10])
  elseif y==11
      title(['Fuente:',Source_11])
  elseif y==12
      title(['Fuente:',Source_12])
  elseif y==13
      title(['Fuente:',Source_13])
  elseif y==14
      title(['Fuente:',Source_14])
  elseif y==15
      title(['Fuente:',Source_15])
end

  axis on
  axis([390 760 0 1])
  pbaspect([1 1 1])
  
  subplot(1,3,2),plot(Lambda,Sensor(:,1),'r')
  pbaspect([1 1 1])
      hold on
      plot(Lambda,Sensor(:,2),'g')
      plot(Lambda,Sensor(:,3),'b')
      set(gca,'fontsize',14);
      xlabel('Lambda in nm')
      ylabel('Spectral content')
      title(['Cámara tipo: ',num2str(z)])
      axis on
      axis([390 760 0 1])
      
      subplot(1,3,3),imshow(uint8(Imagen))
      pbaspect([1 1 1])
      pause(0.1)
      
end
end
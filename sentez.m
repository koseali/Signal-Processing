clc
clear all;
close all;
matris = parseMusicXML('muzik/nota.musicxml');

fs=44100; 
range=size(matris);
%    Harmonik Sayýsý Belirleme 
harmonik = 3;
%Zarflamada kullanilacak degiskenler
adsrzarf = [];
expzarf= [];
%Sentezlenmis notalari tutacak degisken
eser =[];
 % ADSR ENVELOPE = 1  EXPONANTIAL ENVELOPE = 2
 zarf = 2;
 %____________________________Nota Islemleri_____________________________%
            %Nota bazýnda olan tüm Islemler burada yapýlmaktadýr.
for i=1: range(1)
    
   frekans = note(matris(i,4));
   
   t=0:1/fs:matris(i,7);
   
   nota = cos(2*pi*frekans*t);
   %----------------------------------------------------------------------%
   %______________________Harmonik Islemleri______________________________%
        % k degeri 2 den baslama sebebi k=1 için harmonik deger yoktur.
   for k=2:harmonik 
       har= (1/k)*cos(2*pi*k*frekans*t);
       nota = nota + har;
     
       
   end  
   %----------------------------------------------------------------------%
  
   
   %__________________________ADSR ENVELOPE_______________________________%
     if(zarf ==1) 
      
          duraksama= length(t);
         
        adsrzarf = [linspace( 0, 1.5, round(duraksama/ 5)) linspace(1.5,1,round(duraksama/10)) ones(1,round(duraksama/2)) linspace(1,0,round(duraksama/5))];
       nota = nota .* adsrzarf;
 
     end
   %----------------------------------------------------------------------%
     %______________________ EXPONENTIAL ENVELOPE_________________________%
      if(zarf==2) 
         % t = notalar;
     expzarf =  exp( -t /matris(i,2));
      nota = nota .* expzarf;
  
     
      end
   %----------------------------------------------------------------------%
   eser = [eser nota];
end

%_____________________________Reverb Etkisi_______________________________%
reverb = reverberator('PreDelay',0.5,'WetDryMix',1);
%Reverb Fonksiyonunda Sütun olarak islem gerceklestiginden transpz. alýncak
yanki = eser'; 
%Transpozesi alinan eser yankiya atanarak reverb islemi gerceklestirilir.
muzik= reverb(yanki);
%Reverblenmis eser son olarak caldirilir.
sound(muzik,44100);
%-------------------------------------------------------------------------%
%____________________________Tercih Caldirmalar___________________________%

%Reverbsiz ,Zarfli ve Harmonikli Hali ise burada ustteki caldirma
%kapatýlarak yapilabilir. Reverb fonksiyonu cizirti yapmaktadir. 
%Soz konusu bir yanlislik yoktur.
%sound(eser,44100);

%-------------------------------------------------------------------------%

% __________Secilen Zarf ve Harmonik Sayisina gore Cizilen Grafik_________%
title('Harmonikli ve Zarfli');
hold on;
plot(eser);
legend('Harmonikli ve Zarfli');

%-------------------------------------------------------------------------%
%_______Secilen Zar ve Harmonik Sayisina gore Yanki Eklenmis Grafik_______%
figure
title('Reverb Etkisi');
hold on;
plot(muzik);
legend('Reverb etkisi');
%-------------------------------------------------------------------------%


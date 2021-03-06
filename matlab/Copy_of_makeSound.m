% Clear and close all
close all
clear all

% Read all audio files and extract fs
% Baby sounds
baby_crying_1 = ('baby_signals/baby-crying.wav');
[x_baby_crying_1, fs_baby_crying_1] = audioread(baby_crying_1);
baby_crying_2 = ('baby_signals/baby-crying-01.wav');
[x_baby_crying_2, fs_baby_crying_2] = audioread(baby_crying_2);
baby_talking = ('baby_signals/baby-talking_8khz.wav');
[x_baby_talking, fs_baby_talking] = audioread(baby_talking);
% Noise sounds
noise_bird = ('noise_signals/bird_chirp_ext_8khz.wav');
[x_noise_bird, fs_noise_bird] = audioread(noise_bird);
noise_traffic = ('noise_signals/traffic-noise-01(dobelnsgatan).wav');
[x_noise_traffic, fs_noise_traffic] = audioread(noise_traffic);
noise_ventilation = ('noise_signals/ventilation_8khz.wav');
[x_noise_ventilation, fs_noise_ventilation] = audioread(noise_ventilation);
noise_amb_lib = ('noise_signals/noise_ambient_library_2.wav');
[x_noise_amb_lib, fs_noise_amb_lib] = audioread(noise_amb_lib);
noise_traff_inter = ('noise_signals/noise_traffic_intersection.wav');
[x_noise_traff_inter, fs_noise_traff_inter] = audioread(noise_traff_inter);

% Add noise to baby recordings
L_baby_crying_1=length(x_baby_crying_1);
L_baby_crying_2=length(x_baby_crying_2);
L_baby_talking=length(x_baby_talking);

L_noise_bird=length(x_noise_bird);
L_noise_traffic=length(x_noise_traffic);
L_noise_ventilation=length(x_noise_ventilation);
L_noise_amb_lib=length(x_noise_amb_lib);
L_noise_traff_inter=length(x_noise_traff_inter);

xL_baby_crying1=min(L_baby_crying_1,min(L_noise_bird,min(L_noise_traffic,...
    min(L_noise_ventilation,min(L_noise_amb_lib,L_noise_traff_inter)))));
xL_baby_crying2=min(L_baby_crying_2,min(L_noise_bird,min(L_noise_traffic,...
    min(L_noise_ventilation,min(L_noise_amb_lib,L_noise_traff_inter)))));
xL_baby_talking=min(L_baby_talking,min(L_noise_bird,min(L_noise_traffic,...
    min(L_noise_ventilation,min(L_noise_amb_lib,L_noise_traff_inter)))));

% Version:
% 0 - clean, without any noise                        
% 1 - slightly amp bird & vent noise added      Nstrength=2
% 2 - slightly amp (all) noise files added      Nstrength=2
% 3 - highly amp (all) noise files added        Nstrength=5

% Baby crying 1
x_BC10=x_baby_crying_1(1:xL_baby_crying1);
Nstrength = 2;
x_BC11=x_baby_crying_1(1:xL_baby_crying1)+...
    Nstrength*x_noise_bird(1:xL_baby_crying1)+...
    Nstrength*x_noise_ventilation(1:xL_baby_crying1);
x_BC12=x_baby_crying_1(1:xL_baby_crying1)+...
    Nstrength*x_noise_bird(1:xL_baby_crying1)+...
    Nstrength*x_noise_traffic(1:xL_baby_crying1)+...
    Nstrength*x_noise_ventilation(1:xL_baby_crying1)+...
    Nstrength*x_noise_amb_lib(1:xL_baby_crying1)+...
    Nstrength*x_noise_traff_inter(1:xL_baby_crying1);
Nstrength = 5;
x_BC13=x_baby_crying_1(1:xL_baby_crying1)+...
    Nstrength*x_noise_bird(1:xL_baby_crying1)+...
    Nstrength*x_noise_traffic(1:xL_baby_crying1)+...
    Nstrength*x_noise_ventilation(1:xL_baby_crying1)+...
    Nstrength*x_noise_amb_lib(1:xL_baby_crying1)+...
    Nstrength*x_noise_traff_inter(1:xL_baby_crying1);

% Baby Crying 2
N=2;
x_BC20=N*x_baby_crying_2(1:xL_baby_crying2);
Nstrength = 2;
x_BC21=N*x_baby_crying_2(1:xL_baby_crying2)+...
    Nstrength*x_noise_bird(1:xL_baby_crying2)+...
    Nstrength*x_noise_ventilation(1:xL_baby_crying2);
x_BC22=N*x_baby_crying_2(1:xL_baby_crying2)+...
    Nstrength*x_noise_bird(1:xL_baby_crying2)+...
    Nstrength*x_noise_traffic(1:xL_baby_crying2)+...
    Nstrength*x_noise_ventilation(1:xL_baby_crying2)+...
    Nstrength*x_noise_amb_lib(1:xL_baby_crying2)+...
    Nstrength*x_noise_traff_inter(1:xL_baby_crying2);
Nstrength = 5;
x_BC23=N*x_baby_crying_2(1:xL_baby_crying2)+...
    Nstrength*x_noise_bird(1:xL_baby_crying2)+...
    Nstrength*x_noise_traffic(1:xL_baby_crying2)+...
    Nstrength*x_noise_ventilation(1:xL_baby_crying2)+...
    Nstrength*x_noise_amb_lib(1:xL_baby_crying2)+...
    Nstrength*x_noise_traff_inter(1:xL_baby_crying2);

% Baby talking
N=3;
x_BT0=N*x_baby_talking(1:xL_baby_talking);
Nstrength = 2;
x_BT1=N*x_baby_talking(1:xL_baby_talking)+...
    Nstrength*x_noise_bird(1:xL_baby_talking)+...
    Nstrength*x_noise_ventilation(1:xL_baby_talking);
x_BT2=N*x_baby_talking(1:xL_baby_talking)+...
    Nstrength*x_noise_bird(1:xL_baby_talking)+...
    Nstrength*x_noise_traffic(1:xL_baby_talking)+...
    Nstrength*x_noise_ventilation(1:xL_baby_talking)+...
    Nstrength*x_noise_amb_lib(1:xL_baby_talking)+...
    Nstrength*x_noise_traff_inter(1:xL_baby_talking);
Nstrength = 5;
x_BT3=N*x_baby_talking(1:xL_baby_talking)+...
    Nstrength*x_noise_bird(1:xL_baby_talking)+...
    Nstrength*x_noise_traffic(1:xL_baby_talking)+...
    Nstrength*x_noise_ventilation(1:xL_baby_talking)+...
    Nstrength*x_noise_amb_lib(1:xL_baby_talking)+...
    Nstrength*x_noise_traff_inter(1:xL_baby_talking);

% % Plot the new signal
% figure;
% plot1 = subplot(411);
% plot(x_BC10(1:xL_baby_crying1));
% xlabel('Power')
% title('{\bf clean}')
% plot2 = subplot(412);
% plot(x_BC11(1:xL_baby_crying1));
% xlabel('Power')
% title('{\bf bird and ventilation noise added}')
% plot3 = subplot(413);
% plot(x_BC12(1:xL_baby_crying1));
% xlabel('Power')
% title('{\bf all the noise added}')
% plot4 = subplot(414);
% plot(x_BC13(1:xL_baby_crying1));
% xlabel('Power')
% title('{\bf all the noise added and amplified}')
% set(gcf,'numbertitle','off','name','Baby crying.wav')
% % linkaxes([plot1,plot2,plot3,plot4],'y');
% 
% figure;
% plot1 = subplot(411);
% plot(x_BC20(1:xL_baby_crying2));
% xlabel('Power')
% title('{\bf clean}')
% plot2 = subplot(412);
% plot(x_BC21(1:xL_baby_crying2));
% xlabel('Power')
% title('{\bf bird and ventilation noise added}')
% plot3 = subplot(413);
% plot(x_BC22(1:xL_baby_crying2));
% xlabel('Power')
% title('{\bf all the noise added}')
% plot4 = subplot(414);
% plot(x_BC23(1:xL_baby_crying2));
% xlabel('Power')
% title('{\bf all the noise added and amplified}')
% set(gcf,'numbertitle','off','name','Baby crying1.wav')
% % linkaxes([plot1,plot2,plot3,plot4],'y');
% 
% figure;
% plot1 = subplot(411);
% plot(x_BT0(1:xL_baby_talking));
% ylim([-1 1]);
% xlabel('Power')
% title('{\bf clean}')
% plot2 = subplot(412);
% plot(x_BT1(1:xL_baby_talking));
% xlabel('Power')
% title('{\bf bird and ventilation noise added}')
% plot3 = subplot(413);
% plot(x_BT2(1:xL_baby_talking));
% xlabel('Power')
% title('{\bf all the noise added}')
% plot4 = subplot(414);
% plot(x_BT3(1:xL_baby_talking));
% xlabel('Power')
% title('{\bf all the noise added and amplified}')
% set(gcf,'numbertitle','off','name','Baby talking.wav')
% % linkaxes([plot1,plot2,plot3,plot4],'y');

close all;
clear all;
clc;

addpath('code');

load('db/Удары/аперкот/data.mat');
load('db/Удары/кросс/data.mat');
load('db/Удары/свинг/data.mat');
load('db/Удары/сила удара/data.mat');
% load('db/Удары/p_3/data.mat');
% load('db/Удары/p_4/data.mat');
% load('D:\BioWave\motion\matlab\db\Удары\сила удара грав\data.mat')

% Check for NaNs
if (isnan(acc_x(end)) || isnan(acc_y(end)) || isnan(acc_y(end)) || ...
    isnan(gyr_x(end)) || isnan(gyr_y(end)) || isnan(gyr_z(end)) )
  acc_x=acc_x(1:end-1);
  acc_y=acc_y(1:end-1);
  acc_z=acc_z(1:end-1);
  gyr_x=gyr_x(1:end-1);
  gyr_y=gyr_y(1:end-1);
  gyr_z=gyr_z(1:end-1);
end

% Signal and processing parameters
len=numel(acc_x);
% 1/mean(diff(t))
fs=1000;
t=0:1/fs:(len-1)/fs;
skip=round(1*fs);

% Preprocessing
% acc_x=acc_x-mean(acc_x(1:100));
% acc_y=acc_y-mean(acc_y(1:100));
% acc_z=acc_z-mean(acc_z(1:100));
% acc_x=acc_x-movAvr.vecCent(acc_x,4*fs)';
% acc_y=acc_y-movAvr.vecCent(acc_y,4*fs)';
% acc_z=acc_z-movAvr.vecCent(acc_z,4*fs)';
% acc_x=acc_x-mean(acc_x);
% acc_y=acc_y-mean(acc_y);
% acc_z=acc_z-mean(acc_z);
% sz=3000;
% for i=1:(sz+1):len
%   if i+sz<=len
%     acc_x(i:i+sz)=acc_x(i:i+sz)-mean(acc_x(i:i+sz));
%     acc_y(i:i+sz)=acc_y(i:i+sz)-mean(acc_y(i:i+sz));
%     acc_z(i:i+sz)=acc_z(i:i+sz)-mean(acc_z(i:i+sz));
%   else
%     acc_x(i:len)=acc_x(i:len)-mean(acc_x(i:len));
%     acc_y(i:len)=acc_y(i:len)-mean(acc_y(i:len));
%     acc_z(i:len)=acc_z(i:len)-mean(acc_z(i:len));
%   end
% end

% N    = 2000;      % Order
% Fc   = 0.2;        % Cutoff Frequency
% flag = 'scale';  % Sampling Flag
% % Create the window vector for the design algorithm.
% win = hann(N+1);
% % Calculate the coefficients using the FIR1 function.
% b  = fir1(N, Fc/(fs/2), 'high', win, flag);
% acc_x=filtfilt(b,1,acc_x);
% acc_y=filtfilt(b,1,acc_y);
% acc_z=filtfilt(b,1,acc_z);

[b,i]=hist(acc_x,20);
[~,idx]=max(b);
acc_x=acc_x-i(idx);
[b,i]=hist(acc_y,20);
[~,idx]=max(b);
acc_y=acc_y-i(idx);
[b,i]=hist(acc_z,20);
[~,idx]=max(b);
acc_z=acc_z-i(idx);

% Motion detection
% m=(log(sqrt(acc_x.*acc_x+acc_y.*acc_y+acc_z.*acc_z)));
% m=movAvr.vecCent(m,60);
m=log(sqrt(acc_x.*acc_x.*acc_x.*acc_x+acc_y.*acc_y.*acc_y.*acc_y+acc_z.*acc_z.*acc_z.*acc_z));
m=movAvr.vecCent(m,round(fs/2)); %10
% m=accMovAv(m,0.999);
% m(1:end-999)=m(1000:end);
m=m-mean(m);
m(m<0)=0;

m_start=[];
m_stop=[];
th=0.1;
m_start_flag=1;
for i=skip:len-skip
  if (m_start_flag>0)
    if (m(i)>=0.25) % 0.1
      m_start=[m_start,i];
      m_start_flag=0;
    end    
  else
    if (m(i)<0.1 && (i-m_start(end))>fs*0.5) % 0.005
      m_stop=[m_stop,i];
      m_start_flag=1;
    end   
  end
end
disp(['# of detected motions (starts): ',num2str(numel(m_start))]);
disp(['# of full motions (starts+stops): ',num2str(numel(m_stop))]);

% Punch power
bodyMass=70;
handMass=0.047*bodyMass;
f=abs(acc_x)+abs(acc_y)+abs(acc_z);
idx_buf=zeros(size(m_stop));
for i=1:numel(m_stop)
  [f_i,idx_buf(i)]=max(f(m_start(i):m_stop(i)));
  idx_buf(i)=idx_buf(i)+m_start(i)-1;
  disp(['Punch ',num2str(i),':']);
  disp(['p = m*a = ',num2str(handMass),'*',num2str(f_i),' = ',num2str(handMass*f_i)]);
end

% Visualization
figure
hs(1)=subplot(3,1,1);
plot(t,acc_x,'r','DisplayName','force_accel_x');hold all;
plot(t,acc_y,'g','DisplayName','force_accel_y');
plot(t,acc_z,'b','DisplayName','force_accel_z');
yL = get(gca,'YLim');
for i=1:numel(m_start)
  line([m_start(i)/fs,m_start(i)/fs],yL,'Linewidth',2,'Color','g');
end
for i=1:numel(m_stop)
  line([m_stop(i)/fs,m_stop(i)/fs],yL,'Linewidth',2,'Color','r');
end
xlim([t(1) t(end)]);
hold off;
legend('a_X','a_Y','a_Z');
ylabel('a, m/s^2');
grid on;

hs(2)=subplot(3,1,2);
plot(t,m,'Color',[0 0 0],'Linewidth',2,'DisplayName','Magnitude'); hold on;
yL = get(gca,'YLim');
for i=1:numel(m_start)
  line([m_start(i)/fs,m_start(i)/fs],yL,'Linewidth',2,'Color','g');
end
for i=1:numel(m_stop)
  line([m_stop(i)/fs,m_stop(i)/fs],yL,'Linewidth',2,'Color','r');
end
title('Signal used for segmentation');
xlim([t(1) t(end)]);
grid on;

hs(3)=subplot(3,1,3);
plot(t,f,'Color',[0 0 0.1],'Linewidth',2,'DisplayName','Magnitude'); hold on;
yL = get(gca,'YLim');
for i=1:numel(m_start)
  line([m_start(i)/fs,m_start(i)/fs],yL,'Linewidth',2,'Color','g');
end
for i=1:numel(m_stop)
  line([m_stop(i)/fs,m_stop(i)/fs],yL,'Linewidth',2,'Color','r');
end
plot(t(idx_buf),f(idx_buf),'*r','Linewidth',2);
xlim([t(1) t(end)]);
xlabel('t, s');
ylabel('a_X_Y_Z, m/s^2');
grid on;

linkaxes(hs,'x');
% pause;
% 
% figure
% x_pos=accMovAv(accMovAv(acc_x,0.999),0.999);
% y_pos=accMovAv(accMovAv(acc_y,0.999),0.999);
% z_pos=accMovAv(accMovAv(acc_z,0.999),0.999);
% subplot(3,2,1);
% plot(t,x_pos);
% grid on;
% subplot(3,2,3);
% plot(t,y_pos);
% grid on;
% subplot(3,2,5);
% plot(t,z_pos);
% grid on;
% subplot(3,2,[2,4,6]);
% % XYZ = stream3(x_pos,y_pos,z_pos,0,0,0) 
% grid on;
% comet3(x_pos,y_pos,z_pos);
% set(gca,'EraseMode','none');



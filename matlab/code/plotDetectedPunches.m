function fig=plotDetectedPunches(acc_x,acc_y,acc_z,t,fs,m_start,m_stop,m,f,punchesIdxBuf)
  fig=figure;
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
  plot(t(punchesIdxBuf),f(punchesIdxBuf),'*r','Linewidth',2);
  xlim([t(1) t(end)]);
  xlabel('t, s');
  ylabel('a_X_Y_Z, m/s^2');
  grid on;

  linkaxes(hs,'x');
end
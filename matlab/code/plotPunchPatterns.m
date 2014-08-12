function fig=plotPunchPatterns(acc_x,acc_y,acc_z,pat_x,pat_y,pat_z,t,fs,m_start,m_stop)
  fig=figure;
  hs(1)=subplot(4,1,1);
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

  hs(2)=subplot(4,1,2);
  plot(t,pat_x,'Color',[0 0 0],'Linewidth',2);
  yL = get(gca,'YLim');
  for i=1:numel(m_start)
    line([m_start(i)/fs,m_start(i)/fs],yL,'Linewidth',2,'Color','g');
  end
  for i=1:numel(m_stop)
    line([m_stop(i)/fs,m_stop(i)/fs],yL,'Linewidth',2,'Color','r');
  end
  xlim([t(1) t(end)]);
  hold off;
  ylabel('X');
  grid on;

  hs(3)=subplot(4,1,3);
  plot(t,pat_y,'Color',[0 0 0],'Linewidth',2);
  yL = get(gca,'YLim');
  for i=1:numel(m_start)
    line([m_start(i)/fs,m_start(i)/fs],yL,'Linewidth',2,'Color','g');
  end
  for i=1:numel(m_stop)
    line([m_stop(i)/fs,m_stop(i)/fs],yL,'Linewidth',2,'Color','r');
  end
  xlim([t(1) t(end)]);
  hold off;
  ylabel('Y');
  grid on;

  hs(4)=subplot(4,1,4);
  plot(t,pat_z,'Color',[0 0 0],'Linewidth',2);
  yL = get(gca,'YLim');
  for i=1:numel(m_start)
    line([m_start(i)/fs,m_start(i)/fs],yL,'Linewidth',2,'Color','g');
  end
  for i=1:numel(m_stop)
    line([m_stop(i)/fs,m_stop(i)/fs],yL,'Linewidth',2,'Color','r');
  end
  xlim([t(1) t(end)]);
  hold off;
  xlabel('t, s');
  ylabel('Z');
  grid on;

  linkaxes(hs,'x');
end
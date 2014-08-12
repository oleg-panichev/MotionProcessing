% Function for detection punches in the signal
%
function [m_start,m_stop,m]=detectPunches(acc_x,acc_y,acc_z,fs,skip)
  len=length(acc_x);
  m=(log(sqrt(acc_x.*acc_x+acc_y.*acc_y+acc_z.*acc_z)));
  m=movAvr.vecCent(m,round(fs/2)); %10
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
end
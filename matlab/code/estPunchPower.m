% Function for punch power estimation
%
function [punchesPowerBuf,punchesIdxBuf,f]=estPunchPower(bodyMass,acc_x, ...
    acc_y,acc_z,m_start,m_stop)
  handMass=0.047*bodyMass;
  f=abs(acc_x)+abs(acc_y)+abs(acc_z);
  punchesIdxBuf=zeros(size(m_stop));
  punchesPowerBuf=zeros(size(m_stop));
  for i=1:numel(m_stop)
    [f_i,punchesIdxBuf(i)]=max(f(m_start(i):m_stop(i)));
    punchesIdxBuf(i)=punchesIdxBuf(i)+m_start(i)-1;
    punchesPowerBuf(i)=handMass*f_i;
    disp(['Punch ',num2str(i),':']);
    disp(['p = m*a = ',num2str(handMass),'*',num2str(f_i),' = ',num2str(handMass*f_i)]);
  end
end
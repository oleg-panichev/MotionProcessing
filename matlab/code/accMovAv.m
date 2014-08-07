function [y]=accMovAv(x,m)
  if (m<=0 || m>=1)
    warning('Variable m should be 0<m<1. Default value was used m=0.995.');
    m=0.995;
  end
  len=numel(x);
  y=zeros(size(x));
  for i=2:len
    y(i)=m*y(i-1)+(1-m)*x(i);
  end
end
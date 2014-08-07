% Median fileter with kernek
% Input:
% x - input vector
% w - window size in samples
% k - kernel size in percents (0:1)
% Output:
% y - output vector
%
function y=medianFilter(x,w,k)
  len=numel(x);
  y=zeros(len,1);
  hw=round(w/2);
  if (hw<1)
    hw=1;
  end
  for i=1:len
    i1=i-hw;
    if (i1<1)
      i1=1;
    end
    i2=i+hw;
    if (i2>len)
      i2=len;
    end
    y(i)=medianKernel(x(i1:i2),k);
  end
end
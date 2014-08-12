% Function for filtering accelerometer data
%
function [acc_x,acc_y,acc_z]=filterAcc(acc_x,acc_y,acc_z)
  [b,i]=hist(acc_x,20);
  [~,idx]=max(b);
  acc_x=acc_x-i(idx);
  [b,i]=hist(acc_y,20);
  [~,idx]=max(b);
  acc_y=acc_y-i(idx);
  [b,i]=hist(acc_z,20);
  [~,idx]=max(b);
  acc_z=acc_z-i(idx);
end
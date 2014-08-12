% Function for removing NaNs in the end and trim the data
%
function [acc_x,acc_y,acc_z,gyr_x,gyr_y,gyr_z] = ...
    removeNaNs(acc_x,acc_y,acc_z,gyr_x,gyr_y,gyr_z)
  if (isnan(acc_x(end)) || isnan(acc_y(end)) || isnan(acc_y(end)) || ...
      isnan(gyr_x(end)) || isnan(gyr_y(end)) || isnan(gyr_z(end)) )
    acc_x=acc_x(1:end-1);
    acc_y=acc_y(1:end-1);
    acc_z=acc_z(1:end-1);
    gyr_x=gyr_x(1:end-1);
    gyr_y=gyr_y(1:end-1);
    gyr_z=gyr_z(1:end-1);
  end
end
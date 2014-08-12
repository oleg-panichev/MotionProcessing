% Function for obtaining punch patterns 
%
function [pat_x,pat_y,pat_z]=getPunchPatterns(acc_x,acc_y,acc_z,m_start,m_stop, ...
    segNum,compCoef)
  pat_x=zeros(size(acc_x));
  pat_y=zeros(size(acc_y));
  pat_z=zeros(size(acc_z));
  for i=1:numel(m_stop)
    pLen=round((m_stop(i)-m_start(i))/segNum);
    for j=1:segNum
      if (j==1)
        % X
        pat_x((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen))=0;
        mean_x_prev=mean(acc_x((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen)));
        val_pat_x_prev=0;
        % Y
        pat_y((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen))=0;
        mean_y_prev=mean(acc_y((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen)));
        val_pat_y_prev=0;
        % Z
        pat_z((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen))=0;
        mean_z_prev=mean(acc_z((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen)));
        val_pat_z_prev=0;
      else
        % X
        mean_x=mean(acc_x((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen)));
        if (abs(mean_x)>abs((1+compCoef)*mean_x_prev))
          val_pat_x_prev=val_pat_x_prev+1;
        elseif (abs(mean_x)<abs((1-compCoef)*mean_x_prev))
          val_pat_x_prev=val_pat_x_prev-1;
        end
        pat_x((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen))=val_pat_x_prev;
        % Y
        mean_y=mean(acc_y((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen)));
        if (abs(mean_y)>abs((1+compCoef)*mean_y_prev))
          val_pat_y_prev=val_pat_y_prev+1;
        elseif (abs(mean_y)<abs((1-compCoef)*mean_y_prev))
          val_pat_y_prev=val_pat_y_prev-1;
        end
        pat_y((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen))=val_pat_y_prev;
        % Z
        mean_z=mean(acc_z((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen)));
        if (abs(mean_z)>abs((1+compCoef)*mean_z_prev))
          val_pat_z_prev=val_pat_z_prev+1;
        elseif (abs(mean_z)<abs((1-compCoef)*mean_z_prev))
          val_pat_z_prev=val_pat_z_prev-1;
        end
        pat_z((m_start(i)+(j-1)*pLen):(m_start(i)+(j)*pLen))=val_pat_z_prev;
      end
    end
  end
end
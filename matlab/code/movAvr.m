% movAvr     Moving average module
%
% Syntax:
%   movAvr = movAvr();
%   movAvr.init(len, initVal);
%   movAvr.reInit(len, initVal);
%   avr = movAvr.put(in);
%   avr = movAvr.get();
%
% Description: 
%   Put new value to moving average and calculate new averaged value
%
% Vasiliy Nerosin, 2012-12-24
%
classdef movAvr < handle
  %movAvr    Moving average module

  %% Properties
  properties (SetAccess='private')
    dLine;
    divider;
    accSum;
    idxOld;
  end

  %% Public methods
  methods  (Access='public')
    %% Constructor
    function obj = movAvr()
    end

    %% Intialization
    function init(obj, len, initVal)
      % Allocate delay line
      obj.dLine = zeros(1,len);
      obj.divider = len;
      obj.idxOld = 1;
      
      % Set initial value
      obj.dLine(:) = initVal;
      
      % Reset accumulators
      obj.accSum = initVal * obj.divider;
    end 
    
    
    function reInit(obj, initVal)
      % Set initial value
      obj.dLine(:) = initVal;
      
      % Reset accumulators
      obj.accSum = initVal * length(obj.dLine);
    end 

    
    %% Put new and calculate average
    %
    %  Inputs:
    %    in - can be vector
    %
    function avr=put(obj,in)
      % Old version, to understand what is going on
      %{
      % Allocate output vector
      avr=zeros(1,numel(in));
      
      for i=1:numel(in)
        % Add new
        obj.accSum = obj.accSum + in(i);

        % Sub oldest
        obj.accSum = obj.accSum - obj.dLine(obj.idxOld);

        % Shift delay line
        obj.dLine(obj.idxOld) = in(i);
        obj.idxOld = obj.idxOld + 1;
        if (obj.idxOld > numel(obj.dLine))
          obj.idxOld = 1;
        end

        % Return average
        avr(i)=obj.accSum / obj.divider;
      end
      %}
      
      % Fast version
      [avr,obj.dLine,obj.accSum,obj.idxOld]=...
        movAvrCore(in,obj.dLine,obj.accSum,obj.idxOld);
    end
    
    
    %% Get average
    function avr = get(obj)
      avr = obj.accSum / obj.divider;
    end
    
  end % methods public

  
  %% Static methods
  methods (Static)
    %% This function perform vector centered moving average
    function x=vecCent(x,lenAv)
      % Fast version
      len=numel(x);
      if (size(x,1)>size(x,2))
        x=x';
      end
      x=[ones(1,lenAv*2)*x(1),x,ones(1,lenAv*2)*x(end)];
      dLine_=zeros(1,lenAv);
      idxOld_=1;
      accSum_=0;
      [x,~,~,~]=movAvrCore(x,dLine_,accSum_,idxOld_);
      x=x((lenAv*2+round(lenAv/2))+(1:len)-1);
    end
  end % methods (Static)

end % classdef

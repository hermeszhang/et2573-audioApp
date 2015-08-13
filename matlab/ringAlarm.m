function [ Trace,ring,value ] = ringAlarm( P, threshold, alarm )
%   UNTITLED calculates when the alarm should go off
%
%   Input: P-power array, threshold value, alarm counter
%   Output: Trace-array, index for trigger frame, value of the frame 

    row=size(P,1);
    Trace=zeros(row,1);
    ring=0;
    value=0;
    for i=1:row
        P(i,1);
        if  P(i,1) > threshold
            Trace(i,1)=P(i,1);
            alarm=alarm+1;
            if alarm == 5
                ring=i;
                value=P(i,1);
                disp('ALARM!');
            end
        end
    end
  
%     if alarm == 0 & alarm < 5
%         disp('equals 0 ?');
%         ring=0
%         value=0
%     end
%    ring
%    value
end


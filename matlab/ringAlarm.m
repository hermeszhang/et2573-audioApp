function [ Trace,ring,value ] = Untitled( P, threshold, alarm )
%   UNTITLED calculates when the alarm should go off
%
%   Input: P-power array, threshold value, alarm counter
%   Output: Trace-array, index for trigger frame, value of the frame 

    row=size(P,1);
    Trace=zeros(row,1);

    for i=1:row
        if  P(i,1) > threshold
            Trace(i,1)=P(i,1);
            alarm=alarm+1;
            if alarm == 5
                ring=i;
                value=P(i,1);
            end
        end
    end
end


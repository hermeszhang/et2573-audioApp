function [ P ] = simple_reverseAverg( buffSquared, alpha )
%   SIMPLE_REVERSEAVERG function calculates reverse averaging given a squared
%   buffer
%   Input: buffSquared, 
%   Output: P - array with reversed averaging power calculations

    for i=1:n
        vec(i,1)=sum(buffSquared(1:end,i));
    end
    
    row = size(vec,1);
    P=zeros(row,1);

    P(1,1)=0;
    for i=2:size(vec,1)-1
        P(i,1)=alpha*P(i-1,1) + (1-alpha)*vec(i,1);
    end


end

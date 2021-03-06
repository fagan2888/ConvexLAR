function [value,isterminal,direction]=event3_GLM(t,f,x,y,distname,actind,actindG,p2,index,weightG,method)
% Function:
%   Define the event function used by ode45
%
% Arguments:
%   t, f
%   x: covariates x (matrix)
%   y: response y (vector)
%   actind: active index set
%   distname: name of distribution 
%
% Output:
%   [value,isterminal,direction]
inactindG=setdiff(1:p2, actindG);    
deriv=getderiv_GLM(x, y, actind, f, distname);
derivG=zeros(p2,1);
switch lower(method)
    case {'grouplarl2', 'grouplar'}
    for i=1:p2
        derivG(i)=sqrt(sum((deriv(index==i)).^2));
    end
    case 'grouplarl1'
    for i=1:p2
        derivG(i)=sum(abs(deriv(index==i)));
    end
    otherwise
    disp('Unknown method.')
end
% value is the value of the ith event function
value=min(derivG(actindG).*weightG(actindG))- ...
    max(derivG(inactindG).*weightG(inactindG)); 
% the integration is to terminate at a zero of this event function
isterminal = 1; 
% direction = 0 if all zeros are to be located
direction = 0;
 
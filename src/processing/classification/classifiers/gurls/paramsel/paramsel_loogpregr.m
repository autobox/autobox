function vout = paramsel_loogpregr(X,y,opt)
% paramsel_loogpregr(X,Y,OPT)
% Performs parameter selection for gaussian process regression.
% The leave-one-out approach is used.
%
% INPUTS:
% -X: input data matrix
% -Y: labels matrix
% -OPT: structure of options with the following fields:
%
%   For more information on standard OPT fields
%   see also defopt
% 
% OUTPUT: struct with the following fields:
% -lambdas: array of values of the regularization parameter lambda
%           minimizing the validation error for each class
% -perf: perf is a matrix with the validation error for each lambda guess 
%        and for each class
% -guesses: array of guesses for the regularization parameter lambda 


if isfield (opt,'paramsel')
	vout = opt.paramsel; % lets not overwrite existing parameters.
			      		 % unless they have the same name
end

[n,T]  = size(y);
tot = opt.nlambda;
K = opt.kernel.K;

lmax = mean(std(y));
lmin = mean(std(y))*10^-5;
guesses = lmin.*(lmax/lmin).^linspace(0,1,tot);

perf = zeros(tot,T);
for k = 1:n;
    tr = setdiff(1:n,k);
    opt.kernel.K = K(tr,tr);
    opt.predkernel.K = K(k,tr);
    opt.predkernel.Ktest = K(k,k);
    for i = 1:tot
        opt.paramsel.lambdas = guesses(i);
        opt.rls = rls_gpregr(X(tr,:),y(tr,:),opt);
        tmp = pred_gpregr(X(k,:),y(k,:),opt);
        opt.pred = tmp.means;
        opt.perf = opt.hoperf([],y(k,:),opt);
        for t = 1:T
            perf(i,t) = opt.perf.forho(t)./n+perf(i,t);
        end	
    end
end	

[dummy,idx] = max(perf,[],1);	
vout.lambdas = 	guesses(idx);
vout.perf = 	perf;
vout.guesses = 	guesses;

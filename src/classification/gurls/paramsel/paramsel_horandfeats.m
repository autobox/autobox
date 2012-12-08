function [vout] = paramsel_horandfeats(X,y,opt)
% paramsel_horandfeat(X,Y,OPT)
% Performs parameter selection when the primal formulation of RLS is used.
% The hold-out approach is used. 
% The performance measure specified by opt.hoperf is maximized.
%
% INPUTS:
% -X: input data matrix
% -Y: labels matrix
% -OPT: struct of options with the following fields:
%   fields that need to be set through previous gurls tasks:
%		- split (set by the split_* routine)
%   fields with default values set through the defopt function:
%		- nlambda
%		- smallnumber
%		- hoperf
%       	- nholdouts
%
%   For more information on standard OPT fields
%   see also defopt
% 
% OUTPUTS: structure with the following fields:
% -lambdas_round: cell array (opt.nholdoutsX1). For each split a cell contains the 
%       values of the regularization parameter lambda minimizing the 
%       validation error for each class.
% -perf: cell array (opt.nholdouts). For each split a cell contains a matrix 
%       with the validation error for each lambda guess and for each class
% -guesses: cell array (opt.nholdoutsX1). For each split a cell contains an 
%       array of guesses for the regularization parameter lambda
% -lambdas: mean of the optimal lambdas across splits

if isfield (opt,'paramsel')
	vout = opt.paramsel; % lets not overwrite existing parameters.
			      		 % unless they have the same name
end

savevars = [];

for nh = 1:opt.nholdouts
	if strcmp(class(opt.split),'cell')
		tr = opt.split{nh}.tr;
		va = opt.split{nh}.va;
	else	
		tr = opt.split.tr;
		va = opt.split.va;
	end	

	[n,d] = size(X(tr,:));
	[n,T]  = size(y(tr,:));
    
    kernel = kernel_randfeats(X(tr,:), y(tr,:), opt);
	opt.kernel.W = kernel.W;
    
	tot = opt.nlambda;
	[Q,L] = eig(kernel.XtX);
	Q = double(Q);
	L = double(diag(L));
	QtXtY = Q'*kernel.Xty;
    
	guesses = paramsel_lambdaguesses(L, min(n,opt.randfeats.D*2), n, opt);
    
% % ensuring eigenvalues are sorted
% eigvals = sort(L,'descend');
% % maximum eigenvalue
% lmax = eigvals(1);
% lmin = max(eigvals(min(n,opt.randfeats.D*2)), 200*sqrt(eps));
% powers = linspace(0,1,tot);
% guesses = lmin.*(lmax/lmin).^(powers);
% guesses = guesses/n;

	perf = zeros(tot,T);
	for i = 1:tot
		opt.rls.W = rls_eigen(Q,L,QtXtY,guesses(i),n);
		opt.pred = pred_randfeats(X(va,:),y(va,:),opt);
		opt.perf = opt.hoperf(X(va,:),y(va,:),opt);
		for t = 1:T
			perf(i,t) = opt.perf.forho(t);
		end	
	end	
	[dummy,idx] = max(perf,[],1);	
	vout.lambdas_round{nh} = guesses(idx);
	vout.perf{nh} = perf;
	vout.guesses{nh} = guesses;
end

% figure
% plot(perf)

if numel(vout.lambdas_round) > 1
	lambdas = cell2mat(vout.lambdas_round');
	vout.lambdas = mean(lambdas);
else
	vout.lambdas = vout.lambdas_round{1};
end

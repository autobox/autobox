function [vout] = paramsel_hodualr(X, y, opt)
% paramsel_hopdualr(X,Y,OPT)
% Performs parameter selection when the dual formulation of RLS is used.
% The hold-out approach is used. 
% The eigendecomposition used to compute the regularization path is
% computed using a randoamized method.
% The performance measure specified by opt.hoperf is maximized.
%
% INPUTS:
% -X: input data matrix
% -Y: labels matrix
% -OPT: struct of options with the following fields:
%   fields that need to be set through previous gurls tasks:
%		- split (set by the split_* routine)
%		- kernel.K (set by the kernel_* routines)
%   fields with default values set through the defopt function:
%		- nlambda
%		- smallnumber
%		- hoperf
%       - nholdouts
%		- kernel.type
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


	[n,T]  = size(y(tr,:));
	
% 	if strcmp(opt.kernel.type,'linear')
% 		d = size(X(tr,:),2);
%         r = min(n,d);
%     else
%         r = n;
% 	end
	
    k = round(opt.eig_percentage*n/100);
	[Q,L,U] = tygert_svd(opt.kernel.K(tr,tr),k);
	Q = double(Q);
	L = double(diag(L));
	guesses = paramsel_lambdaguesses(L,k, n, opt);
	tot = opt.nlambda;
	ap = zeros(tot,T);
	
	QtY = Q'*y(tr,:);
	for i = 1:tot
		%%%%%% REPLICATING CODE FROM RLS_DUAL %%%%%%%%
		opt.rls.C = rls_eigen(Q,L,QtY,guesses(i),n);
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
		if size(X,1) > 0
			Xva = X(va,:);
			opt.rls.X = X(tr,:);
		else
			Xva = [];
		end
	
		yva = y(va,:);
		if strcmp(opt.kernel.type,'linear')
			opt.rls.W = X(tr,:)'*opt.rls.C; 
		else
			opt.predkernel.K = opt.kernel.K(va,tr);
		end	
	
		opt.pred = pred_dual(Xva,yva,opt);
		opt.perf = opt.hoperf(Xva,yva,opt);
		%p{i} = perf(scores,yho,{'precrec'});
		for t = 1:T
			ap(i,t) = opt.perf.forho(t);
		end	
	end	
	[dummy,idx] = max(ap,[],1);	
	vout.lambdas_round{nh} = guesses(idx);
	vout.perf{nh} = ap;
	vout.guesses{nh} = guesses;
end	

if numel(vout.lambdas_round) > 1
	lambdas = cell2mat(vout.lambdas_round');
	vout.lambdas = mean(lambdas);
else
	vout.lambdas = vout.lambdas_round{1};
end

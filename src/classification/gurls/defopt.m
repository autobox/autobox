function opt = defopt(expname)

if (nargin < 1)
	fprintf('Your experiment must be given a unique name\n');
end

%% Experiment options
opt.name = expname; % We can make this argument mandatory; Unique name per experiment
opt.savefile = [opt.name '.mat'];

%% Algorithm options
opt.kernel.type = 'rbf';
opt.singlelambda = @median; % give the function for combining your lambdas; could be max, min or mean, for instance.
opt.smallnumber = 1e-8; % lambda is searched between [min(eig_r, opt.smallnumber), eig_1], where r = rank, eig_1 = max eig val.

%% Random SVD options
opt.eig_percentage = 5; %percentage of eigenvectors to be used in the randomized SVD

%% GD Options

opt.gd.method = 0; % standard gradient descent
opt.gd.maxiter = 1000;
opt.gd.singleiter = @median;
opt.gd.eta_numerator = 1;
opt.gd.nu = 1;

%% CG Options
opt.cg.maxiter = 1000;
opt.cg.singleiter = @median;


%% Output options
opt.hoperf = @perf_macroavg;

opt.nholdouts = 1;
%% Data option
opt.hoproportion = 0.2;
opt.nlambda = 100;
opt.nsigma =  25;



%% Quiet
% Currenty either 0 or 1; levels of verbosity may be implemented later;
opt.verbose = 1;

%% Version info
opt.version = 1.0;

%% Online
opt.epochs = 4;
opt.subsize = 50;
opt.calibfile = 'foo';

%% Random features options
opt.randfeats.D = 500;
opt.randfeats.samplesize = 100;

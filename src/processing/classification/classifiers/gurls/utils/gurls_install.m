function path = gurls_install()

basePath = gurls_root();
addpath(basePath				);
addpath(fullfile(basePath,'kernels'		)	);
addpath(fullfile(basePath,'optimizers'		)	);
addpath(fullfile(basePath,'paramsel'		)	);
addpath(fullfile(basePath,'pred'		)	);
addpath(fullfile(basePath,'perf'		)	);
addpath(fullfile(basePath,'norm'		)	);
addpath(fullfile(basePath,'utils'		)	);
addpath(fullfile(basePath,'split'		)	);
addpath(fullfile(basePath,'summary'		)	);
addpath(fullfile(basePath,'confidence'		)	);
addpath(fullfile(basePath,'quickanddirty'	)	);


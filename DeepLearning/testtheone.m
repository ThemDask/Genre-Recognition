
model = loadLearnerForCoder('frem.mat');

location = 'datapath';
song= audioDatastore(location,'FileExtensions','.wav');
Classes = {'blues','classical','country','disco','hiphop','jazz',...
    'metal','pop','reggae','rock'};
N = 2^19;
sn = waveletScattering('SignalLength',2^19,'SamplingFrequency',22050,...
    'InvarianceScale',0.5);
batchsize = 1;
useGPU = false;
sc = helperbatchscatfeatures(song,sn,N,batchsize,useGPU);
scFeatures = permute(sc,[2 1]);



genres = predict(model,scFeatures);

[TestVotes,TestCounts] = helperMajorityVote(genres,43,categorical(Classes))


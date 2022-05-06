fileName = 'mydata.json'; % read data from file (must me in same repo as this file)
fid = fopen(fileName); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
data = jsondecode(str); % jsondecode function to parse JSON 

song = "serosjoker"; % save song name into a var
song % print song

model = loadLearnerForCoder('frem.mat'); % read model

% search for song name .wav in local repo
location = 'C:\Users\FouKoMD\Desktop\Genre-Recognition-main\DeepLearning\testtheone';
song= audioDatastore(location, 'FileExtensions','.wav'); 

% add genre classes
Classes = {'blues','classical','country','disco','hiphop','jazz',...
    'metal','pop','reggae','rock'};
N = 2^19;
% create wavelet scattering
sn = waveletScattering('SignalLength',2^19,'SamplingFrequency',22050,...
    'InvarianceScale',0.5);
batchsize = 1;
useGPU = false;
sc = helperbatchscatfeatures(song,sn,N,batchsize,useGPU);
scFeatures = permute(sc,[2 1]);

% run the model
genres = predict(model,scFeatures);

[TestVotes,TestCounts] = helperMajorityVote(genres,43,categorical(Classes));

res = TestVotes;
res % print variable that holds the resulting genre
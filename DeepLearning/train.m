
%to clean before run
clear
clc 
close all
%

sn = waveletScattering('SignalLength',2^19,'SamplingFrequency',22050,...
    'InvarianceScale',0.5);

%path to the genre folders
datapath = 'C:\Users\pcem\Desktop\karidis\matlab\data';
location = fullfile(datapath,'genres');

%Audio Datastore
ads = audioDatastore(location,'IncludeSubFolders',true,...
    'LabelSource','foldernames');

%split to train test set using shuffle before splitting the data for each
%label

rng(100)
ads = shuffle(ads);
[adsTrain,adsTest] = splitEachLabel(ads,0.8);
%train
countEachLabel(adsTrain)
%test
countEachLabel(adsTest)

%To obtain the scattering features, use a helper function, helperbatchscatfeatures

N = 2^19;
batchsize = 64;
scTrain = [];
useGPU = false; % Set to true to use the GPU

while hasdata(adsTrain)
    sc = helperbatchscatfeatures(adsTrain,sn,N,batchsize,useGPU);
    scTrain = cat(3,scTrain,sc);
end

%Record the number of time windows in the scattering transform for label creation
numTimeWindows = size(scTrain,2);

%Repeat the same feature extraction process for the test data
scTest = [];

while hasdata(adsTest)
   sc = helperbatchscatfeatures(adsTest,sn,N,batchsize,useGPU);
   scTest = cat(3,scTest,sc); 
end

%Determine the number of paths in the scattering network and reshape the training and test features into 2-D matrices.

[~,npaths] = sn.paths();
Npaths = sum(npaths);
TrainFeatures = permute(scTrain,[2 3 1]);
TrainFeatures = reshape(TrainFeatures,[],Npaths);
TestFeatures = permute(scTest,[2 3 1]);
TestFeatures = reshape(TestFeatures,[],Npaths);

%Create a genre label for each of the 43 windows in the wavelet scattering feature matrix for the training data.

trainLabels = adsTrain.Labels;
numTrainSignals = numel(trainLabels);
trainLabels = repmat(trainLabels,1,numTimeWindows);
trainLabels = reshape(trainLabels',numTrainSignals*numTimeWindows,1);

%same for test

testLabels = adsTest.Labels;
numTestSignals = numel(testLabels);
testLabels = repmat(testLabels,1,numTimeWindows);
testLabels = reshape(testLabels',numTestSignals*numTimeWindows,1);

%use a multi-class support vector machine (SVM) classifier with a cubic polynomial kernel. Fit the SVM to the training data.

template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
Classes = {'blues','classical','country','disco','hiphop','jazz',...
    'metal','pop','reggae','rock'};
classificationSVM = fitcecoc(...
    TrainFeatures, ...
    trainLabels, ...
    'Learners', template, ...
    'Coding', 'onevsone','ClassNames',categorical(Classes));

%test
predLabels = predict(classificationSVM,TestFeatures);
[TestVotes,TestCounts] = helperMajorityVote(predLabels,adsTest.Labels,categorical(Classes));
testAccuracy = sum(eq(TestVotes,adsTest.Labels))/numTestSignals*100

%plot seperatly
cmat = cm.NormalizedValues;
cmat(end,:) = [];
genreAccuracy = diag(cmat)./20*100;
figure
bar(genreAccuracy)
set(gca,'XTickLabels',Classes)
xtickangle(gca,30)
title('Percentage Correct by Genre - Test Set')
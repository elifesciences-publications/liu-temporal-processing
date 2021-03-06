function [zValues,outputStatistics] = ...
      findEmbeddings(projections,trainingData,trainingEmbedding,parameters)
%findEmbeddings finds the optimal embedding of a data set into a previously
%found t-SNE embedding
%
%   Input variables:
%
%       projections -> N x (pcaModes x numPeriods) array of projection values
%       trainingData -> Nt x (pcaModes x numPeriods) array of wavelet 
%                       amplitudes containing Nt data points
%       trainingEmbedding -> Nt x 2 array of embeddings
%       parameters -> struct containing non-default choices for parameters
%
%
%   Output variables:
%
%       zValues -> N x 2 array of embedding results
%       outputStatistics -> struct containing embedding outputs
%
%
% (C) Gordon J. Berman, 2014
%     Princeton University

    
    
    if nargin < 4
        parameters = [];
    end
    parameters = setRunParameters(parameters);

    d = length(trainingData(1,:));
    numModes = parameters.pcaModes;
    numPeriods = parameters.numPeriods;
    
    minT = 1 ./ parameters.maxF;
    maxT = 1 ./ parameters.minF;
    Ts = minT.*2.^((0:numPeriods-1).*log(maxT/minT)/(log(2)*(numPeriods-1)));
    f = fliplr(1./Ts);
        
    
    fprintf(1,'Finding Embeddings\n');
    [zValues,zCosts,zGuesses,inConvHull,meanMax,exitFlags] = ...
        findTDistributedProjections_fmin(projections,trainingData,...
                                    trainingEmbedding,parameters);
    
    
                                
    outputStatistics.zCosts = zCosts;
    outputStatistics.f = f;
    outputStatistics.numModes = numModes;
    outputStatistics.zGuesses = zGuesses;
    outputStatistics.inConvHull = inConvHull;
    outputStatistics.meanMax = meanMax;
    outputStatistics.exitFlags = exitFlags;
    
    
                   
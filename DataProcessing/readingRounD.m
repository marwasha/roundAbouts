clear all

addpath("csvimport");
num = 0;
fileNum = sprintf('%02d',num);
fileLoc = "../../roundAboutDatasets/rounD-dataset-v1.0/data/";
rMeta = readtable(fileLoc + fileNum + "_recordingMeta.csv");
tMeta = readtable(fileLoc + fileNum + "_tracksMeta.csv");
tracks = readtable(fileLoc + fileNum + "_tracks.csv");

numObj = rMeta.numTracks;

for i = 1:numObj
    % Needed Param
    temp = tMeta.class(i);
    filter = (tracks.trackId == i);
    % Extract Data
    obj(i).id = tMeta.trackId(i);
    obj(i).length = tMeta.length(i);
    obj(i).frameS = tMeta.initialFrame(i);
    obj(i).frameE = tMeta.finalFrame(i);
    obj(i).class = temp{1,1};
    obj(i).x = tracks.xCenter(filter);
    obj(i).y = tracks.yCenter(filter);
    obj(i).v = tracks.lonVelocity(filter);
    obj(i).a = tracks.lonAcceleration(filter);
end

% Now need to pull trajectories

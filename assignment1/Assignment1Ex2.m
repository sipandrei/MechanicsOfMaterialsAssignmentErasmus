% Assignment 1 - Mechanical behaviour of materials - Erasmus - University
% of Patras - 2025 - Exercise 2
% Compute the Schmid factor for all 12 slip systems of the FCC crystal structure for each
% grain and calculate the applied stress, so all grains have 2 slip systems acAvated. Consider
% the τCRSS=60 MPa.

function normalisedMatrix = NormaliseVectors(vectorMatrix)
    magnitudes = sqrt(sum(vectorMatrix.^2,2));
    normalisedMatrix = vectorMatrix ./ magnitudes;
end

tauCRRS = 60;

loadingDirections = [3,3,1;5,1,1;1,4,1];
loadingDirections = NormaliseVectors(loadingDirections);

slipPlanes = [1,1,1;-1,1,1;1,-1,1;1,1,-1];
slipPlanes = NormaliseVectors(slipPlanes);

slipDir111 = [1,-1,0;0,1,-1;1,0,-1];
slipDir11m1 = [1,-1,0;0,1,1;1,0,1];
slipDir1m11 = [1,1,0;0,1,-1;1,0,1];
slipDirm111 = [1,1,0;0,1,-1;1,0,1];
slipDir = [slipDir111;slipDirm111;slipDir1m11;slipDir11m1];
slipDir = NormaliseVectors(slipDir);

schmidFactor = zeros(12,3);

[rowsLoading,~] = size(loadingDirections);
[rowsSlipPlanes,~] = size(slipPlanes);
[rowsSlipDir,~] = size(slipDir);
for l=1:rowsLoading
    for sp=1:rowsSlipPlanes
        for sd = 3*(sp-1)+1:3*(sp-1)+3
            schmidFactor(sd,l) = abs((loadingDirections(l,:).*slipPlanes(sp,:))...
                *transpose(loadingDirections(l,:).*slipDir(sd)));
        end
    end
end

for i=1:3
     x = unique(schmidFactor(:,i)); 
end
schmidFactorSmall = x;
schmidFactorSmall = sort(schmidFactorSmall,'descend');
schmidFactorSmall = schmidFactorSmall(1:2,:);

smallestSecondSchmidFactor = min(schmidFactorSmall(2,:));
targetStress = tauCRRS/smallestSecondSchmidFactor;

disp(['The stress where two systems are active in every grain is: ',...
    num2str(targetStress),'MPa']);
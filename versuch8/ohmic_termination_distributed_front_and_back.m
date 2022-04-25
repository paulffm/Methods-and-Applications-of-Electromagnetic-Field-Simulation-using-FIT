function [Rmat] = ohmic_termination_distributed_front_and_back(np,R)
% Return R matrix for ohmic termination at all port edges at front and back side

nz = 151;
Mz = 16;
ind = [[5,7,9,11] [2,3,10,11]+np];
% terminate both ends of the transmission line with R
Rmat = sparse([ind ind+(nz-1)*Mz], [ind ind+(nz-1)*Mz], 8*R*ones(16,1), 3*np, 3*np);
% terminate only the end of the transmission line with R
% Rmat = sparse([ind+(nz-1)*Mz], [ind+(nz-1)*Mz], 8*R*ones(8,1), 3*np, 3*np);

end

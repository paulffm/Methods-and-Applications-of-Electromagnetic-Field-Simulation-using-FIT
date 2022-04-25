%# Copyright (C) 2006-2009 Sebastian Schoeps 
%#
%# This file is part of:
%# FIDES - Field Device Simulator
%#
%# FIDES is free software; you can redistribute it and/or modify
%# it under the terms of the GNU General Public License as published by
%# the Free Software Foundation.
%#
%# This program is distributed in the hope that it will be useful,
%# but WITHOUT ANY WARRANTY; without even the implied warranty of
%# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%# GNU General Public License for more details.
%#
%# You should have received a copy of the GNU General Public License
%# along with this program (see the file LICENSE); if not,
%# see <http://www.gnu.org/licenses/>.
%#
%# author: schoeps@math.uni-wuppertal.de

%# -*- texinfo -*- 
%# @deftypefn {Function File} {[@var{C}, @var{S}, @var{Ss}] =} fit_operator @
%# (@var{xmesh}, @var{ymesh}, @var{zmesh}, @var{idxs}, @var{idxA}, @var{idxV})
%#
%# computes the primary curl, primary and dual divergene matrices on infinite
%# domains. In finite domains the degenerated objects at the boundary are 
%# removed, if optional index sets are given (e.g. from @code{fit_dof}).
%#
%# Note: The implementation for finite boundaries is not very efficient.
%#
%# Input:
%# @itemize 
%# @item @var{xmesh} = FIT mesh in x-direction [m]
%# @item @var{ymesh} = FIT mesh in y-direction [m]
%# @item @var{zmesh} = FIT mesh in z-direction [m]
%# @item @var{idxs} = (optional) indices of non-degenerated edges
%# @item @var{idxA} = (optional) indices of non-degenerated facets
%# @item @var{idxV} = (optional) indices of non-degenerated volumes
%# @end itemize
%#
%# Output:
%# @itemize
%# @item @var{C} = primary curl operator (3np-by-3np)
%# @item @var{S} = primary diveregence operator (np-by-3np)
%# @item @var{Ss} = dual diveregence operator (np-by-3np)
%# @end itemize
%#
%# Example without boundary conditions (infinite domain):
%# @example
%# prb.X = 1:3; prb.Y = 1:2; prb.Z = 1:4;
%# [C,S,Ss] = fit_operator(prb.X,prb.Y,prb.Z);
%# @end example
%#
%# Example with boundary conditions (finite domain):
%# @example
%# prb.X = 1:3; prb.Y = 1:2; prb.Z = 1:4;
%# [idxs,idxA,idxV] = fit_dof(prb.X,prb.Y,prb.Z);
%# [C,S,Ss] = fit_operator(prb.X,prb.Y,prb.Z,idxs,idxA,idxV);
%# @end example
%#
%# @seealso{fit_dof}
%# @end deftypefn

function [C,S,Ss,Px,Py,Pz]=fit_operator(xmesh, ymesh, zmesh, idxs, idxA, idxV)
  
  %# number of points in each direction
  nx = length(xmesh);
  ny = length(ymesh);
  nz = length(zmesh);
  np = nx*ny*nz;
  
  %# constants in numbering scheme
  Mx=1; My=nx; Mz=nx*ny;

  Px=sparse([1:np 1:np-Mx],[1:np 1+Mx:np],[-ones(1,np) ones(1,np-Mx)],np,np);
  Py=sparse([1:np 1:np-My],[1:np 1+My:np],[-ones(1,np) ones(1,np-My)],np,np);
  Pz=sparse([1:np 1:np-Mz],[1:np 1+Mz:np],[-ones(1,np) ones(1,np-Mz)],np,np);
  
  % Primary Curl: Primary Edges -> Primary Factes
  C = sparse([sparse(np,np) -Pz             Py; ...
              Pz             sparse(np,np) -Px; ...
             -Py             Px             sparse(np,np)]);

  % Divergence: Primary Facets -> Primary Volumes
  S = sparse([Px Py Pz]);

  % Dual Divergence: Dual Volumes -> Dual Factes
  Ss = sparse([-Px' -Py' -Pz']);

  if (nargin>3)
    C= sparse(idxA,idxA,1,3*np,3*np)*C*sparse(idxs,idxs,1,3*np,3*np);
    S= sparse(idxV,idxV,1,np,np)*S*sparse(idxA,idxA,1,3*np,3*np);
    Ss=Ss*sparse(idxs,idxs,1,3*np,3*np);
  end

end %function

%!# Shared variables
%!shared prb, idxs, idxA, idxV
%!  prb.X = 1:2; prb.Y = 1:2; prb.Z = 1:2;
%!  idxs = [1 3 5 7 9 10 13 14 17 18 19 20];
%!  idxA = [1 2 9 11 17 21];
%!  idxV = [1];
%!
%!# test the curl-curl matrix for infinite domains 
%!test
%!  [C,S,Ss]=fit_operator(prb.X,prb.Y,prb.Z);
%!  assert (nnz(sum(abs(C),2)==4)>6);
%!  assert (full(max(max(C))),1);
%!  assert (full(min(min(C))),-1);
%!
%!# test the curl-curl matrix for finite domains 
%!test
%!  [C,S,Ss]=fit_operator(prb.X,prb.Y,prb.Z,idxs,idxA,idxV);
%!  assert (nnz(sum(abs(C),2)==4)==6);
%!  assert (sum(C,2),sparse(24,1));
%!  assert (full(max(max(C))),1);
%!  assert (full(min(min(C))),-1);
%!
%!# test the divergence matrices for finite domains 
%!test
%!  [C,S,Ss]=fit_operator(prb.X,prb.Y,prb.Z,idxs,idxA,idxV);
%!  assert (nnz(sum(abs(S),2)==6)==1);
%!  assert (sum(S,2),sparse(8,1));
%!  assert (nnz(sum(abs(Ss),2)==3)==8);
%!  assert (full(sum(Ss,2)~=0),true(8,1));
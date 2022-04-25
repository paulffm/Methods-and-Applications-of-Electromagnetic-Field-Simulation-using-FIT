clc;clear all;close all;

function orth = isOrth(A)
  
orth = A'*A;

for row = 1:size(orth)(1)
  for col = 1:size(orth)(2)
    if row==col
      orth(row,col)=0;
    endif
  endfor
endfor

endfunction

%%% choose inhomogen or homogen
material_option = 'inhomogen';
%material_option = 'inhomogen';

% load material data and curl matrix C
load material_data
if strcmp( material_option, 'homogen' )
    Mepsi = Mepsi_homogen;
    Mmui = Mmui_homogen;
elseif strcmp( material_option, 'inhomogen' )
    Mepsi = Mepsi_inhomogen;
    Mmui = Mmui_inhomogen;
else
    error('unknown material option. material_option should be either homogen or inhomogen')
end 

% create non-inverse material matrices
Meps=nullInv(Mepsi);
Mmu=nullInv(Mmui);

% initialization
nx=4; ny=4; nz=151;
np=nx*ny*nz;
Mx=1; My=nx; Mz=nx*ny;

% checks correct size of mesh. Otherwise generates exception.
assert(np==length(Mmui)/3)

% -------------------------------------------------------------------------
% --------------------------- Implementierung -----------------------------
% -------------------------------------------------------------------------
 nt=400;
% simulation in time domain, nts time steps of size dt
 dt = 2.2*10^-11;
 tend =  dt*nt;
 time =0:dt:dt*(nt-1);

% excitation parameter (choose 'Gauss', 'Trapez' or 'Sinusoidal')
signalShape = 'Trapez';
distributed = false; % choose true or false
 trise = 0.5*10^-9;
 thold =0.7*10^-9;
 tfall = 0.5*10^-9;
 fmax_gauss = 10^9;
% f_sin = 

% define which edge shall be excited and plotted
idxEdge2excite = 5; % if distributed == false
idxEdge2plot = 5;

% implement and choose transmission line termination
% choose 'noResistance', 'singleResistance' or '8parallelResistances'
resistanceImpl = 'noResistance';
 R =50; 
 
if strcmp(resistanceImpl,'noResistance') 
    Rmat = no_ohmic_termination(np);
elseif strcmp(resistanceImpl,'singleResistance') 
    Rmat = ohmic_termination_single(np, R);
elseif strcmp(resistanceImpl,'8parallelResistances') 
    Rmat = ohmic_termination_distributed_front_and_back(np, R);
else
    error('Not supported termination selected. Please choose ''noResistance'', ''singleResistance'' or ''8parallelResistances''');
end

% initialize field values
hbow=sparse(3*np,1);
ebow=sparse(3*np,1);

if strcmp(signalShape,'Trapez')
    j_time = - trapez_pulse(time,trise,thold,tfall); 
elseif strcmp(signalShape,'Gauss')
    j_time = - gauss_pulse(time,fmax_gauss);
elseif strcmp(signalShape,'Sinusoidal')
%    j_time = 
    printf('Frequency of sinusoidal signal: %d\n',f_sin);
else
    error('Not supported signal shape selected. Please use either ''Gauss'', ''Trapez'' or ''Sinusoidal''')
end
% plot excitation
figure(1);
plot(time,j_time);
xlabel('Zeit in s');
ylabel('Stromanregung in A');

% place excitation on edges according to the variable 'distributed' 
j_matrix = zeros(3*np,length(time));
if distributed
    % set j in a way that the current is distributed over the entire port
    % Vorzeichen aus Gauß puls versuch 8
    j_matrix(5,:)=-j_time./8;
    j_matrix(7,:)=j_time./8;
    j_matrix(9,:)=-j_time./8;
    j_matrix(11,:)=j_time./8;
    j_matrix(2418,:)=-j_time./8;
    j_matrix(2419,:)=-j_time./8;
    j_matrix(2426,:)=j_time./8;
    j_matrix(2427,:)=j_time./8;
    
    
else
    % set j in a way that one edge in the port face is excited by the entire current
    % Strom über eine Kante  
    j_matrix(idxEdge2excite,:)=j_time; 
end

%% time loop
figure(2)
counter = 1;
for k=1:length(time)
    % set time and excitation for current time step
    t = time(k);
   j = j_matrix(:,k); 
    
    % leapfrog method (take the one from the last lab but with R this time)
    [hbow,ebow] = leapfrog(hbow, ebow, j, Mmui, Meps, C, Rmat, dt);
       
     % voltage along the transmission line (for each z-layer one value)
    u_line=zeros(nz,1);
        for z=1:nz
        n=5+(z-1)*nx*ny;
     u_line(z) = ebow(n); 
        end
        
    % voltage plot
    if mod(k,2) == 0
        if strcmp( material_option, 'homogen' )
            % visualization for homogen material
            plot(u_line, 'LineWidth', 2);
            axis([ 1, nz,-70, 70]);
            xlabel('Position entlang des Leiters in cm');
            ylabel('z-Komponente der elektrischen Gitterspannung in Volt');
            drawnow;
        elseif strcmp( material_option, 'inhomogen' )
            % visualization for inhomogen material
            plot(u_line, 'LineWidth', 2);
            axis([0 nz -100 100]);
            line([75,100; 75,100],ylim.',...
             'linewidth',2,...
             'color',[1,0,0]);
            xlabel('Position entlang des Leiters in cm');
            ylabel('z-Komponente der elektrischen Gitterspannung in Volt');
            drawnow;
        else
            error('unknown material option. material_option should be either homogen or inhomogen')
        end
    end
	counter=counter+1;
end

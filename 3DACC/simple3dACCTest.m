% Generic
%con.rho = [0.05; 0.05];

%% Set up param

con.aL_max = 3;
con.aL_min = -4.5;
con.vL_max = 15;
con.vL_min = 0;

con.aE_max = 3;
con.aE_min = -4.5;
con.vE_max = 9;
con.vE_min = 0;

con.L = 4.5;
con.h_max = inf;
con.h_min = 0;
con.freq = 25; %hz
con.dt = 1/con.freq;

n = 3;
m = 1;

%% Set up Dyn

A = [zeros(1, n); -1 0 1; zeros(1, n)];                   
B = [1; 0; 0];
E = [0; 0; 1];
K = zeros(n,1);

Ad = con.dt*A +eye(n);
Bd = con.dt*B;
Ed = con.dt*E;
Kd = con.dt*K;

%% Set up the constraints

XU = Polyhedron('H', [0 0 0 1 con.aE_max; 0 0 0 -1 -con.aE_min]);% ...
                      %1 0 0 1 con.v_max; -1 0 0 -1 con.v_min]);
X = Polyhedron('lb', [con.vE_min con.h_min con.vL_min], ...
               'ub', [con.vE_max con.h_max con.vL_max]);
           
%Adist = {zeros(n)};
%Fdist = {Ed};

%P = Polyhedron('lb', [con.a_min], 'ub', [con.a_max]);

%XV_P = {[0 0 0 1 con.a_max], [0 0 0 -1 -con.a_min], [1 0 0 1 con.v_max], [-1 0 0 -1 con.v_min]};

linP1 = [con.vL_min-con.aL_min*con.dt 1; con.vL_min 1]^-1*[con.aL_min; 0];
linP2 = [con.vL_max-con.aL_max*con.dt 1; con.vL_max 1]^-1*[con.aL_max; 0];

XPV_V = {
    [0 0 0 con.aL_max],
    [0 0 0 con.aL_min],
    [0 0 linP1(1) linP1(2)],
    [0 0 linP2(1) linP2(2)]
};

%% Find Cinv

accDyn = Dyn(Ad, Kd, Bd, XU, {}, {}, Polyhedron(), {}, {}, Polyhedron(), Ed, XPV_V);
Cinv = accDyn.win_always(X, 0, 1, 1)
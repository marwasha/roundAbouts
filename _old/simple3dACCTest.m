% Generic
con.rho = [0.05; 0.05];
con.a_max = 3;
con.a_min = -4.5;
con.v_max = 9;
con.v_min = 0;
con.L = 4.5;
con.h_max = 100;
con.h_min = 0;
con.freq = 10; %hz
con.dt = 1/con.freq;

n = 3;
A = [zeros(1, n); -1 0 1; zeros(1, n)];                   
B = [1; 0; 0];
E = [0; 0; 1];
K = zeros(n,1);

Ad = con.dt*A +eye(n);
Bd = con.dt*B;
Ed = con.dt*E;
Kd = con.dt*K;

XU = Polyhedron('H', [0 0 0 1 con.a_max; 0 0 0 -1 -con.a_min]);% ...
                      %1 0 0 1 con.v_max; -1 0 0 -1 con.v_min]);
X = Polyhedron('lb', [con.v_min con.h_min con.v_min], ...
               'ub', [con.v_max inf inf]);
P = Polyhedron('lb', [con.a_min], 'ub', [con.a_max]);

%XV_P = {[0 0 0 1 con.a_max], [0 0 0 -1 -con.a_min], [1 0 0 1 con.v_max], [-1 0 0 -1 con.v_min]};

accDyn = Dyn(Ad, Kd, Bd, XU, {}, {Ed}, P);
Cinv = accDyn.win_always(X, 0, 1, 1)
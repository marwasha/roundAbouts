clear all
constaints
addpath('pcis/lib')
mptopt('lpsolver', 'mosek');

% CC
sitch(1) = situation(1,0,1,0,0,con.dt);
sitch(1).X = Polyhedron('lb', [con.v_min], 'ub', [con.vEgo_max]); 

% STOP
sitch(2) = situation(2, [0 0; -1 0], [1; 0], [0; 0], [0; 0], con.dt);
sitch(2).X = Polyhedron('lb', [con.v_min 0], 'ub', [con.vEgo_max con.h_max]); 

% ACC
n = 3;
sitch(3) = situation(n, ...
                    [zeros(1, n); -1 0 1; zeros(1, n)], ...
                    [1; 0; 0], ...
                    [0; 0; 1], ...
                    zeros(n,1), ...
                    con.dt);
sitch(3).X = Polyhedron('lb', [con.v_min con.h_min con.v_min], ...
                        'ub', [con.vEgo_max con.h_max con.vOther_max]);                
% RACC
n = 3;
sitch(4) = situation(n, ...
                    [zeros(1, n); 1 0 -1; zeros(1, n)], ...
                    [1; 0; 0], ...
                    [0; 0; 1], ...
                    zeros(n,1), ...
                    con.dt);
sitch(4).X = Polyhedron('lb', [con.v_min con.h_min con.v_min], ...
                        'ub', [con.vEgo_max con.h_max con.vOther_max]);  

for i = 1:length(sitch)
    sitch(i).setXU(ones(1,sitch(i).m)*con.a_max,  ones(1,sitch(i).m)*con.a_min);
    sitch(i).setP(ones(1,sitch(i).d)*con.a_max,  ones(1,sitch(i).d)*con.a_min);
    sitch(i).dyn = Dyn(sitch(i).Ad, sitch(i).Kd, sitch(i).Bd, sitch(i).XU, {}, {sitch(i).Ed}, sitch(i).P);
    sitch(i).Cinv = sitch(i).dyn.win_always(sitch(i).X, 0, 1, 1);
end
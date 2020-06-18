% Assumptions Roundabout Speed Limit 15mph, thus surronding vehicles bounded by 20mph ~9m/s
% Acceleration bounded between -4.5 to 3 m/s^2

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

% scen 0
% x = [v_e]
scen(1) = scenario(1,0,1,0,0,con.dt);
scen(1).X = Polyhedron('lb',[con.v_min], ...
                       'ub',[con.v_max]);
scen(1).XPV_V = {};
                   
% scen 1
% x = [v_e h_l v_l]'
n2 = 3;
scen(2) = scenario(n2, ...
                   [zeros(1, n2); -1 0 1; zeros(1, n2)], ...
                   [1; 0; 0], ...
                   [0; 0; 1], ...
                   zeros(n2,1), ...
                   con.dt);
scen(2).X = Polyhedron('lb',[con.v_min, con.h_min, con.v_min], ...
                       'ub',[con.v_max, con.h_max, con.v_max]);

scen(2).XPV_V = {[0 0 -1 -1 -con.v_min], 
                 [0 0  1  1  con.v_max],
                 [0 0  0 -1 -con.a_min], 
                 [0 0  0  1  con.a_max]};
%                Polyhedron('H', [0 0 -1 -1 -con.v_min;
%                                 0 0  1  1  con.v_max;
%                                 0 0  0 -1 -con.a_min;
%                                 0 0  0  1  con.a_max]);
                   
% scen 2'
% x = [v_e h_f v_f h]'
n3 = 4;
scen(3) = scenario(n3, ...
                   [zeros(1, n3); 1 0 -1 0; zeros(1, n3); -1 0 0 0], ...
                   [1; 0; 0; 0], ...
                   [0; 0; 1; 0], ...
                   zeros(n3,1), ...
                   con.dt);
scen(3).X = Polyhedron('lb',[con.v_min, con.h_min, con.v_min, con.h_min], ...
                       'ub',[con.v_max, con.h_max,  con.v_max,con.h_max]);
scen(3).XPV_V = Polyhedron('H', [0 0 -1 0 -1 -con.v_min;
                                 0 0  1 0  1  con.v_max;
                                 0 0  0 0 -1 -con.a_min;
                                 0 0  0 0  1  con.a_max]);
                   
% scen 3'
% x = [v_e h_f v_f h_l v_l h]'
n4 = 6;
scen(4) = scenario(n4, ...
                   [zeros(1, n4); 1 0 -1 0 0 0; zeros(1, n4);
                    -1 0 0 0 1 0; zeros(1, n4); -1 0 0 0 0 0], ...
                   [1; 0; 0; 0; 0; 0], ...
                   [0 0; 0 0; 1 0; 0 0; 0 1; 0 0], ...
                   zeros(n4,1), ...
                   con.dt);
scen(4).X = Polyhedron('lb',[con.v_min, con.h_min, con.v_min, con.h_min, con.v_min, con.h_min], ...
                       'ub',[con.v_max, con.h_max, con.v_max, con.h_max, con.v_max, con.h_max]);
scen(4).XPV_V = Polyhedron('H', [0 0 -1 0 0 0 -1 0 -con.v_min;
                                 0 0  1 0 0 0  1 0 con.v_max;
                                 0 0  0 0 0 0 -1 0 -con.a_min;
                                 0 0  0 0 0 0  1 0 con.a_max;
                                 0 0 0 0 -1 0 0 -1 -con.v_min;
                                 0 0 0 0  1 0 0  1 con.v_max;
                                 0 0 0 0  0 0 0 -1 -con.a_min;
                                 0 0 0 0  0 0 0  1 con.a_max]); 

for i = 1:length(scen)
    scen(i).setXU(ones(1,scen(i).m)*con.a_max,  ones(1,scen(i).m)*con.a_min)
end
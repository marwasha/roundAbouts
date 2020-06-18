clear all
addpath('pcis\lib')
roundAboutLinDynamics
for i =  1:length(scen)
    s = scen(i);
    dyn(i) = Dyn(s.Ad, s.Kd, s.Bd, s.XU, {zeros(s.n)}, {zeros(s.n,1)}, Polyhedron('lb', -1, 'ub', 1), {}, {}, Polyhedron(), s.Ed, s.XPV_V);
end
d = dyn(2);
s = scen(2);
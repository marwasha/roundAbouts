classdef scenario < handle
    properties
        dt
        n
        m
        d
        A
        B
        E
        K
        Ad
        Bd
        Ed
        Kd
        XU
        X
        XPV_V
    end
    methods
        function obj = scenario(n, A, B, E, K, dt)
            if nargin > 0
                obj.n = n;
                obj.A = A;
                obj.B = B;
                obj.E = E;
                obj.K = K;
                obj.dt = dt;
                obj.Ad = eye(n) + A*dt;
                obj.Bd = B*dt;
                obj.Ed = E*dt;
                obj.Kd = K*dt;
                [~,obj.m] = size(B);
                [~,obj.d] = size(E);
            end
        end
        function setXU(obj, umax, umin)
            if (length(umax) ~= obj.m || length(umin) ~= obj.m)
                error('dim of bounds does not match')
            end
            matXU = zeros(2*obj.m, obj.n + obj.m + 1);
            for i = 1:obj.m
                uSelect = [zeros(1, i-1) 1 zeros(1, obj.m-i)];
                matXU([1+2*(i-1): 2+2*(i-1)],:) = [zeros(1,obj.n)  uSelect umax(i);
                                                   zeros(1,obj.n) -uSelect -umin(i)];
            end
            obj.XU = Polyhedron('H',matXU);
        end
    end
end
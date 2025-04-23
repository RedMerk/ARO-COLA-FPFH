function vec = euler_trans(H)
    R=H(1:3,1:3);
    v=rotm2eul(R,'ZYX');
    v = [v(3) v(2) v(1)];
    t=H(1:3,4)';
    vec=[v,t];
end
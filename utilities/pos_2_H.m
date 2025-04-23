function H = pos_2_H(pos)
    % Pablo Barrios  28/04/2021
    %
    % hom_trans Creates an isometric transformation H, based on rotations and 
    % translations 
    %
    % Inputs: h - Vector which contain rotation and translation informations.
    %             The format of it is h=[yaw, pitch, roll, tx, ty, tz].
    %
    % Output: H - 4x4 Matrix in shape H = [R,t;O(1,3),1];

    % Rot_matrix = Rz(yaw)*Ry(pitch)*Rx(roll);

    yaw = pos(3)*180/pi;
    pitch = pos(2)*180/pi;
    roll = pos(1)*180/pi;

    R = rotz(yaw)*roty(pitch)*rotx(roll);

    Ov = [0 , 0, 0];
    tv = [pos(4) pos(5) pos(6)]';

    H = [R,tv;Ov,1];

end
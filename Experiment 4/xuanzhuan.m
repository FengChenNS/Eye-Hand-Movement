function rotated_point = xuanzhuan(zb,oplane,tplane)
    
    a1 = oplane(1); b1 = oplane(2); c1 = oplane(3); d1 = oplane(4);
    a2 = tplane(1); b2 = tplane(2); c2 = tplane(3); d2 = tplane(4);
    x0 = zb(1); y0 = zb(2); z0 = zb(3);
    % Step 1: Calculate the normal vectors of the planes
    n1 = [a1, b1, c1];
    n2 = [a2, b2, c2];

    % Step 2: Calculate the intersection line direction (cross product of the normal vectors)
    direction = cross(n1, n2);
    direction = direction / norm(direction); % normalize the direction vector

    % Step 3: Calculate the rotation axis (intersection line)
    % Find a point on the intersection line
    A = [a1, b1, c1; a2, b2, c2];
    b = [-d1; -d2];
    point_on_line = A \ b; % solve the linear system to find a point on the intersection line

    % Step 4: Calculate the angle between the planes
    cos_theta = dot(n1, n2) / (norm(n1) * norm(n2));
    theta = acos(cos_theta); % angle in radians

    % Step 5: Translate the point to the origin
    point = [x0, y0, z0] - point_on_line';

    % Step 6: Calculate the rotation matrix around the intersection line
    u = direction(1);
    v = direction(2);
    w = direction(3);

    R = [u^2 + (1-u^2)*cos(theta), u*v*(1-cos(theta))-w*sin(theta), u*w*(1-cos(theta))+v*sin(theta);
         u*v*(1-cos(theta))+w*sin(theta), v^2 + (1-v^2)*cos(theta), v*w*(1-cos(theta))-u*sin(theta);
         u*w*(1-cos(theta))-v*sin(theta), v*w*(1-cos(theta))+u*sin(theta), w^2 + (1-w^2)*cos(theta)];

    % Step 7: Rotate the point
    rotated_point = (R * point')';

    % Step 8: Translate the point back
    rotated_point = rotated_point + point_on_line';

    

end
function figure1 = plot3D2(Eyepos,Handpos,aE,bE,cE,dE,aH,bH,cH,dH)
    figure1 = figure;   
    fenduan = 4;
    color2(1:4,1:3) = [197 100 98;...
                  116 165 50;...
                  80 180 225;...
                  228 172 41] / 256;
    scatter3(Eyepos(1:fenduan,1),Eyepos(1:fenduan,2),Eyepos(1:fenduan,3),100,color2,"filled",'o'); hold on;
    scatter3(Handpos(1:fenduan,1),Handpos(1:fenduan,2),Handpos(1:fenduan,3),100,color2,"filled",'^'); hold on;
    
    scatter3(mean(Eyepos(1:fenduan,1)),mean(Eyepos(1:fenduan,2)),mean(Eyepos(1:fenduan,3)),20,'black','o'); hold on;
    scatter3(mean(Handpos(1:fenduan,1)),mean(Handpos(1:fenduan,2)),mean(Handpos(1:fenduan,3)),20,'black','o'); hold on;
    
    for i = 1 : 3
        j = i +1;
        line([Eyepos(i,1),Eyepos(j,1)],[Eyepos(i,2),Eyepos(j,2)],[Eyepos(i,3),Eyepos(j,3)],'Linewidth',1); hold on;
        line([Handpos(i,1),Handpos(j,1)],[Handpos(i,2),Handpos(j,2)],[Handpos(i,3),Handpos(j,3)],'Linewidth',1); hold on;
    end
    xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
    for i = 1 : 4
       Eposys(i,1:3) = yinshe(aE,bE,cE,dE,Eyepos(i,1),Eyepos(i,2),Eyepos(i,3));
    end
    scatter3(Eposys(1:fenduan,1),Eposys(1:fenduan,2),Eposys(1:fenduan,3),50,"filled",'o'); hold on;
    for i = 1 : 4
       Hposys(i,1:3) = yinshe(aH,bH,cH,dH,Handpos(i,1),Handpos(i,2),Handpos(i,3));
    end
    scatter3(Hposys(1:fenduan,1),Hposys(1:fenduan,2),Hposys(1:fenduan,3),50,"filled",'o'); hold on;
    
 
    cc1 = [aE,bE,cE];
    cc2 = [aH,bH,cH];
    jx = cross(cc1,cc2);
    t = 0.5;
    tt= 4;
    Etyy(1,1:3) = [Eposys(tt,1),Eposys(tt,2),Eposys(tt,3)];
    Etyy(2,1:3) = [Eposys(tt,1)+ jx(1) * t, Eposys(tt,2)+ jx(2)*t,Eposys(tt,3) + jx(3)*t];
    Htyy(1,1:3) = [Hposys(tt,1),Hposys(tt,2),Hposys(tt,3)];
    Htyy(2,1:3) = [Hposys(tt,1)+ jx(1) * t, Hposys(tt,2)+ jx(2)*t,Hposys(tt,3) + jx(3)*t];
    line(Etyy(1:2,1),Etyy(1:2,2),Etyy(1:2,3)); hold on;
    line(Htyy(1:2,1),Htyy(1:2,2),Htyy(1:2,3)); hold on;

    tt = 2; t =-0.1;
    Etyy(3,1) = Eposys(tt,1) + 1 * t;
    Etyy(3,2) = Eposys(tt,2) + (jx(1) * cE - aE*jx(3)) / (bE*jx(3)-jx(2)*cE) * t;
    Etyy(3,3) = Eposys(tt,3) + (jx(1) * bE - aE*jx(2)) / (jx(2)*cE-bE*jx(3)) * t;
    scatter3(Etyy(3,1),Etyy(3,2),Etyy(3,3),50,"filled",'<'); hold on;
    tt = 2; t =-0.01;
    Htyy(3,1) = Hposys(tt,1) + 1 * t;
    Htyy(3,2) = Hposys(tt,2) + (jx(1) * cH - aH*jx(3)) / (bH*jx(3)-jx(2)*cH) * t;
    Htyy(3,3) = Hposys(tt,3) + (jx(1) * bH - aH*jx(2)) / (jx(2)*cH-bH*jx(3)) * t;
    scatter3(Htyy(3,1),Htyy(3,2),Htyy(3,3),50,"filled",'<'); hold on;

    axis equal
end
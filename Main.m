metodo = 'ARO_CC';

dataset ='apartment'; % 'apartment', 'stairs', 'wood_summer'

idxA = 0;
idxB = 1;% idx1 para calcular lo que queremos tiene que ser mayor que 1 que idx2...ademas ixd=1,..,44.
%idxA = idxB-1; % Por mientras: wood_summer tiene idx=0,1, mientras que stairs tiene idx=4,5

rehacerDatasets = true; %si true se guardan nuevamente datasets ply y txt
rehacerFPFH = true; %si true se calcula nuevamente FPFH

calcularFPFH(dataset,idxA,idxB,rehacerFPFH);
datos = getRefModelReales(dataset,idxA,idxB,rehacerDatasets);

[TError,RError,H,t] = registrarMetodo(datos);

graficarModelo(datos,H)

 
fprintf("Resultado gt\n")
disp(datos.Hgt)
fprintf("Resultado metodo ARO-COLA-FPFH |Trans error %0.3f |Rot error %0.3f\n",TError,RError)
disp(H)

function [TError,RError,H,t] = registrarMetodo(datos)
    t1 = tic;
    H = ARO_CC_V1_reg(datos.setB_FPFH,datos.setA_FPFH,'output_path',datos.output_path,'H_Init',eye(4));
    [TError,RError] = getError(datos.Hgt,H);
    t = toc(t1);
end

function graficarModelo(datos,H_est)
    
    BCloud = pointCloud(datos.setB');
    ACloud = pointCloud(datos.setA');
    B_reg = model_set_order(datos.setB,H_est);
    B_FPFH_reg = model_set_order(datos.setB_FPFH,H_est);
    B_regCloud = pointCloud(B_reg');
    
    figure(1)
    pcshowpair(ACloud,BCloud)
    hold on
    
    assig = correspondencias(datos,H_est);
    
    for idx = assig
        line.X = [datos.setB_FPFH(1,idx),datos.setA_FPFH(1,idx)];
        line.Y = [datos.setB_FPFH(2,idx),datos.setA_FPFH(2,idx)];
        line.Z = [datos.setB_FPFH(3,idx),datos.setA_FPFH(3,idx)];
        plot3(line.X,line.Y,line.Z,'Color','r','linewidth',3)
    end
    
    ylabel('Y(meter)')
    xlabel('X(meter)')
    zlabel('Z(meter)')
    title('Un-Registered scene')
    ax = gca;
    ax.XLimMode = 'auto';
    ax.YLimMode = 'auto';
    ax.ZLimMode = 'auto';
    ax.DataAspectRatio = [1 1 1];
    hold off
    
    figure(2)
    pcshowpair(ACloud,B_regCloud)
    hold on
    
    assig = correspondencias(datos,H_est);
    
    for idx = assig
        line.X = [B_FPFH_reg(1,idx),datos.setA_FPFH(1,idx)];
        line.Y = [B_FPFH_reg(2,idx),datos.setA_FPFH(2,idx)];
        line.Z = [B_FPFH_reg(3,idx),datos.setA_FPFH(3,idx)];
        plot3(line.X,line.Y,line.Z,'Color','r','linewidth',3)
    end
    
    ylabel('Y(meter)')
    xlabel('X(meter)')
    zlabel('Z(meter)')
    title('Registered scene')
    ax = gca;
    ax.XLimMode = 'auto';
    ax.YLimMode = 'auto';
    ax.ZLimMode = 'auto';
    ax.DataAspectRatio = [1 1 1];
    hold off
end

function corr = correspondencias(datos,H_est)
    sigma = 0.025;
    
    model_f = model_set_order(datos.setB_FPFH, H_est);
    reference = datos.setA_FPFH;
    
    distvec = vecnorm(reference-model_f(:,1:size(reference,2)));
    corr=find(distvec<3*sigma);
end
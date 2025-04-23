function datos = getRefModelReales(dataset,poseidA,poseidB,guardar)
    %Descripcion:
    %Funcion utilizada para facilitar el manejo de los argumentos de
    %distintos algoritmos, dado un nombre de dataset, caso, seed, sigma,
    %pMD y pFA entrega todos los datos necesarios para cualquier algoritmo
    %
    %Output: una estructura datos con los siguientes campos.
    % reference_path: Path al dataset de referencia en txt
    % model_path: Path al dataset modelo en txt
    % reference_path_ply: Path al dataset de referencia en ply
    % model_path_ply: Path al dataset modelo en ply
    % output_path: Path en el que se deben guardar el tiempo de ejecucion y
    %   el H obtenido
    % reference: Dataset de referencia como matriz 3xn
    % model: Dataset modelo como matriz 3xn
    % ptReference: Dataset de referencia como cloud point
    % ptModel: Dataset modelo como cloud point
    % H_gt: ????????????????????????
    % H_gt_path: ?????????????????????
    
    if ~exist('guardar','var')
        guardar = false;
    end
    
    switch dataset
        case 'apartment'
            name = 'Hokuyo';
            h_files = true;
        otherwise
            h_files = true;
            %name = dataset;
            name = 'Hokuyo';
    end
    
    %trans_path = sprintf('./datasets/%s/roll_%0.3f_pitch_%0.3f_yaw_%0.3f_tx_%0.3f_ty_%0.3f_tz_%0.3f',name_dataset,)
    %datos.setB_path_txt = sprintf('./datasets/%s/%s_%d.txt',dataset,name,poseidB);
    %datos.setA_path_txt = sprintf('./datasets/%s/%s_%d.txt',dataset,name,poseidA);
    
    %datos.setB_path_ply = sprintf('./datasets/%s/%s_%d.ply',dataset,name,poseidB);
    %datos.setA_path_ply = sprintf('./datasets/%s/%s_%d.ply',dataset,name,poseidA);
    
    datos.setB_path_csv = sprintf('./datasets/%s/%s_%d.csv',dataset,name,poseidB);
    datos.setA_path_csv = sprintf('./datasets/%s/%s_%d.csv',dataset,name,poseidA);
    
    datos.setB_FPFH_path_txt = sprintf('./datasets/%s/FPFH/SetB_%s_setB_%d_setA_%d_FPFH.txt',dataset,name,poseidB,poseidA);
    datos.setA_FPFH_path_txt = sprintf('./datasets/%s/FPFH/SetA_%s_setB_%d_setA_%d_FPFH.txt',dataset,name,poseidB,poseidA);

    datos.setB_FPFH_path_ply = sprintf('./datasets/%s/FPFH/SetB_%s_setB_%d_setA_%d_FPFH.ply',dataset,name,poseidB,poseidA);
    datos.setA_FPFH_path_ply = sprintf('./datasets/%s/FPFH/SetA_%s_setB_%d_setA_%d_FPFH.ply',dataset,name,poseidB,poseidA);
    
    datos.output_path = sprintf('./results/%s//H_%s_setB_%d_setA_%d.txt' ...
    ,dataset,name,poseidB,poseidA);

    datos.setB = plotCloudCsv(datos.setB_path_csv);
    datos.setA = plotCloudCsv(datos.setA_path_csv);

    datos.ptsetB = pointCloud(datos.setB');
    datos.ptsetA = pointCloud(datos.setA');
    
    datos.ptsetB_FPFH = pcread(datos.setB_FPFH_path_ply);
    datos.ptsetA_FPFH = pcread(datos.setA_FPFH_path_ply);
    
    datos.setB_FPFH = datos.ptsetB_FPFH.Location';
    datos.setA_FPFH = datos.ptsetA_FPFH.Location';
    
    datos.Hgt_path = sprintf('datasets/%s/Hgts/H_%d.mat',dataset,poseidB);
    if h_files
        H_file = load(datos.Hgt_path);
        datos.Hgt = H_file.H;
    end
end
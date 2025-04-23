function calcularFPFH(dataset,poseidA,poseidB,rehacerFPFH)

if ~exist('rehacerFPFH','var')
    rehacerFPFH = false;
end

switch dataset
    case 'apartment'
        name = 'Hokuyo';
    otherwise
        %name = dataset;
        name = 'Hokuyo';
end

setB_path_ply = sprintf('./datasets/%s/%s_%d.ply',dataset,name,poseidB);
setA_path_ply = sprintf('./datasets/%s/%s_%d.ply',dataset,name,poseidA);

setB_path_csv = sprintf('./datasets/%s/%s_%d.csv',dataset,name,poseidB);
setA_path_csv = sprintf('./datasets/%s/%s_%d.csv',dataset,name,poseidA);

FPFH_path = sprintf('./datasets/%s/FPFH',dataset);
if ~exist(FPFH_path, 'dir')
       mkdir(FPFH_path);
end

setB_FPFH_path_txt = sprintf('./datasets/%s/FPFH/SetB_%s_setB_%d_setA_%d_FPFH.txt',dataset,name,poseidB,poseidA);
setA_FPFH_path_txt = sprintf('./datasets/%s/FPFH/SetA_%s_setB_%d_setA_%d_FPFH.txt',dataset,name,poseidB,poseidA);

setB_FPFH_path_ply = sprintf('./datasets/%s/FPFH/SetB_%s_setB_%d_setA_%d_FPFH.ply',dataset,name,poseidB,poseidA);
setA_FPFH_path_ply = sprintf('./datasets/%s/FPFH/SetA_%s_setB_%d_setA_%d_FPFH.ply',dataset,name,poseidB,poseidA);

if rehacerFPFH || ~isfile(setB_FPFH_path_ply) || ~isfile(setA_FPFH_path_ply) || ~isfile(setB_FPFH_path_txt) || ~isfile(setA_FPFH_path_txt)

%Leer datos desde csv y guardar en ply
setB = plotCloudCsv(setB_path_csv);
setA = plotCloudCsv(setA_path_csv);
ptsetB = pointCloud(setB');
ptsetA = pointCloud(setA');
pcwrite(ptsetB,setB_path_ply)
pcwrite(ptsetA,setA_path_ply)

%Generar correspondencias FPFH
disp('calculando FPFH ...')
[setA_FPFH,setB_FPFH] = FPFH(setA_path_ply,setB_path_ply);
disp('calculo terminado')
ptsetA_FPFH = pointCloud(setA_FPFH');
ptsetB_FPFH = pointCloud(setB_FPFH');

%Guardar Correspondencias en txt y ply
pcwrite(ptsetB_FPFH,setB_FPFH_path_ply)
pcwrite(ptsetA_FPFH,setA_FPFH_path_ply)
save_txt(setB_FPFH,setB_FPFH_path_txt)
save_txt(setA_FPFH,setA_FPFH_path_txt)

end

end

function save_txt(data,filename)

fid = fopen(filename, 'w');

m = size(data,1);

    if m == 3
        n = size(data,2);
        fprintf(fid, '%d\n', n);
            for i=1:n
               fprintf(fid, '%.6f %.6f %.6f\n', data(1,i), data(2,i), data(3,i)); 
            end
    elseif m==2
        n = size(data,2);
        fprintf(fid, '%d\n', n);
            for i=1:n
               fprintf(fid, '%.6f %.6f %.6f\n', data(1,i),data(2,i),0); 
            end
    end
fclose(fid);
end

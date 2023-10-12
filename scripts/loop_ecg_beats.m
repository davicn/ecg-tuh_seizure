clc;
clear all;

d = dotenv('./.env');

%% Carregando dados
f = 'C:\Users\davin\Documents\doutorado\ecg-tuh_seizure\resources\reports\ecg_files_eval.csv'; % d.env.ROOT_PATH + '/resources/reports/ecg_files_dataset_train.csv'; 
path = 'G:\DATALAKES'; %d.env.DATALAKE_PATH;

df = readtable(f);


%% Loop de processamento
for i=1:height(df)
    try
        % definindo path
        b = table2cell(df(i,'file'));
        a = cellstr(b);
        c = char(a);
        d = split(strrep(c,'.tse','.parquet'),'/');

        file_ = join([path, "\tuh_seizures\raw\ecg\eval\",d{end}]);
        file__ = strrep(file_, '/','\');
        file_path = strrep(file__, ' ','');
    
        % trabalhando freq
        bb = table2cell(df(i,'freq'));
        fs = bb{1};

        % intervalos
        inicio = table2cell(df(i,'Start'));
        inicio = inicio{1};

        fim = table2cell(df(i,'Stop'));
        fim = fim{1};

        % disp(file_path);

        % parquetread('G:\DATALAKES\tuh_seizures\raw\ecg\train\00000002_s001_t000.parquet')

        % carregando parquet
        s = parquetread(file_path);
        x = table2array(s);
        x = x(inicio*fs:fim*fs);
        
        % tipo de crise
        seizure_type = table2cell(df(i,'SeizureType'));
        seizure_type = seizure_type{1};

        % Capturando batimentos
        [B,P,QRS,T] = ECGsegmentationF(x, fs);
        
        name_mat = strrep(d{end}, 'parquet','mat');
        
        path_file = join([path, '\tuh_seizures\processed\ecg_beats\eval\',name_mat]); %path + '\tuh_seizures\processed\ecg_beats\' + name_mat;
        
        disp(path_file);

        save(path_file,'B','P','QRS','T', 'seizure_type');
    
    catch ME
        continue 
    end
end



clc;
clear all;

d = dotenv('./.env');

lake_path = 'G:\DATALAKES';

files_path =  join([lake_path,'\tuh_seizures\processed\ecg_beats\eval\files.csv'],'/');

symbols = textread(files_path,'%s');

s = string(symbols);
st = size(s);

for i = 2:st(1)
    file = s(i);

    % lake_path = d.env.DATALAKE_PATH;
    path_file = join([lake_path, 'tuh_seizures\processed\ecg_beats\eval' ,file],'\');

    f = load(path_file);

    x = f.QRS;
    ss = size(x);
    

    for j = 1:ss(2)
        beat = x(:,j);
        vars(j) = var(x(:,j));
        skews(j) = skewness(beat);
        kurs(j)  = kurtosis(beat);
        entropy_log_energy(j) = wentropy(beat,'log energy');
        entropy_shannon(j) = wentropy(beat,"shannon");

        var_log_energy = vars + entropy_log_energy;
        skew_log_energy = skews + entropy_log_energy;
        kur_log_energy = kurs + entropy_log_energy;
        var_shannon = vars + entropy_shannon;
        skew_shannon = skews + entropy_shannon;
        kur_shannon = kurs + entropy_shannon;
        
    end
    
    label = f.seizure_type;
    
    name = join([lake_path , 'tuh_seizures\processed\features_v2\eval' , file],'\');
    
    disp(name)

    save(name,'vars', 'skews', 'kurs', 'entropy_log_energy','entropy_shannon','var_log_energy', 'skew_log_energy', 'kur_log_energy', 'var_shannon', 'skew_shannon', 'kur_shannon');
end


% save(name,'vars', 'skews', 'kurs', 'entropy_log_energy','entropy_shannon','var_log_energy', 'skew_log_energy', 'kur_log_energy', 'var_shannon', 'skew_shannon', 'kur_shannon');

%     log_ = wentropy(x,'log energy');
%     var_ = var(x);
%     skew = skewness(x);
%     kur  = kurtosis(x);
% 
%     var_log  = var_ + log_;
%     skew_log = skew + log_;
%     kur_log  = kur + log_;
% 
%     label = f.seizure_type;
% 
%     name = lake_path + '/tuh_seizures/processed/features/dev/' + file;
% 
%     disp(name)
% 
%     save(name,'var_log','skew_log','kur_log', 'label');





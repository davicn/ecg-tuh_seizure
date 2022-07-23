clc;
clear all;

d = dotenv('./.env');

lake_path = d.env.DATALAKE_PATH;

files_path =  join([lake_path,'tuh_seizures/processed/ecg_beats/dev/files.csv'],'/');

symbols = textread(files_path,'%s');

s = string(symbols);
st = size(s);

for i = 2:st(1)
    file = s(i);
        
    lake_path = d.env.DATALAKE_PATH;
    path_file = join([lake_path, 'tuh_seizures/processed/ecg_beats/dev/' ,file],'/');

    f = load(path_file);

    x = f.QRS;

    log_ = wentropy(x,'log energy');
    var_ = var(x);
    skew = skewness(x);
    kur  = kurtosis(x);

    var_log  = var_ + log_;
    skew_log = skew + log_;
    kur_log  = kur + log_;
    
    label = f.seizure_type;
    
    name = lake_path + '/tuh_seizures/processed/features/dev/' + file;
    
    disp(name)

    save(name,'var_log','skew_log','kur_log', 'label');
end




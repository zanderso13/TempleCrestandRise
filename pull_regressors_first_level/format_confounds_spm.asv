basedir = '/Users/zacharyanderson/Documents/ACNlab/RISECREST/RISE/raw_confounds_fmriprep';
savedir = '/Users/zacharyanderson/Documents/ACNlab/RISECREST/RISE/spm_confounds';

fnames = filenames(fullfile(basedir,'sub*ses-2*mid*run-02*txt'));
ndummies = 0;
ex1 = 33;
for sub = 1:length(fnames)
    T = readtable(fnames{sub});
    
    pid = fnames{sub}(83:87);
    outliers = table2array(T(:,contains(T.Properties.VariableNames,'motion')));
    transx = table2array(T(:,contains(T.Properties.VariableNames,'trans_x')));
    transy = table2array(T(:,contains(T.Properties.VariableNames,'trans_y')));
    transz = table2array(T(:,contains(T.Properties.VariableNames,'trans_z')));
    rotx = table2array(T(:,contains(T.Properties.VariableNames,'rot_x')));
    roty = table2array(T(:,contains(T.Properties.VariableNames,'rot_y')));
    rotz = table2array(T(:,contains(T.Properties.VariableNames,'rot_z')));
    csf = T.csf;
    wm = T.white_matter;
    fd(sub) = nanmean(T.framewise_displacement);

    R = [transx(:,1),transy(:,1),transz(:,1),rotx(:,1),roty(:,1),rotz(:,1),csf,wm,outliers];
    R(isnan(R)) = 0;
    R = R(ndummies+1:size(R,1),:);

    if nanmean(T.framewise_displacement) > 0.5 
        pid_exclude_list{ex1,1} = pid;
        pid_exclude_list{ex1,2} = 'ses-2_mid_run-2';
        ex1 = ex1 + 1;
    end

    save_name = fullfile(savedir,strcat(pid,'_ses-2_mid_run-2.mat'));
    save(save_name,"R")
end
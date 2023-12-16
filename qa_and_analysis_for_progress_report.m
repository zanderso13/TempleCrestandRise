fldir = '/projects/b1108/studies/rise/data/processed/neuroimaging/fl';

remake_data_obj = 1;

if remake_data_obj == 1

    cd(fldir)
    
    fmidant_s1_run1 = filenames(fullfile('sub-*/ses-1/anticipation/run-1/con_0001.nii'));
    fmidant_s1_run2 = filenames(fullfile('sub-*/ses-1/anticipation/run-2/con_0001.nii'));
    fmidout_s1_run1 = filenames(fullfile('sub-*/ses-1/outcome/run-1/con_0001.nii'));
    fmidout_s1_run2 = filenames(fullfile('sub-*/ses-1/outcome/run-2/con_0001.nii'));
    fchat_s1_accrej = filenames(fullfile('sub-*/ses-1/chatroom/run-1/con_0001.nii'));
    fchat_s1_acc = filenames(fullfile('sub-*/ses-1/chatroom/run-1/con_0002.nii'));
    fchat_s1_rej = filenames(fullfile('sub-*/ses-1/chatroom/run-1/con_0003.nii'));
        
    fmidant_s2_run1 = filenames(fullfile('sub-*/ses-2/anticipation/run-1/con_0001.nii'));
    fmidant_s2_run2 = filenames(fullfile('sub-*/ses-2/anticipation/run-2/con_0001.nii'));
    fmidout_s2_run1 = filenames(fullfile('sub-*/ses-2/outcome/run-1/con_0001.nii'));
    fmidout_s2_run2 = filenames(fullfile('sub-*/ses-2/outcome/run-2/con_0001.nii'));
    fchat_s2_accrej = filenames(fullfile('sub-*/ses-2/chatroom/run-1/con_0001.nii'));
    fchat_s2_acc = filenames(fullfile('sub-*/ses-2/chatroom/run-1/con_0002.nii'));
    fchat_s2_rej = filenames(fullfile('sub-*/ses-2/chatroom/run-1/con_0003.nii'));
    
    % apply exclusions based on 0.5mm FD
    load('/projects/b1108/studies/rise/data/processed/neuroimaging/exclusions_based_on_motion.mat');
    chat_exclude_s1 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_chat'));
    chat_exclude_s2 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-2_chat'));
    mid_exclude_s1 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_mid'));
    mid_exclude_s2 = pid_exclude_list(contains(pid_exclude_list(:,2),'ses-1_mid'));
    
    % chatroom ses1
    for ex = 1:length(chat_exclude_s1)
        fchat_s1_accrej(contains(fchat_s1_accrej(:),chat_exclude_s1{ex})) = [];
        fchat_s1_acc(contains(fchat_s1_acc(:),chat_exclude_s1{ex})) = [];
        fchat_s1_rej(contains(fchat_s1_rej(:),chat_exclude_s1{ex})) = [];
    end

    % chatroom ses2
    for ex = 1:length(chat_exclude_s2)
        fchat_s2_accrej(contains(fchat_s2_accrej(:),chat_exclude_s2{ex})) = [];
        fchat_s2_acc(contains(fchat_s2_acc(:),chat_exclude_s2{ex})) = [];
        fchat_s2_rej(contains(fchat_s2_rej(:),chat_exclude_s2{ex})) = [];
    end

    % mid ses1
    % note that you only need to pull out fnames from run2 because later I
    % match run1 to run2
    for ex = 1:length(mid_exclude_s1)
        fmidant_s1_run2(contains(fmidant_s1_run2(:),mid_exclude_s1{ex})) = [];
        fmidout_s1_run2(contains(fmidout_s1_run2(:),mid_exclude_s1{ex})) = [];
    end

    % mid ses2
    for ex = 1:length(mid_exclude_s2)
        fmidant_s2_run2(contains(fmidant_s2_run2(:),mid_exclude_s2{ex})) = [];
        fmidout_s2_run2(contains(fmidout_s2_run2(:),mid_exclude_s2{ex})) = [];
    end
    
    % average mid runs and run whole brain regression to get average activation
    % during anticipation and outcome. Finally create a table of significantly
    % active regions of interest at a FDR<0.05 threshold.
    
    % this will be for ses-1 anticipation mid
    final_data_midant_ses1 = fmri_data(fmidant_s1_run2{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidant_s1_run2) % start with run2 because there are fewer files
        pid = fmidant_s1_run2{sub}(5:9);
        
        if sum(contains(fmidant_s1_run1(:),pid))~=0
            pid_midant_s1{sub} = fmidant_s1_run2{sub}(5:9);
            tempfname_run1 = fmidant_s1_run1{contains(fmidant_s1_run1(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s1_run2{sub});
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midant_ses1.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            fprintf(fmidant_s1_run2{sub})
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-2 anticipation mid
    final_data_midant_ses2 = fmri_data(fmidant_s2_run2{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidant_s2_run2) % start with run2 because there are fewer files
        pid = fmidant_s2_run2{sub}(5:9);
                
        if sum(contains(fmidant_s2_run1(:),pid))~=0
            pid_midant_s2{sub} = fmidant_s2_run2{sub}(5:9);
            tempfname_run1 = fmidant_s2_run1{contains(fmidant_s2_run1(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidant_s2_run2{sub});
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midant_ses2.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            fprintf(fmidant_s2_run2{sub})
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-1 outcome mid
    final_data_midout_ses1 = fmri_data(fmidout_s1_run2{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidout_s1_run2) % start with run2 because there are fewer files
        pid = fmidout_s1_run2{sub}(5:9);        
        if sum(contains(fmidout_s1_run1(:),pid))~=0
            pid_fmidout_s1{sub} = fmidout_s1_run2{sub}(5:9);
            tempfname_run1 = fmidout_s1_run1{contains(fmidout_s1_run1(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s1_run2{sub});
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midout_ses1.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            fprintf(fmidout_s1_run2{sub})
            continue
        end
    end
    %%
    clear dat1 dat2
    % this will be for ses-2 outcome mid
    final_data_midout_ses2 = fmri_data(fmidout_s2_run2{1}); % place holder that will have all the appropriate space related information about the scans
    final_sub_count = 1;
    for sub=1:length(fmidout_s2_run2) % start with run2 because there are fewer files
        pid = fmidout_s2_run2{sub}(5:9);
        
        if sum(contains(fmidout_s2_run1(:),pid))~=0
            pid_fmidout_s2{sub} = fmidout_s2_run2{sub}(5:9);
            tempfname_run1 = fmidout_s2_run1{contains(fmidout_s2_run1(:),pid)};
            dat1 = fmri_data(tempfname_run1);
            dat2 = fmri_data(fmidout_s2_run2{sub});
            dat1.dat = mean([dat1.dat,dat2.dat],2);
            final_data_midout_ses2.dat(:,final_sub_count) = dat1.dat;
            final_sub_count = final_sub_count + 1;
        else
            fprintf(fmidout_s2_run2{sub})
            continue
        end
    end

    %%
    % this will be for ses-1 chatroom 
    final_data_chatroom_ses1_accrej = fmri_data(fchat_s1_accrej);
    final_data_chatroom_ses1_acc = fmri_data(fchat_s1_acc);
    final_data_chatroom_ses1_rej = fmri_data(fchat_s1_rej);
    %%
    % ses-2 chatroom
    final_data_chatroom_ses2_accrej = fmri_data(fchat_s2_accrej);
    final_data_chatroom_ses2_acc = fmri_data(fchat_s2_acc);
    final_data_chatroom_ses2_rej = fmri_data(fchat_s2_rej);
    
    for sub = 1:length(fchat_s1_accrej)
        pid_chat_s1{sub} = fchat_s1_accrej{sub}(5:9);
    end

    for sub = 1:length(fchat_s2_accrej)
        pid_chat_s2{sub} = fchat_s2_accrej{sub}(5:9);
    end
    
else
    load(fullfile(fldir,"final_data_midant_ses1.mat"))
    load(fullfile(fldir,"final_data_midant_ses2.mat"))
    load(fullfile(fldir,"final_data_midout_ses1.mat"))
    load(fullfile(fldir,"final_data_midout_ses2.mat"))
    load(fullfile(fldir,"final_data_chatroom_ses1_accrej.mat"))
    load(fullfile(fldir,"final_data_chatroom_ses2_accrej.mat"))
    load(fullfile(fldir,"final_data_chatroom_ses1_acc.mat"))
    load(fullfile(fldir,"final_data_chatroom_ses2_acc.mat"))
    load(fullfile(fldir,"final_data_chatroom_ses1_rej.mat"))
    load(fullfile(fldir,"final_data_chatroom_ses2_rej.mat"))

%     load(fullfile(fldir,"final_data_chatroom2_ses1_accrej.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses2_accrej.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses1_acc.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses2_acc.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses1_rej.mat"))
%     load(fullfile(fldir,"final_data_chatroom2_ses2_rej.mat"))
end

%% whole brain regression models for mid

final_data_midant_ses1.X = ones(size(final_data_midant_ses1.dat,2),1);
final_data_midant_ses2.X = ones(size(final_data_midant_ses2.dat,2),1);
final_data_midout_ses1.X = ones(size(final_data_midout_ses1.dat,2),1);
final_data_midout_ses2.X = ones(size(final_data_midout_ses2.dat,2),1);

stat_midant_ses1 = regress(final_data_midant_ses1);
stat_midant_ses2 = regress(final_data_midant_ses2);
stat_midout_ses1 = regress(final_data_midout_ses1);
stat_midout_ses2 = regress(final_data_midout_ses2);

thresh_midant_ses1 = threshold(stat_midant_ses1.t,0.05,'fdr','k',10);
thresh_midant_ses2 = threshold(stat_midant_ses2.t,0.05,'fdr','k',10);
thresh_midout_ses1 = threshold(stat_midout_ses1.t,0.05,'fdr','k',10);
thresh_midout_ses2 = threshold(stat_midout_ses2.t,0.05,'fdr','k',10);

%% whole brain for chatroom

final_data_chatroom_ses1_accrej.X = ones(size(final_data_chatroom_ses1_accrej.dat,2),1);
final_data_chatroom_ses2_accrej.X = ones(size(final_data_chatroom_ses2_accrej.dat,2),1);
final_data_chatroom_ses1_acc.X = ones(size(final_data_chatroom_ses1_acc.dat,2),1);
final_data_chatroom_ses2_acc.X = ones(size(final_data_chatroom_ses2_acc.dat,2),1);
final_data_chatroom_ses1_rej.X = ones(size(final_data_chatroom_ses1_rej.dat,2),1);
final_data_chatroom_ses2_rej.X = ones(size(final_data_chatroom_ses2_rej.dat,2),1);


stat_chatroom_ses1 = regress(final_data_chatroom_ses1_accrej);
stat_chatroom_ses2 = regress(final_data_chatroom_ses2_accrej);
stat_chatroom_ses1_acc = regress(final_data_chatroom_ses1_acc);
stat_chatroom_ses2_acc = regress(final_data_chatroom_ses2_acc);
stat_chatroom_ses1_rej = regress(final_data_chatroom_ses1_rej);
stat_chatroom_ses2_rej = regress(final_data_chatroom_ses2_rej);


thresh_chatroom_ses1 = threshold(stat_chatroom_ses1.t,0.05,'fdr','k',10);
thresh_chatroom_ses2 = threshold(stat_chatroom_ses2.t,0.05,'fdr','k',10);
thresh_chatroom_ses1_acc = threshold(stat_chatroom_ses1_acc.t,0.05,'fdr','k',10);
thresh_chatroom_ses2_acc = threshold(stat_chatroom_ses2_acc.t,0.05,'fdr','k',10);
thresh_chatroom_ses1_rej = threshold(stat_chatroom_ses1_rej.t,0.05,'fdr','k',10);
thresh_chatroom_ses2_rej = threshold(stat_chatroom_ses2_rej.t,0.05,'fdr','k',10);

%%
redo_regions = 1;

if redo_regions == 1
    
    % chatroom accrej ses1
    chats1accrej_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses1_accrej,roi);
        chats1accrej_T = [chats1accrej_T,temp_region.dat];
        names{r} = name; 
    end
    chats1accrej_T=array2table(chats1accrej_T);
    chats1accrej_T.Properties.VariableNames = names;
    chats1accrej_T = [cell2table(pid_chat_s1'), chats1accrej_T];
    chats1accrej_T.Properties.VariableNames{1} = 'PID';
    save chats1accrej_T.mat chats1accrej_T

    % chatroom acc ses1
    chats1acc_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses1_acc,roi);
        chats1acc_T = [chats1acc_T,temp_region.dat];
        names{r} = name; 
    end
    chats1acc_T=array2table(chats1acc_T);
    chats1acc_T.Properties.VariableNames = names;
    chats1acc_T = [cell2table(pid_chat_s1'), chats1acc_T];
    chats1acc_T.Properties.VariableNames{1} = 'PID';
    save chats1acc_T.mat chats1acc_T

    % chatroom rej ses1
    chats1rej_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses1_rej,roi);
        chats1rej_T = [chats1rej_T,temp_region.dat];
        names{r} = name; 
    end
    chats1rej_T=array2table(chats1rej_T);
    chats1rej_T.Properties.VariableNames = names;
    chats1rej_T = [cell2table(pid_chat_s1'), chats1rej_T];
    chats1rej_T.Properties.VariableNames{1} = 'PID';
    save chats1rej_T.mat chats1rej_T

    % chatroom accrej ses2
    chats2accrej_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses2_accrej,roi);
        chats2accrej_T = [chats2accrej_T,temp_region.dat];
        names{r} = name; 
    end
    chats2accrej_T=array2table(chats2accrej_T);
    chats2accrej_T.Properties.VariableNames = names;
    chats2accrej_T = [cell2table(pid_chat_s2'), chats2accrej_T];
    chats2accrej_T.Properties.VariableNames{1} = 'PID';
    save chats2accrej_T.mat chats2accrej_T

    % chatroom acc ses2
    chats2acc_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses2_acc,roi);
        chats2acc_T = [chats2acc_T,temp_region.dat];
        names{r} = name; 
    end
    chats2acc_T=array2table(chats2acc_T);
    chats2acc_T.Properties.VariableNames = names;
    chats2acc_T = [cell2table(pid_chat_s2'), chats2acc_T];
    chats2acc_T.Properties.VariableNames{1} = 'PID';
    save chats2acc_T.mat chats2acc_T

    % chatroom rej ses2
    chats2rej_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_chatroom_ses2_rej,roi);
        chats2rej_T = [chats2rej_T,temp_region.dat];
        names{r} = name; 
    end
    chats2rej_T=array2table(chats2rej_T);
    chats2rej_T.Properties.VariableNames = names;
    chats2rej_T = [cell2table(pid_chat_s2'), chats2rej_T];
    chats2rej_T.Properties.VariableNames{1} = 'PID';
    save chats1rej_T.mat chats1rej_T

    % mid ant ses1
    midants1_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses1,roi);
        midants1_T = [midants1_T,temp_region.dat];
        names{r} = name; 
    end
    midants1_T=array2table(midants1_T);
    midants1_T.Properties.VariableNames = names;
    midants1_T = [cell2table(pid_midant_s1'), midants1_T];
    midants1_T.Properties.VariableNames{1} = 'PID';
    save midants1_T.mat midants1_T

    % mid ant ses2
    midants2_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midant_ses2,roi);
        midants2_T = [midants2_T,temp_region.dat];
        names{r} = name; 
    end
    midants2_T=array2table(midants2_T);
    midants2_T.Properties.VariableNames = names;
    midants2_T = [cell2table(pid_midant_s2'), midants2_T];
    midants2_T.Properties.VariableNames{1} = 'PID';
    save midants2_T.mat midants2_T

    % mid out ses1
    midouts1_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses1,roi);
        midouts1_T = [midouts1_T,temp_region.dat];
        names{r} = name; 
    end
    midouts1_T=array2table(midouts1_T);
    midouts1_T.Properties.VariableNames = names;
    pid_fmidout_s1 = pid_fmidout_s1(~cellfun('isempty',pid_fmidout_s1));
    midouts1_T = [cell2table(pid_fmidout_s1'), midouts1_T];
    midouts1_T.Properties.VariableNames{1} = 'PID';
    save midouts1_T.mat midouts1_T

    % mid out ses2
    midouts2_T = [];
    names = [];
    all_regions = filenames(fullfile('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/*.nii'));
    for r = 1:length(all_regions)
        [filepath,name,ext] = fileparts(all_regions{r});
        roi = fmri_data(all_regions{r});
        temp_region = extract_roi_averages(final_data_midout_ses2,roi);
        midouts2_T = [midouts2_T,temp_region.dat];
        names{r} = name; 
    end
    midouts2_T=array2table(midouts2_T);
    midouts2_T.Properties.VariableNames = names;
    pid_fmidout_s2 = pid_fmidout_s2(~cellfun('isempty',pid_fmidout_s2));
    midouts2_T = [cell2table(pid_fmidout_s2'), midouts2_T];
    midouts2_T.Properties.VariableNames{1} = 'PID';
    save midouts2_T.mat midouts2_T

    % AAL3 atlas for all
    clear names
    atl = fmri_data('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/aal3/AAL3v1.nii');
    labels = readtable('/projects/b1108/studies/rise/data/processed/neuroimaging/roi/aal3/AAL3v1.nii.txt');
    labels(isnan(labels.Var3),:) = [];

    aal_chat_accrej_s1 = extract_roi_averages(final_data_chatroom_ses1_accrej,atl);
    aal_chat_acc_s1 = extract_roi_averages(final_data_chatroom_ses1_acc,atl);
    aal_chat_rej_s1 = extract_roi_averages(final_data_chatroom_ses1_rej,atl);
    aal_chat_accrej_s2 = extract_roi_averages(final_data_chatroom_ses2_accrej,atl);
    aal_chat_acc_s2 = extract_roi_averages(final_data_chatroom_ses2_acc,atl);
    aal_chat_rej_s2 = extract_roi_averages(final_data_chatroom_ses2_rej,atl);

    aal_mid_ant_s1 = extract_roi_averages(final_data_midant_ses1,atl);
    aal_mid_ant_s2 = extract_roi_averages(final_data_midant_ses2,atl);
    aal_mid_out_s1 = extract_roi_averages(final_data_midout_ses1,atl);
    aal_mid_out_s2 = extract_roi_averages(final_data_midout_ses2,atl);

    for i = 1:length(labels.Var2)
        T_aal_chat_accrej_s1(:,i) = aal_chat_accrej_s1(i).dat;
        T_aal_chat_acc_s1(:,i) = aal_chat_acc_s1(i).dat;
        T_aal_chat_rej_s1(:,i) = aal_chat_rej_s1(i).dat;
        T_aal_chat_accrej_s2(:,i) = aal_chat_accrej_s2(i).dat;
        T_aal_chat_acc_s2(:,i) = aal_chat_acc_s2(i).dat;
        T_aal_chat_rej_s2(:,i) = aal_chat_rej_s2(i).dat;

        T_aal_mid_ant_s1(:,i) = aal_mid_ant_s1(i).dat;
        T_aal_mid_ant_s2(:,i) = aal_mid_ant_s2(i).dat;
        T_aal_mid_out_s1(:,i) = aal_mid_out_s1(i).dat;
        T_aal_mid_out_s2(:,i) = aal_mid_out_s2(i).dat;

        names{i} = labels.Var2{i};
    end
    keyboard
    T_aal_chat_accrej_s1 = array2table(T_aal_chat_accrej_s1);
    T_aal_chat_accrej_s1.Properties.VariableNames = names;
    T_aal_chat_accrej_s1 = [cell2table(pid_chat_s1'), T_aal_chat_accrej_s1];
    T_aal_chat_accrej_s1.Properties.VariableNames{1} = 'PID';

    T_aal_chat_acc_s1 = array2table(T_aal_chat_acc_s1);
    T_aal_chat_acc_s1.Properties.VariableNames = names;
    T_aal_chat_acc_s1 = [cell2table(pid_chat_s1'), T_aal_chat_acc_s1];
    T_aal_chat_acc_s1.Properties.VariableNames{1} = 'PID';

    T_aal_chat_rej_s1 = array2table(T_aal_chat_rej_s1);
    T_aal_chat_rej_s1.Properties.VariableNames = names;
    T_aal_chat_rej_s1 = [cell2table(pid_chat_s1'), T_aal_chat_rej_s1];
    T_aal_chat_rej_s1.Properties.VariableNames{1} = 'PID';

    T_aal_chat_accrej_s2 = array2table(T_aal_chat_accrej_s2);
    T_aal_chat_accrej_s2.Properties.VariableNames = names;
    T_aal_chat_accrej_s2 = [cell2table(pid_chat_s2'), T_aal_chat_accrej_s2];
    T_aal_chat_accrej_s2.Properties.VariableNames{1} = 'PID';

    T_aal_chat_acc_s2 = array2table(T_aal_chat_acc_s2);
    T_aal_chat_acc_s2.Properties.VariableNames = names;
    T_aal_chat_acc_s2 = [cell2table(pid_chat_s2'), T_aal_chat_acc_s2];
    T_aal_chat_acc_s2.Properties.VariableNames{1} = 'PID';

    T_aal_chat_rej_s2 = array2table(T_aal_chat_rej_s2);
    T_aal_chat_rej_s2.Properties.VariableNames = names;
    T_aal_chat_rej_s2 = [cell2table(pid_chat_s2'), T_aal_chat_rej_s2];
    T_aal_chat_rej_s2.Properties.VariableNames{1} = 'PID';

    T_aal_mid_ant_s1 = array2table(T_aal_mid_ant_s1);
    T_aal_mid_ant_s1.Properties.VariableNames = names;
    T_aal_mid_ant_s1 = [cell2table(pid_midant_s1'),T_aal_mid_ant_s1];
    T_aal_mid_ant_s1.Properties.VariableNames{1} = 'PID';

    T_aal_mid_ant_s2 = array2table(T_aal_mid_ant_s2);
    T_aal_mid_ant_s2.Properties.VariableNames = names;
    T_aal_mid_ant_s2 = [cell2table(pid_midant_s2'),T_aal_mid_ant_s2];
    T_aal_mid_ant_s2.Properties.VariableNames{1} = 'PID';

    T_aal_mid_out_s1 = array2table(T_aal_mid_out_s1);
    T_aal_mid_out_s1.Properties.VariableNames = names;
    T_aal_mid_out_s1 = [cell2table(pid_fmidout_s1'),T_aal_mid_out_s1];
    T_aal_mid_out_s1.Properties.VariableNames{1} = 'PID';

    T_aal_mid_out_s2 = array2table(T_aal_mid_out_s2);
    T_aal_mid_out_s2.Properties.VariableNames = names;
    T_aal_mid_out_s2 = [cell2table(pid_fmidout_s2'),T_aal_mid_out_s2];
    T_aal_mid_out_s2.Properties.VariableNames{1} = 'PID';
    

    save T_aal_chat_accrej_s1.mat T_aal_chat_accrej_s1
    save T_aal_chat_accrej_s2.mat T_aal_chat_accrej_s2
    save T_aal_chat_acc_s1.mat T_aal_chat_acc_s1
    save T_aal_chat_acc_s2.mat T_aal_chat_acc_s2
    save T_aal_chat_rej_s1.mat T_aal_chat_rej_s1
    save T_aal_chat_rej_s2.mat T_aal_chat_rej_s2

    save T_aal_mid_ant_s1.mat T_aal_mid_ant_s1
    save T_aal_mid_ant_s2.mat T_aal_mid_ant_s2
    save T_aal_mid_out_s1.mat T_aal_mid_out_s1
    save T_aal_mid_out_s2.mat T_aal_mid_out_s2

end





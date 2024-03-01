basedir = '/Users/zacharyanderson/Documents/ACNlab/RISECREST/RISE/behavioral';
savedir = '/Users/zacharyanderson/Documents/ACNlab/RISECREST/RISE/timing_files';

mid = 0;
chat = 1;
chat_matlab = 0;
cd(basedir)

if chat == 1
    fnames = filenames(fullfile('sub-*/ses-1/beh/chzc*txt'));
    keyboard
    for sub = 1:length(fnames)
        txt = readtable(fnames{sub});
        
        pid{sub} = fnames{sub}(5:9); 
        
        % remove certain fields that make indexing more difficult
         

        chzt_on = txt.Var2(find(contains(txt.Var1,'ChzT.OnsetTime')));
        chzt_resp = txt.Var2(find(contains(txt.Var1,'ChzT.RESP')));
        chzt6_on = txt.Var2(find(contains(txt.Var1,'ChzT6.OnsetTime')));
        chzt6_resp = txt.Var2(find(contains(txt.Var1,'ChzT6.RESP')));
        
        selSub = txt.Var2(find(contains(txt.Var1,'SelSubj')));
        othSub = txt.Var2(find(contains(txt.Var1,'SelOth')));

        shwt_on = txt.Var2(find(contains(txt.Var1,'ShwT.OnsetTime')));
        shwt_resp = txt.Var2(find(contains(txt.Var1,'ShwT.RESP')));
        shwt2_on = txt.Var2(find(contains(txt.Var1,'Shw2.OnsetTime')));
        shwt2_resp = txt.Var2(find(contains(txt.Var1,'Shw2.RESP')));
        shwt6_on = txt.Var2(find(contains(txt.Var1,'Shw6.OnsetTime')));
        shwt6_resp = txt.Var2(find(contains(txt.Var1,'Shw6.RESP')));
        
        % onsets should all be relative to the first trial, which I believe
        % starts 4.05 seconds into the task. This is based on Busra's notes
        % as she recoded the chatroom to begin 2 seconds after the first
        % scope pulse, which should be at 2.05 seconds. This is a weird TR
        % for everyone reading this later. The decision was made by the PI
        % early on in a prior project that this was reasonable to use. The
        % lab has continued without using scope pulse locked tasks. I think
        % this might ultimately affect the timing, this is the best I can
        % figure.
        selb2 = selSub(1:15);
        selb3 = selSub(16:30);
        selb4 = selSub(31:45);
        chzb1 = (chzt_on(1:15)- chzt_on(1))./1000;
        chzb2 = (chzt_on(16:30)- chzt_on(1))./1000;
        chzb3 = (chzt_on(31:45)- chzt_on(1))./1000;
        chzb4 = (chzt6_on- chzt_on(1))./1000;
        showb1 = (shwt_on(1:15) - chzt_on(1))./1000;
        showb2 = (shwt2_on(1:15) - chzt_on(1))./1000;
        showb3 = (shwt2_on(16:30) - chzt_on(1))./1000;
        showb4 = (shwt6_on - chzt_on(1))./1000;
        
        showb2_rej = showb2(selb2==0);
        showb2_acc = showb2(selb2==2);
        showb3_rej = showb3(selb3==0);
        showb3_acc = showb3(selb3==2);
        
        names = {'Rejection','Acceptance','ParticipantChoice','OtherChoice','ControlChoice','ParticipantShow','ControlShow'};
      
        onsets{1} = [showb2_rej',showb3_rej']+4.05; onsets{2} = [showb2_acc',showb3_acc']+4.05;
        onsets{3} = chzb1+4.05; onsets{4} = [chzb2,chzb3]+4.05; onsets{5} = chzb4+4.05; onsets{6} = showb1+4.05; onsets{7} = showb4+4.05;

        durations{1} = ones(1,length(onsets{1})).*4;durations{2} = ones(1,length(onsets{2})).*4;
        durations{3} = ones(1,length(onsets{3})).*4;durations{4} = ones(1,length(onsets{4})).*4;
        durations{5} = ones(1,length(onsets{5})).*4;durations{6} = ones(1,length(onsets{6})).*4;
        durations{7} = ones(1,length(onsets{7})).*4;

        curr_filename = fullfile(savedir, strcat('sub-',pid{sub},'_ses-1_task-chatroom_run-1_timing.mat'));   
        save(curr_filename,'onsets','durations','names')
        
    end
end


if mid == 1
    fnames = filenames(fullfile('sub-*/ses-1/beh/3_*txt'));
    keyboard
    for sub = 1:length(fnames)
        % Load in the text file
        txt = readtable(fnames{sub});
        pid{sub} = fnames{sub}(5:9); 
        
        if isempty(txt) == 0
            
            % create vars for all time points of interest
            % target response
            tgt_on = txt.Var2(find(contains(txt.Var1,'Run1Tgt.OnsetTime')));
            tgt_dur = txt.Var2(find(contains(txt.Var1,'TgtDur')));
            % cue onset and duration
            cue_on1 = txt.Var2(find(contains(txt.Var1,'Run1Cue.OnsetTime')));
            cue_on1 = (cue_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000;
            cue_on2 = txt.Var2(find(contains(txt.Var1,'Run2Cue.OnsetTime')));
            cue_on2 = (cue_on2 - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000;
            if length(cue_on1)==length(cue_on2)                
                fbk_on1 = txt.Var2(find(contains(txt.Var1,'Run1Fbk.OnsetTime')));
                fbk_on1 = (fbk_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000;
                fbk_on2 = txt.Var2(find(contains(txt.Var1,'Run2Fbk.OnsetTime')));
                fbk_on2 = (fbk_on2 - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000;
                
                tgt_on1 = txt.Var2(find(contains(txt.Var1,'Run1Tgt.OnsetTime')));
                tgt_on1 = (tgt_on1 - txt.Var2(strcmp(txt.Var1,'Run1Fix.OnsetTime'))) ./ 1000;
                tgt_on2 = txt.Var2(find(contains(txt.Var1,'Run2Tgt.OnsetTime')));
                tgt_on2 = (tgt_on2 - txt.Var2(strcmp(txt.Var1,'Run2Fix.OnsetTime'))) ./ 1000;

                acc_on1 = txt.Var2(strcmp(txt.Var1,'Run1Tgt.ACC'));
                acc_on2 = txt.Var2(strcmp(txt.Var1,'Run2Tgt.ACC'));

                % I'm adding a '-' so that I can more easily refer to the
                % string below. When I only had a '1', too many replacements
                % were happening lol
    
                trial_type1 = strcat(string(txt.Var2(find(strcmp(txt.Var1,'RunList1')))),'-');
                trial_type2 = strcat(string(txt.Var2(find(strcmp(txt.Var1,'RunList2')))),'-');
                
                trial_type1 = replace(trial_type1,'1-','Run1 Win $5.00');
                trial_type1 = replace(trial_type1,'2-','Run1 Win $1.50');
                trial_type1 = replace(trial_type1,'3-','Run1 Win $0.00');
                trial_type1 = replace(trial_type1,'4-','Run1 Lose $5.00');
                trial_type1 = replace(trial_type1,'5-','Run1 Lose $1.50');
                trial_type1 = replace(trial_type1,'6-','Run1 Lose $0.00');
    
                trial_type2 = replace(trial_type2,'1-','Run2 Win $5.00');
                trial_type2 = replace(trial_type2,'2-','Run2 Win $1.50');
                trial_type2 = replace(trial_type2,'3-','Run2 Win $0.00');
                trial_type2 = replace(trial_type2,'4-','Run2 Lose $5.00');
                trial_type2 = replace(trial_type2,'5-','Run2 Lose $1.50');
                trial_type2 = replace(trial_type2,'6-','Run2 Lose $0.00');
                        
                % anticipation run 1
                onsets{1} = cue_on1(strcmp(trial_type1,'Run1 Win $5.00') | strcmp(trial_type1,'Run1 Win $1.50'))';
                onsets{2} = cue_on1(strcmp(trial_type1,'Run1 Win $0.00'))';
                onsets{3} = cue_on1(strcmp(trial_type1,'Run1 Lose $5.00') | strcmp(trial_type1,'Run1 Lose $1.50'))';
                onsets{4} = cue_on1(strcmp(trial_type1,'Run1 Lose $0.00'))';
                onsets{5} = tgt_on1';
                durations{1} = ones(1,length(onsets{1})).*4;durations{2} = ones(1,length(onsets{2})).*4;
                durations{3} = ones(1,length(onsets{3})).*4;durations{4} = ones(1,length(onsets{4})).*4;
                durations{5} = ones(1,length(onsets{5})).*4;
                names{1} = 'GainAnticipation';names{2} = 'Gain0Anticipation';
                names{3} = 'LossAnticipation';names{4} = 'Loss0Anticipation';
                names{5} = 'Motor';
                tempfname = fullfile(savedir, strcat('sub-',pid{sub},'_ses-1_task-mid_run-1_anticipation_timing.mat'));   
                save(tempfname,'onsets','durations','names')
                clear onsets durations names

                % anticipation run 2
                onsets{1} = cue_on2(strcmp(trial_type2,'Run2 Win $5.00') | strcmp(trial_type2,'Run2 Win $1.50'))';
                onsets{2} = cue_on2(strcmp(trial_type2,'Run2 Win $0.00'))';
                onsets{3} = cue_on2(strcmp(trial_type2,'Run2 Lose $5.00') | strcmp(trial_type2,'Run2 Lose $1.50'))';
                onsets{4} = cue_on2(strcmp(trial_type2,'Run2 Lose $0.00'))';
                onsets{5} = tgt_on2';
                durations{1} = ones(1,length(onsets{1})).*4;durations{2} = ones(1,length(onsets{2})).*4;
                durations{3} = ones(1,length(onsets{3})).*4;durations{4} = ones(1,length(onsets{4})).*4;
                durations{5} = ones(1,length(onsets{5})).*4;
                names{1} = 'GainAnticipation';names{2} = 'Gain0Anticipation';
                names{3} = 'LossAnticipation';names{4} = 'Loss0Anticipation';
                names{5} = 'Motor';
                tempfname = fullfile(savedir, strcat('sub-',pid{sub},'_ses-1_task-mid_run-2_anticipation_timing.mat'));   
                save(tempfname,'onsets','durations','names')
                clear onsets durations names

                % outcome run 1
                corrfbk1 = fbk_on1(acc_on1==1); corrtype1 = trial_type1(acc_on1==1);
                incorrfbk1 = fbk_on1(acc_on1==0); incorrtype1 = trial_type1(acc_on1==0);
                
                onsets{1} = corrfbk1(strcmp(corrtype1,'Run1 Win $5.00') | strcmp(corrtype1,'Run1 Win $1.50'))';
                onsets{2} = incorrfbk1(strcmp(incorrtype1,'Run1 Win $5.00') | strcmp(incorrtype1,'Run1 Win $1.50'))';
                onsets{3} = corrfbk1(strcmp(corrtype1,'Run1 Lose $5.00') | strcmp(corrtype1,'Run1 Lose $1.50'))';
                onsets{4} = incorrfbk1(strcmp(incorrtype1,'Run1 Lose $5.00') | strcmp(incorrtype1,'Run1 Lose $1.50'))';
                onsets{5} = tgt_on1';
                durations{1} = ones(1,length(onsets{1})).*4;durations{2} = ones(1,length(onsets{2})).*4;
                durations{3} = ones(1,length(onsets{3})).*4;durations{4} = ones(1,length(onsets{4})).*4;
                durations{5} = ones(1,length(onsets{5})).*2;
                names{1} = 'SuccessWin';names{2} = 'UnsuccessWin';
                names{3} = 'SuccessLoss';names{4} = 'UnsuccessLoss';
                names{5} = 'Motor';
                tempfname = fullfile(savedir, strcat('sub-',pid{sub},'_ses-1_task-mid_run-1_outcome_timing.mat'));   
                save(tempfname,'onsets','durations','names')
                clear onsets durations names corrfbk1 corrtype1 incorrfbk1 incorrtype1
                
                % outcome run 2
                corrfbk2 = fbk_on2(acc_on2==1); corrtype2 = trial_type2(acc_on2==1);
                incorrfbk2 = fbk_on2(acc_on2==0); incorrtype2 = trial_type2(acc_on2==0);
                
                onsets{1} = corrfbk2(strcmp(corrtype2,'Run2 Win $5.00') | strcmp(corrtype2,'Run2 Win $1.50'))';
                onsets{2} = incorrfbk2(strcmp(incorrtype2,'Run2 Win $5.00') | strcmp(incorrtype2,'Run2 Win $1.50'))';
                onsets{3} = corrfbk2(strcmp(corrtype2,'Run2 Lose $5.00') | strcmp(corrtype2,'Run2 Lose $1.50'))';
                onsets{4} = incorrfbk2(strcmp(incorrtype2,'Run2 Lose $5.00') | strcmp(incorrtype2,'Run2 Lose $1.50'))';
                onsets{5} = tgt_on2';
                durations{1} = ones(1,length(onsets{1})).*4;durations{2} = ones(1,length(onsets{2})).*4;
                durations{3} = ones(1,length(onsets{3})).*4;durations{4} = ones(1,length(onsets{4})).*4;
                durations{5} = ones(1,length(onsets{5})).*2;
                names{1} = 'SuccessWin';names{2} = 'UnsuccessWin';
                names{3} = 'SuccessLoss';names{4} = 'UnsuccessLoss';
                names{5} = 'Motor';
                tempfname = fullfile(savedir, strcat('sub-',pid{sub},'_ses-1_task-mid_run-2_outcome_timing.mat'));   
                save(tempfname,'onsets','durations','names')
                clear onsets durations names corrfbk2 corrtype2 incorrfbk2 incorrtype2
                
            else
                fprintf(strcat('Only one run for: ',pid{sub},'\n'))
            end
            
            %target_RTs_all(sub,:) = [target_RT1',target_RT2'];
        else
            fprintf(strcat('No MID data for: ',fnames{sub},'\n'))
            
        end
        
    end
    

end

if chat_matlab == 1
    fnames = filenames(fullfile('sub-*/ses-1/beh/*.csv'));
    for sub = 1:length(fnames)
        pid{sub} = fnames{sub}(5:9);
        T = readtable(fnames{sub});
        names = {'Rejection','Acceptance','ParticipantChoice','OtherChoice','ControlChoice','ParticipantShow','ControlShow'};
        chzT = T.trialOnset;
        chzTb1 = chzT(1:15);chzTb2 = chzT(16:30);chzTb3 = chzT(31:45);chzTb4 = chzT(46:60);
        shwT = T.trialFeedbackOnset;
        shwTb1 = shwT(1:15);shwTb2 = shwT(16:30);shwTb3 = shwT(31:45);shwTb4 = shwT(46:60);
        participant = T.blockAgent{1};
        selected_personb2 = T.trialCorrectSelection(16:30);
        selected_personb3 = T.trialCorrectSelection(31:45);
        acc = [shwTb2(strcmp(selected_personb2,participant))', shwTb3(strcmp(selected_personb3,participant))'];
        rej = [shwTb2(~strcmp(selected_personb2,participant))', shwTb3(~strcmp(selected_personb3,participant))'];
        
        names = {'Rejection','Acceptance','ParticipantChoice','OtherChoice','ControlChoice','ParticipantShow','ControlShow'};
        
        onsets{1} = rej; onsets{2} = acc;
        onsets{3} = chzTb1; onsets{4} = [chzTb2,chzTb3]; onsets{5} = chzTb4; onsets{6} = shwTb1; onsets{7} = shwTb4;

        durations{1} = ones(1,length(onsets{1})).*4;durations{2} = ones(1,length(onsets{2})).*4;
        durations{3} = ones(1,length(onsets{3})).*4;durations{4} = ones(1,length(onsets{4})).*4;
        durations{5} = ones(1,length(onsets{5})).*4;durations{6} = ones(1,length(onsets{6})).*4;
        durations{7} = ones(1,length(onsets{7})).*4;

        curr_filename = fullfile(savedir, strcat('sub-',pid{sub},'_ses-1_task-chatroom_run-1_timing.mat'));   
        save(curr_filename,'onsets','durations','names')
    end
end



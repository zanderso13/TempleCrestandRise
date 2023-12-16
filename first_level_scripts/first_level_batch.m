% Define input to single sub first levels script
% I think the best way to do this is going to be to find which files exist
% and then defining variables relative to those paths. It's going to be
% clunky and IT WILL CHANGE EVERYTIME YOU MOVE FILES AROUND. But since
% we're in BIDS format... Maybe I can actually make this more dynamic. 

scriptdir = '/projects/b1108/studies/rise/data/processed/neuroimaging/scriptdir';
basedir = '/projects/b1108/studies/rise/data/processed/neuroimaging';
% What run of your task are you looking at?
run = 1;
% What session appears in your raw filenames when in BIDS format?
ses = 2;
% Do you want to overwrite previously estimated first levels or just add to
% what you have? 1 overwrites, 0 adds
overwrite = 0;

% rest, consumption, anticipation
contrast = 'chatroom2'; % anticipation, outcome, chatroom

%%
fnames = filenames(fullfile(basedir,strcat('/smoothed_data/ssub*ses-',num2str(ses),'*chat*run-0',num2str(run),'*')));

if overwrite == 0
    fl_list = filenames(fullfile(basedir,'/fl/*/',strcat('ses-',num2str(ses),'/'),contrast,strcat('run-',num2str(run)),'SPM.mat'));
    counter = 1;
    for sub = 1:length(fnames)
        
        curr_sub = fnames{sub}(77:81);

        if isempty(find(contains(fl_list,curr_sub)))
            new_list(counter) = str2num(curr_sub);
            counter = counter + 1;
        else
            continue
        end
    end
end

% Run/submit first level script
repodir = '/home/zaz3744/repo';
cd(scriptdir)
keyboard
for sub = 1:length(new_list)
    ids = new_list(sub);
%    ses = 2;
%    run = 1;
%    overwrite = 0;
%     run_subject_firstlevel_BrainMAPD_PPI_run2(num2str(ids))

        s = ['#!/bin/bash\n\n'...
     '#SBATCH -A p30954\n'...
     '#SBATCH -p short\n'...
     '#SBATCH -t 01:00:00\n'...  
     '#SBATCH --mem=30G\n\n'...
     'matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(''' repodir ''')); run_sub_firstlevel_chatroom(' num2str(ids) '); quit"\n\n']; %, ' num2str(ses) ',' num2str(run) ',' num2str(overwrite) '); quit"\n\n'];
   
     scriptfile = fullfile(scriptdir, 'first_level_script.sh');
     fout = fopen(scriptfile, 'w');
     fprintf(fout, s);
     
     
     !chmod 777 first_level_script.sh
     !sbatch first_level_script.sh
     
end

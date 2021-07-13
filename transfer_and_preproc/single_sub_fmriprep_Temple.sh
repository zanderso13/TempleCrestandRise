#!/usr/bin/bash

#SBATCH -A p30954
#SBATCH -p normal
#SBATCH -t 24:00:00
#SBATCH --mem=64G
#SBATCH -J fmriprep_single_sub

module purge
module load singularity/latest
echo "modules loaded" 
cd /projects/p30954

echo "beginning preprocessing"

singularity run --cleanenv -B /projects/b1108:/projects/b1108/ /projects/b1108/software/singularity_images/fmriprep-20.1.1.simg --skip-bids-validation /projects/b1108/data/BIDS_factory/Temple/bids/Alloy_CREST /projects/b1108/projects/Temple/CREST participant --participant-label ${1} -t chatroom --fs-license-file /projects/b1108/software/freesurfer_license/license.txt --fs-no-reconall -w /projects/b1108/projects/Temple/work --clean-workdir
# change above to --clean-workdir so that the work directory is cleared and you save space

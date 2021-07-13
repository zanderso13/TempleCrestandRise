#!/bin/bash

# In this script I'm going to be moving files around so that we can download
# DICOM's from NUNDA, run this script, and have it be ready for bidskit after
# that. 

######################### USER SPECIFICATION #####################################
# Set your project directory here!

projectid="Alloy_CREST" # Alloy_CREST Alloy_RISE

# Specify where the unsorted data from XNAT will go. Note that part of this path will include the project ID

export raw_directory=/projects/b1108/data/BIDS_factory/Temple/data_dump/${projectid}

# Specify where you ultimately want BIDS formatted data to go. Again, the project ID is included in the path

export project_directory=/projects/b1108/data/BIDS_factory/Temple/bids/${projectid}

# How many sessions do you need to BIDS format

sessions=1

######################### END USER SPECIFICATION #################################

# the next lines move the zip file you upload from your personal input to where it needs to be

mv /projects/b1108/data/BIDS_factory/Temple/ZAZ*zip $raw_directory
unzip $raw_directory/ZAZ*zip

# next check for folders needed for bidskit conversion
# create them if they don't already exist

if [ -d "$project_directory/sourcedata" ]; then
	echo "sourcedata directory exists!"
else
	echo "Creating sourcedata folder"
	mkdir $project_directory/sourcedata
fi

# Next, I'm running into some folder name issues. So I'm going to sort all of the initial data folders by session first
# This will make it easier for me to reference/find them later

for sort in `seq 1 $sessions`;do
	if [ -d "$raw_directory/$sort" ]; then
		echo "Raw data has already been sorted!"
	else
		echo "Sorting raw directory by session"
		# This will actually move subject folders into session folders
		# So we kind of begin the restructuring here
		mkdir $raw_directory/$sort
		mv $raw_directory/$projectid* $raw_directory/$sort		
	fi
	
done

for sess in `seq 1 $sessions`;do
	echo "Starting session $sess"
	cd $raw_directory/$sess
	for sub in */;do
        	echo "Beginning Subject $sub"

		if [ -d "$project_directory/sourcedata/$sub/$sess" ]; then
			echo "sourcedata sub $sub sess $sess directory exists!"
		else
			echo "Creating subject folder"
			mkdir $project_directory/sourcedata/$sub
			echo "Creating session folder $sess"
			mkdir $project_directory/sourcedata/$sub/$sess
		fi
	
				
		echo "Finding DICOMs for session $sess...."
		echo "Transferring!"
		find $raw_directory/$sess/$sub/ -iname *.dcm -exec ln -s {} $project_directory/sourcedata/$sub/$sess/ \;
	done
done

# After sorting is finished we can move right into BIDS formatting
cd $project_directory
# This will begin the first run of bidskit. After that, some manual work will be needed
bidskit

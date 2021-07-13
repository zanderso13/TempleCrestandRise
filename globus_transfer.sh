#!/usr/bin/bash

# this depends on you already being logged into the northwestern globus endpoint: globus login (then follow the online portal login instructions that appears when you enter this)
# you will also need to connect your personal endpoint. run this: ~/globusconnect

# type: globus whoami
# you should see your northwestern login pop up (i.e. zaz3744@northwestern.edu)

#id=`globus get-identities zanderson130@globusid.org`
mv ~/Downloads/ZAZ3744*zip ~
id=`globus endpoint local-id`
cd ~
file=`ls ZAZ3744*.zip`

nuid=d5990400-6d04-11e5-ba46-22000b92c6ec

globus transfer --skip-activation-check --batch --label "cli test run" -v ${id}:${file} ${nuid}:/projects/b1108/data/BIDS_factory/Temple/${file}
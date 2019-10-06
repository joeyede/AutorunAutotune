

RUN apt-get update
RUN apt-get -y install sudo

## Source of next set of commands is: https://raw.githubusercontent.com/openaps/docs/master/scripts/quick-packages.sh 
## Modifed slightly to run in this config.  Comments explain mods.

#RUN sudo apt-get update && sudo apt-get -y upgrade
## removed npm from next lines list of packages, its not needed and fails in this config
RUN sudo apt-get install -y git python python-dev software-properties-common python-numpy python-pip nodejs-legacy watchdog strace tcpdump screen acpid vim locate jq lm-sensors bc
#RUN sudo pip install -U openaps 
#RUN sudo pip install -U openaps-contrib 
## Optional dev rules fails in this config dont install it:
#RUN sudo openaps-install-udev-rules 
#RUN sudo activate-global-python-argcomplete 
#RUN sudo npm install -g json oref0 
#RUN echo openaps installed 
#RUN openaps --version



## Set the locale
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

## For master branch use this:
# RUN npm list -g oref0 | egrep oref0@0.5.[5-9] || (echo Installing latest oref0 package &&  npm install -g oref0)


# For Dev Branch:
RUN mkdir ~/src
## Next line is cleanup before switch to dev branch.  No clue why this works got it from:
## https://gitter.im/nightscout/intend-to-bolus/archives/2018/11/30
#RUN npm ls -gp --depth=0 | awk -F/ '/node_modules/ && !/\/npm$/ {print $NF}' | xargs npm -g rm

RUN cd ~/src && git clone -b dev git://github.com/openaps/oref0.git || (echo doing checkout && cd oref0 && git checkout dev && git pull)
RUN cd ~/src/oref0 && npm run global-install



# Personal stuff:
ENV API_SECRET missing
ENV SITE_URL https://yousite.herokuapp.com
# Set Your Time zone
ENV TZ Europe/London  

# Config
ENV DAYS 1


RUN mkdir ~/myopenaps 
RUN mkdir ~/myopenaps/settings

RUN sudo apt-get install -y python3-pip
RUN pip3 install requests texttable

## Get script that downloads profiles from Nightscout 
## Credit 
RUN curl -s https://raw.githubusercontent.com/viq/oref0/profile_from_nightscout/bin/get_profile.py > get_profile.py

#build script to run

RUN echo '#!/bin/bash' > autotune-scrip.sh && \
    echo 'python3 get_profile.py --nightscout $SITE_URL  write --directory ~/myopenaps/settings/' >> autotune-scrip.sh && \
    echo 'oref0-autotune --dir=~/myopenaps --ns-host=$SITE_URL  --start-days-ago=$DAYS --categorize-uam-as-basal=true' >>  autotune-scrip.sh && \
    echo 'oref0-upload-profile ~/myopenaps/autotune/profile.json $SITE_URL $API_SECRET' >>  autotune-scrip.sh  && \
    echo 'python3 profile_trigger.py --site=$SITE_URL --api_key=$API_SECRET'
RUN chmod +x autotune-scrip.sh

#RUN python3 get_profile.py --nightscout $SITE_URL  write --directory ~/myopenaps/settings/
#RUN cat ~/myopenaps/settings/profile.json


#Copy in the files:profile.json, pumpprofile.json and autotune.json

#RUN cat autotune-scrip.sh
#RUN ./autotune-scrip.sh
Cmd ["./autotune-scrip.sh"]

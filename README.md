# AutorunAutotune
This is a Dockerfile + instructions to allow running Open APS Autotune automatically.

##Background:
This is designed to emulate the way Open APS runs Autotune nightly, allowing users of AndroidAPS to benefit from it. 
My understanding is Open APS uses the pump profile as its basline and then runs autotune against that.  Which it then
uses but dose not modify the base profile.  AutorunAutotune emulates this by using two Nightscout profiles:
- baseline - This is your trusted base profile which will be downloaded from nightscourt and autotune will run against.
- OpenAPS Autosync - This is the output profile which will be uploaded and **overwritten** if it already exists. 
The udpated "OpenAPS Autosync" profile will then be triggered activating it in AndroidAPS    

##Prerequisites
- You will need to know you nightscout URL and API secret. 
- You will need to have setup a profile called "baseline" 
- You will need Git installed to download this repository. 
- You will need to have Docker installed  to build and run the Docker image.  See https://www.docker.com/ for more info.

##Getting Started:
- create a directory you want to run this in. 
- change to that directory. 
To be continued ....
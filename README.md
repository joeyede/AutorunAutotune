# AutorunAutotune
This is a Dockerfile + instructions to make it easier to run Open APS Autotune and allow automation.

## Caution and disclaimer
By following these instructions you are using components provided by Open APS as a reference implementation.  Nobody can
guaranty this will do what you expect it to.  You will need to edit files and know things about your configuration to
make it work.
Also note by default this scripts pull the Beta branch of Open APS Autotune.    

## Background:
This is designed to emulate the way Open APS runs Autotune nightly, allowing users of AndroidAPS to benefit from it. 
My understanding is Open APS uses the pump profile as its basline and then runs autotune against that, which it then
uses without modifying the base profile.  AutorunAutotune emulates this by using two Nightscout profiles:
- baseline - This is your trusted base profile which will be downloaded from nightscourt and autotune will run against.
- OpenAPS Autosync - This is the output profile which will be uploaded and **overwritten** if it already exists. 
The udpated "OpenAPS Autosync" profile will then be triggered activating it in AndroidAPS    

### Making manual changes to your basal profile 
If you use AutorunAutotune regularly or automaticly and want to make a manual change to your basal profiles you will 
now need to **change 2 profiles**:
 - For changes to be active now you need to change "OpenAPS Autosync" and activate it (or activate a different profile)
 - If you want your change to persist you **must** change "basline" profiles.  If you don't the next time
  AutorunAutotune runs it will **overwrite** any changes you made with a fresh "OpenAPS Autosync" profile based on the 
  unmodified "baseline".
  
Automation can't fix everything and you may well need to do some manual tuning in addition to the automation.  
When you do please follow the above procedure.
 


## Prerequisites
- You will need to know you nightscout URL and API secret. 
- You will need to have setup a profile called "baseline" 
- You will need Git installed to download this repository. 
- You will need to have Docker installed  to build and run the Docker image.  See https://www.docker.com/ for more info.

## Getting Started:
- Create a directory you want to run this in. 
- Change to that directory. 
- Pull this repository from git
- Change in to the newly created git clone.

e.g. on Linux:
```shell script
mkdir testAutorunAuto
cd testAutorunAutot/
git clone https://github.com/joeyede/AutorunAutotune.git
cd AutorunAutotune/
````
You will now need to **modify** the Dockerfile.

 - Open the file called "Dockerfile" in a text editor and find the section labeled "#Personal stuff"
 - Replace *"missing"* with your API Secret
 - Replace *"https://yousite.herokuapp.com"* with your nightscout URL.
 - Replace *"Europe/London"* with the correct timezone.  You can find yours here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

This is the section you are looking for: 
```dockerfile
# Personal stuff:
ENV API_SECRET missing
ENV SITE_URL https://yousite.herokuapp.com
# Set Your Time zone
ENV TZ Europe/London  
```
Finally build the docker file and then run the new image:

```shell script
docker build . -t autot
docker run autot
```

If everything works you should have a new profile "OpenAPS Autosync" activated.

While running it will spit out lots of text here is what the tail of a run looks like:

```text
Autotune pump profile recommendations:
---------------------------------------------------------
Recommendations Log File: /root/myopenaps/autotune/autotune_recommendations.log

Parameter      | Pump        | Autotune    | Days Missing
---------------------------------------------------------
ISF [mg/dL/U]  | 72.000      | 72.000      |
Carb Ratio[g/U]| 9.000       | 9.360       |
  00:00        | 1.050       | 1.054       | 0           
  01:00        | 1.050       | 1.047       | 0           
  02:00        | 1.050       | 1.026       | 0           
  03:00        | 1.023       | 0.974       | 0           
  04:00        | 1.050       | 0.985       | 0           
  05:00        | 1.155       | 1.090       | 0           
  06:00        | 1.018       | 0.930       | 0           
  07:00        | 0.936       | 0.878       | 0           
  08:00        | 0.890       | 0.832       | 0           
  09:00        | 0.880       | 0.866       | 0           
  10:00        | 0.880       | 0.863       | 0           
  11:00        | 0.920       | 0.929       | 1           
  12:00        | 1.007       | 0.999       | 1           
  13:00        | 1.020       | 1.067       | 0           
  14:00        | 1.100       | 1.164       | 0           
  15:00        | 1.120       | 1.184       | 0           
  16:00        | 1.200       | 1.217       | 0           
  17:00        | 1.100       | 1.116       | 1           
  18:00        | 0.950       | 0.996       | 1           
  19:00        | 1.000       | 1.036       | 1           
  20:00        | 1.018       | 1.051       | 1           
  21:00        | 1.150       | 1.156       | 1           
  22:00        | 1.150       | 1.156       | 1           
  23:00        | 1.150       | 1.146       | 0           
Profile changed, uploading to Nightscout
Profile uploaded to Nightscout
Got response  is:[{"eventType":"Profile Switch","notes":"Applying autotune from 2020-07-10 14:57:02","enteredBy":"automation","reason":"Applying autotune from 2020-07-10 14:57:02","profile":"OpenAPS Autosync","duration":0,"created_at":"2020-07-10T13:57:02.742Z","utcOffset":0,"_id":"5f0873ae1ad3f283bc8ccd6d"}]
```

## Automating this
The short version:
Use your automatoin tool of choice to run the command:
```shell script
docker run autot
```
at a time of your choice (I use 2am)

If there is a demand I will write up instructions on how to do this for free on Google Cloud. 

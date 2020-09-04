# AutorunAutotune
This is a Dockerfile + instructions to make it easier to run OpenAPS Autotune and allow automation.

# Status: In testing. Only has a few users, use at your own risk!

## Caution and disclaimer
By following these instructions you are using components provided by OpenAPS as a reference implementation.  Nobody can
guaranty this will do what you expect it to.  You will need to edit files and know things about your configuration to
make it work.

Also:
 - By default this script pulls the Beta branch of OpenAPS Autotune. 
 - This currently assumes are you are announcing meals and not relying on UAM. 
 - This has not been tested outside UK and may or may not work in other timezones.  
 - You should pause this while traveling as I have no idea what will happen when crossing time zones.   

## Background:
This is designed to emulate the way OpenAPS runs Autotune nightly, allowing users of AndroidAPS to benefit from it. 
OpenAPS uses the pump profile as its baseline and will not allow more the 20% deviation from it. It also pulls the latest
profile and then runs autotune against that.  AutorunAutotune uses a simplified version of this by using two Nightscout profiles:
- baseline - This is your trusted base profile which will be downloaded from nightscout and autotune will run against. 
It is used for both the "pump profile" and current profile.
- OpenAPS Autosync - This is the output profile which will be uploaded and **overwritten** if it already exists. 
The updated "OpenAPS Autosync" profile will then be triggered activating it in AndroidAPS (You need to have NS Profile selected in AndroidAPS rather than Local Profile)

### Making manual changes to your basal profile 
If you use AutorunAutotune regularly or automaticly and want to make a manual change to your basal profiles you will 
now need to **change 2 profiles**:
 - For changes to be active now you need to change "OpenAPS Autosync" and activate it (or activate a different profile)
 - If you want your change to persist you **must** change "baseline" profiles.  If you don't the next time
  AutorunAutotune runs it will **overwrite** any changes you made with a fresh "OpenAPS Autosync" profile based on the 
  unmodified "baseline".
  
Automation can't fix everything and you may well need to do some manual tuning in addition to the automation.  
When you do please follow the above procedure.
 
You can either run in an enviorment of your choice: 

[Run Standalone](docs/running-standalone.md)

or

[Run on Google Cloud](docs/running-on-gcp.md)


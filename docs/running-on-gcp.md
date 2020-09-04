# Running on GCP
This section details how to set this up to run automatically on Google Cloud.
This should be possible using the Free tier, so you shouldn't be charged, but I haven't fully tested this yet.
Note you will need to set up billing, even if this doesn't incur any charges. 

## QuickStart
Create a new cloud project. Open the cloud Shell and make sure the new project is active:
```shell script
$ gcloud config set project {Project-ID}
```
Then:
```shell script
$ git clone https://github.com/joeyede/AutorunAutotune.git
$ cd AutorunAutotune

```
Now edit the Dockerfile as described in [Run Standalone](docs/running-standalone.md#update-docker-file)
Additionally, you need to edit last lines of Dockerfile.  Uncomment the last CMD and comment out the CMD before that.
should now look like this:
```dockerfile
# To run from docker directly use:
#CMD ["./autotune-scrip.sh"]

# Run the web service on container startup.
CMD [ "npm", "start" ]
```

Now run:
```shell script
$ ./gcp-setup.sh
```
Take a look inside the script to see what it does.
Once it runs (it takes a while) you should have the docker image running as a Serverless Cloud Run endpoint, 
and a timer function setup to trigger it every day at 2:05am.

If you need to make changes to any of the files you will just need to rebuild the docker image and update the cloud function.
To do that simply run:
```
gcloud builds submit --config cloudbuild.yaml .
```

You can see the scheduler in the [Cloud Scheduler section](https://console.cloud.google.com/cloudscheduler) in 
the GCP console.  Here you can also see a Run now button if you want to test this right now.

You can see the actual Run Function in the [Cloud Run section](https://console.cloud.google.com/run) in the GCP 
console. This also has an execution record, and you can [see the logs](viewing-logs.md) to see if it all worked.  
Once this runs you will see the new profile activation on your Android APS display on your phone. 

  
##A bit more detail
The above assume some knowledge in GCP.  Here is a bit more detail: As the first step you need to setup a GCP project
and billing account.  There are 100's of tutorials for this but the super short version: In a browser where you are 
logged in to a Google account (you may want to create a new one to make sure this is all fresh) go to 
https://console.cloud.google.com/ and setup a new project.  check what its ID is in the project pull
down on top left. 

On the top right next to search bar you should see an icon that looks like this: >_ "Activate Cloud Shell" this opens
a command line prompt you can use to configure your cloud project to run the docker image.
Here you will start running the commands listed above. 

#!/bin/bash

#
# Script to setup cloud run to run 2:05 am every night
#


#Enabled API's
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com 
gcloud services enable cloudscheduler.googleapis.com

#caputre project number for setting up iam permissions
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:${GOOGLE_CLOUD_PROJECT}"  --format='value(project_number)')

#Let cloud build deploy a cloud run image
gcloud projects add-iam-policy-binding "${PROJECT_NUMBER}" \
   --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
   --role="roles/run.admin"

gcloud iam service-accounts add-iam-policy-binding \
  ${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

#Build and deply the service
gcloud builds submit --config cloudbuild.yaml .

#caputre it's URL
SERVICE_URL=$(gcloud beta run services describe autot --platform managed --region us-east4    --format="get(status.url)")

#Create Service acount for invoking the service
gcloud iam service-accounts create autot-invoker --display-name "My autot-invoker servce account"

#Let invoker Service invoke a cloud run service 
gcloud run services add-iam-policy-binding autot \
   --member=serviceAccount:autot-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
   --role=roles/run.invoker --platform managed --region us-east4

#setup schedule for 2:05 am using service acount to invoke the cloud run instance. 
gcloud app create --region=us-east4
gcloud beta scheduler jobs create http autot-schedual --schedule "05 2 * * *" \
   --http-method=get \
   --uri=${SERVICE_URL}/exec \
   --oidc-service-account-email=autot-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com

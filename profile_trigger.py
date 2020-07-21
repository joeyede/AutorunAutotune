#!/usr/bin/python3

# Script to trigger profile change to OpenAPS Autosync
# Can be used to trigger automatic profile change after autotune
#

from datetime import datetime
import hashlib

import sys
import argparse
import requests


def trigger(site, api_key):
    # defining the api-endpoint
    if not site.endswith('/'):
        site += '/'

    api_endpoint = site + "api/v1/treatments.json"
    api_key_sh1=hashlib.sha1(bytes(api_key, 'utf-8')).hexdigest()

    # datetime object containing current date and time
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    data = {"enteredBy": "automation",
            "eventType": "Profile Switch",
            "reason": "Applying autotune from " + now,
            "duration": 0,
            "profile": "OpenAPS Autosync",
            "notes": "Applying autotune from " + now}

    # sending post request and saving response as response object 
    r = requests.post(url=api_endpoint, data=data, headers={'API-SECRET': api_key_sh1}) 

    # extracting response text
    res = r.text 
    print("Got response  is:%s"%res) 


def print_usage(apname):
    print(apname + ' --site <nightscoute_URL> --api_key <api_key>') 
    print('e.g.:')
    print(apname + ' --site=\"https://mysite.herokuapp.com\" --api_key=\"mysecretekey\"')


def main(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--site',   help='URL for NightScout site', required=True)
    parser.add_argument('--api_key', help='API key for your NightScou site', required=True)
    args = parser.parse_args()

    trigger(args.site, args.api_key)


if __name__ == "__main__":
    main(sys.argv)

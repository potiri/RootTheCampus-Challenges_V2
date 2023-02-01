#!/usr/bin/python3

import os
import sys
import subprocess
import random
import string
import signal
import threading
import shutil
from pathlib import Path

TOKEN_CHAR_SET = string.ascii_lowercase + string.digits
TOKEN_LEN = 10
# TODO: fix docker env propagation. Why not accessible? -> shoudl be ~/.ssh/environment
# For now just read some files specially created for this purpose
home = str(Path.home())
with open(str(Path.home()) + "/.ds_project_name", "r") as f:
    DS_PROJECT_NAME = f.readline().strip()
with open(str(Path.home()) + "/.ds_start_container", "r") as f:
    DS_START_CONTAINER = f.readline().strip()
    
with open(str(Path.home()) + "/.ds_exposed_container", "r") as f:
    DS_EXPOSED_CONTAINER = f.readline().strip()


ds_project_name_unique = None
ds_start_container_unique = None
tmp_names_env_file = None
reuse_session = False
session_token = None


def cleanup():
    if (ds_project_name_unique):
        try:
            print("Destroying session. This may take some seconds. Please wait...")
            #print("Executing:", f'sudo /usr/bin/nohup /usr/bin/docker-compose --env-file "{tmp_names_env_file}" -f "/srv/compose_projects/{DS_PROJECT_NAME}/docker-compose.yml" -p "{ds_project_name_unique}" down &')
            # set preexec_fn to ignore signint on this subprocess
            subprocess.Popen(f'sudo /usr/bin/nohup /usr/bin/docker-compose --env-file "{tmp_names_env_file}" -f "/srv/compose_projects/{DS_PROJECT_NAME}/docker-compose.yml" -p "{ds_project_name_unique}" down; rm "{tmp_names_env_file}"', shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT, preexec_fn=os.setpgrp).wait()
            
            # Delete tmp env file
            #if tmp_names_env_file:
            #    os.remove(tmp_names_env_file)
            print("Session successfully destroyed. Bye.")
            sys.exit(0) 
        except Exception as e:
            print("An unexpected error occured on clean up:", e)
            sys.exit(1)


def graceful_exit(signum, frame):
    signal.signal(signum, signal.SIG_IGN) # ignore additional signals
    try:
        cleanup()
    except Exception:
        sys.exit(1)
       
       
def create_tokenized_name(name):
    return name + "-" + session_token


if __name__ == "__main__":   
    print()
    print("~~~~~~~~~~ Session Manager ~~~~~~~~~~")
    print()

    return_code = -1
    while return_code != 0:
        try:
            existing_session_token = input("Enter your session token or leave blank to start a new session:").lower().strip()
            # loop with check to see if running
            if existing_session_token == "":
                reuse_session = False
                session_token = ''.join(random.choices(TOKEN_CHAR_SET, k=TOKEN_LEN))
            elif len(existing_session_token) == TOKEN_LEN and all(c in TOKEN_CHAR_SET for c in existing_session_token):
                reuse_session = True
                session_token = existing_session_token
            else:
                print("Token format incorrect. Try again")
                continue

            print()
            
            ds_project_name_unique = create_tokenized_name(DS_PROJECT_NAME) 
            ds_start_container_unique = create_tokenized_name(DS_START_CONTAINER) 
            
            if reuse_session:
                return_code = subprocess.run([f'sudo /usr/bin/docker container inspect "{ds_start_container_unique}"'], shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT).returncode
                if return_code != 0:
                    print("Entered session does not exist. Try again")
                else:
                    print("Using existing session...")
            else:
                return_code = 0

        except Exception as e:
            print("An unexpected error occured:", e)
            sys.exit("Closing session manager")

    print("Take note of your session token. It allows you to attach to the current session.")
    print("Please logout (Crtl + d) of the session gracefully if not needed anymore.")
    print()
    print("-------------------------------------")
    print("Session token:", f'\033[92m{session_token}\033[0m')
    print("-------------------------------------")
    print()
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print()
    
    try:
        if not reuse_session:
            # only needed when in main session
            signal.signal(signal.SIGINT, graceful_exit)
            # TODO: ssh close not catched
            #signal.signal(signal.SIGTERM, graceful_exit)
            #signal.signal(signal.SIGHUP, graceful_exit)

            print("Preparing new session. This may take some seconds. You will join automatically when ready...")
            
            # subprocess.Popen() should support env arg but not taken into account by docker
            # so just provide a.env with default container names, edit them on the fly and save to tmp
            tmp_names_env_file = f'/tmp/{ds_project_name_unique}.env.names'
            subprocess.Popen(f'sed "s/$/-{session_token}/" "/srv/compose_projects/{DS_PROJECT_NAME}/.env.names" > "{tmp_names_env_file}"', shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT).wait()

            # TODO: build probably not needed
            subprocess.Popen(f'sudo /usr/bin/docker-compose --env-file "{tmp_names_env_file}" --project-directory "/srv/compose_projects/{DS_PROJECT_NAME}" -p "{ds_project_name_unique}" up -d --build', shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT).wait()

        
        if DS_EXPOSED_CONTAINER: # and False:
            print()
            print("Exposed ports [internal -> external]")
            ds_exposed_container_unique = create_tokenized_name(DS_EXPOSED_CONTAINER)
            #pro = subprocess.Popen(f'sudo /usr/bin/docker port "{ds_exposed_container_unique}"', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT).wait()
            with subprocess.Popen(f'sudo /usr/bin/docker port "{ds_exposed_container_unique}"', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT) as proc:
                for line in iter(proc.stdout.readline, b''):
                    print(line.strip())

        # attach to DS_START_CONTAINER docker container with a bash
        subprocess.Popen(f'sudo /usr/bin/docker exec -it "{ds_start_container_unique}" /bin/bash', shell=True).wait()

        confirmation_loop = True
    
        while not reuse_session and confirmation_loop:
            confirmation_loop = False
            destroy_session = input("\033[91m" + "If you close this main session your progress will be lost. Destroy session? [y/n]" + "\033[0m").lower().strip()
            if destroy_session == "y":
                cleanup()
            else:
                confirmation_loop = True
                print("Rejoining session...")
                subprocess.Popen(f'sudo /usr/bin/docker exec -it "{ds_start_container_unique}" /bin/bash', shell=True).wait()
    except Exception as ex:
        cleanup()
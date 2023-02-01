# RootTheCampus-Challenges
Some intentionally vulnerable docker containers used for the RootTheCampus CTF

USE AT OWN RISK!

Info: 
* The **Simple SSH** challenge includes a ssh private key which has to be cracked for the challenge. You may generate a new one. 
* The **Docker Spawn** container allows spawning of individual docker environments for the user. To access a public key in openssh format is required in docker_spawn/ssh_key/id_rsa.pub
* Currently docker containers created by **Docker Spawn** are not clean up correctly if a ssh window is closed ungracefully. You might create a cronjob utilizing ds-cleanup.sh which deletes all **Docker Spawn** projects older than 3 hours.

Startup:
```sh
docker compose up --build
```

TODO:
* Fix docker spawn container clean up if ssh windows is closed (not by ctrl+c or ctrl+d)
* Auto generate **Docker Spawn** ssh keys if not present
* Replace flag creation (chmod, chown, chgrp) code with docker USER directive

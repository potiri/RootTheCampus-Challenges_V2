# RootTheCampus-Challenges
Some intentionally vulnerable docker containers used for the RootTheCampus CTF

USE AT OWN RISK!

Info: 
* The **Simple SSH** challenge includes a ssh private key which has to be cracked for the challenge. You may generate a new one. 
* The **Docker Spawn** container allows spawning of individual docker environments for the user. To access a public key in openssh format is required in docker_spawn/ssh_key/id_rsa.pub

Startup:
```sh
docker compose up --build

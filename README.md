# Awesome-manager installation 
## Make all works:
- Install Docker:
  - [Ubuntu](https://docs.docker.com/engine/install/ubuntu/):
    - [Uninstall old versions](https://docs.docker.com/engine/install/ubuntu/#uninstall-old-versions)
    - [Install using the repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
    - Install Docker Engine
  - [Elementary OS](https://snapcraft.io/install/docker/elementary)
- [Install Docker compose](https://docs.docker.com/compose/install/) or use commands:
  - sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  - sudo chmod +x /usr/local/bin/docker-compose
- Install node.js (v14.x) and npm by commands:
  - curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  - sudo apt-get install -y nodejs
- [Install yarn](https://classic.yarnpkg.com/en/docs/install#debian-stable)
- Install make:
  - sudo apt install make
- In file /etc/hosts add:  
  **127.0.0.1** manager.hm
- Create a directory for a project
- Clone this rep: git clone https://github.com/awesome-manager/deployer.git
- Execute this commands in cmd:
  - cd deployer
  - cp env.example .env
  - make all
- Go to manager-front directory and use yarn dev

## Command list:
### Make all work
- make all
### Start/stop services
- make run
- make stop
### Download repositories
- make download
### Certification Installation
- make install-certs
- make prepare-certs
### Rebuild nginx
- make prepare-nginx
### Rebuild gateway
- make prepare gateway
### Git checkout master and pull origin master
- make prepare-git
### Rebuild backend containers
- make prepare-containers
### Composer i for php containers
- make prepare-composer
### Yarn install for front
- make prepare-front

## Note
For services to work via https on the local machine is used [mkcert](https://github.com/FiloSottile/mkcert).

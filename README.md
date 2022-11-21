Awesome-manager installition 
### Serts installition
- make install-certs
- make prepare-certs
### Add domain name
In file /etc/hosts add:  
**127.0.0.1** manager.hm
### Start/stop services
- make run
- make stop
### Rebuild nginx
- make prepare-nginx
### Rebuild gateway
- make prepare gateway

## Note
For services to work via https on the local machine is used [mkcert](https://github.com/FiloSottile/mkcert).

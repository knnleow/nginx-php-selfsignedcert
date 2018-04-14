# nginx-php-selfsignedcert
Docker nginx with php-fpm, self-sign-cert, ubuntu 16.04

## Note
my NAS crash few days back. Pending Power Supply replacement.
will update the Dockerfile after Disk recovery.
Good thing that come out of this. Learned to use github to store my configuration repository. 

## Description
A Dockerfile that installs ubuntu 16.04 with nginx 1.10.0, and php-fpm 7.0 based on
docker-nginx-fpm-ssl. Database not included.

Use the following docker-compose.yml for quick stand up wordpress with mysql 5.7.
Create File docker-compose.yml

## docker-compose.yml

    version: 3
    services:
        nginx:
            image: knnleow/nginx-php-selfsignedcert:1.0
            environment:
                SERVER_NAME: cdn01.demo.co
                mysslsubject: "/C=SG/ST=Singapore/L=Singapore/O=demo.co/OU=DEMO_Lab/CN=cdn01.demo.co/emailAddress=admin@demo.co"
                myloginuser: admin
                myregion: Asia
                mycountry: Singapore
            ports:
                - 9080:80
                - 9443:443
            volumes:
                - ./nginx/log:/var/log/nginx
                - ./nginx/sites-available:/etc/nginx/sites-available
                - ./letsencrypt:/etc/letsencrypt
                - ./data01:/var/www/html
                - nginx-backup:/nginx-backup
    volumes:
        nginx-backup: {}
        
## Execute Command to start a new nginx instance

    docker-compose up

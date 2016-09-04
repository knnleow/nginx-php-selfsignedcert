#!/bin/bash

# START ALL Configuration COMMANDS that need to Run Once

/bin/echo "upate my Timezone"
/bin/echo $myregion/$mycountry > /etc/timezone && \
/bin/rm /etc/localtime && \
/bin/ln -s /usr/share/zoneinfo/$myregion/$mycountry /etc/localtime

/bin/echo "Change root password"
/bin/echo "root:`pwgen -c -n -1 32`" |chpasswd && \
/bin/rm -rf /root/.ssh

/bin/echo "Create User n Group"
/usr/sbin/groupadd -g 1000 $myloginuser && \
/usr/sbin/useradd -d /home/$myloginuser -g 1000 -m -s /bin/bash -u 1000 $myloginuser && \
/bin/echo "$myloginuser:`pwgen -c -n -1 32`" |chpasswd && \
/bin/mkdir /home/$myloginuser/.ssh && \
/bin/chmod 700 /home/$myloginuser/.ssh

/bin/echo "Create Openssl Cert"
export sslcert="myssl-cert" && \
/usr/bin/openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/$sslcert.key -out /etc/ssl/certs/$sslcert.crt -subj $mysslsubject  && \
/bin/chmod 644 /etc/ssl/certs/$sslcert.crt && \
/bin/chmod 600 /etc/ssl/private/$sslcert.key

/bin/echo "Update the nginx config file to the final destination"
/bin/echo "Do this in provision for use with docker-compose where u want to expose volume sites-available to Host"
/bin/cp /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default    && \
/bin/rm /etc/nginx/sites-enabled/default                                       && \
/bin/ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

/bin/echo "Remove .run-once file so this will script will run one time only...."
/bin/rm -f /script.d/.run-once

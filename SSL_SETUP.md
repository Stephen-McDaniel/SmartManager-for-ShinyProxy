Complete all the steps in INSTALL.md first.

If you are building a production server, setup your DNS records using the server name and IP address. If you aren't familiar, create an "A" record with the public server IP address. This enables you to obtain a free SSL certificate based on the server name (e.g. - my.server.com.) 

If your server is located in a private, isolated network, you will need to obtain SSL separately or modify the NGINX config at /yakdata/apps/config/nginx/templates/default.conf.conf. 

**Obtaining SSL for Your New Server**

1) Update the variables in /yakdata/apps/.env, these are used by docker-compose. 

```bash
nano /yakdata/apps/.env
```

2) Reboot the host system

```bash
sudo reboot
```

3) Issue your first SSL certificate, on the server run

```bash
sudo mkdir /yakdata/certs
sudo chmod 777 /yakdata/certs
sudo /yakdata/utilities/scripts/renewssl.sh
```

+ This will stop all currently running containers.
+ A new SSL certificate will be obtained and configured for use with NGINX.
+ A reboot occurs.
+ All SmartManager for ShinyProxy containers will come back up at the end of this process. 
+ It typically takes around 3-6 minutes for this to complete.
+ A /etc/cron.d schedule early every Sunday will check if the SSL is more than 60 days old, if so, it will renew it automatically. This will briefly bring down the server at 08:33 UTC. Head over to /etc/cron.d/checkagerenewssl if you want to change this time or disable this service. 

4) About a minute after the server reboot completes, head over to https://your.domain.com and login as one of the sample users in /yakdata/config/shinyproxy/application.yml.

5) IMPORTANT - delete the sample users or change their passwords, at a minimum. The sample user "stephen" has full admin privileges via the web interface.
   
```bash
nano /yakdata/config/shinyproxy/application.yml
```

6) If you are a commercial user, per the [YUMMY License](https://github.com/Stephen-McDaniel/SmartManager-for-ShinyProxy/blob/master/LICENSE.md), head over to YakData.com and buy a license key within ten days of deployment. The license key is free for non-commercial use, visit the [YakData Community](https://meta.yakdata.com) for instructions for the simple personal use license steps. Amazon Web Services AMI pricing includes the commercial license, just follow the AMI instructions. 

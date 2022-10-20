Install a complete ShinyProxy system with Yakdata SmartManager for ShinyProxy

Short-circuit the install with the [Amazon Web Services AMI of YakData SmartManager for ShinyProxy](https://aws.amazon.com/marketplace/pp/prodview-de7oj4x576blg). If the AMI image doesn't work for your situation, here is the play-by-play way to build your very own secure ShinyProxy system with free SSL, up-to-date R images, awesome monitoring with grafana/prometheus/cadvisor built-in, ShinyProxy web page templates and so much more already on-board.

1) The preferred way to install this into a complete environment is to install docker, docker-compose and other supporting packages on Ubuntu 20.04. Follow the instructions in [Stephen-McDaniel/ubuntu-20-04-update-docker-compose](https://github.com/Stephen-McDaniel/ubuntu-20-04-update-docker-compose) to meet all the prerequisites for this system. 
Alternatively, use a cloud OS image with docker and docker-compose pre-installed.

2) The preferred way to proceed is to use R from rocker/geospatial (called in this project's docker-compose.yml file.) 
Alternatively, if you install your own R docker containers to run apps, then execute:

```bash
sudo mkdir /yakdata
sudo mkdir /yakdata/apps
sudo chown ubuntu:ubuntu /yakdata
mkdir /yakdata/apps/logs-docker-compose-builds
```

3) Upload /yakdata in this repository to /yakdata on the host system

```bash
# I prefer to download repositories, 
#    unzip them and then upload via RSync.
# Alternatively, use "git" on the server or 
#    wget and unzip on the server.

# run on local machine after unzipping the repo
dir_local="/path/to/downloaded/and/unzippped/repo/yakdata/"
dir_remote=/yakdata
keyfile='/path/to/your/pem/my.pem'
host=my.host.com

cd "$dir_local"

# rsync must be installed on local and server
rsync --progress -h -v -r -P -t -z --no-o --no-g \
      -e "ssh -i $keyfile" \
      $dir_local ubuntu@$host:$dir_remote
```

4) On the server, run:

```bash
# run the following command as root
sudo su -

cp /yakdata/utilities/etc_cron.d/* /etc/cron.d
chmod 644 /etc/cron.d/*

chmod +x /yakdata/utilities/scripts/*.sh

chmod +x /yakdata/apps/R/4.1.3/scripts/*.sh

chmod +x /yakdata/apps/nginx/1.21.6/*.sh

mkdir /yakdata/sysdata
mkdir /yakdata/sysdata/prometheus_data
mkdir /yakdata/sysdata/grafana_data
mkdir /yakdata/R

chmod -R 777 /yakdata/sysdata/prometheus_data
chmod -R 775 /yakdata/config/prometheus

sudo chmod 775 /yakdata/R

chmod -R 777 /yakdata/sysdata/grafana_data
chmod -R 775 /yakdata/config/grafana
chmod -R 777 /yakdata/apps/logs-docker-compose-builds

# end of run as root
exit
```

5) On the server, run:
```bash
cd /yakdata/apps/

docker network create yakdata

# build the system
(
docker-compose build 
) 2>&1 |& tee /yakdata/apps/logs-docker-compose-builds/R-shinyproxy-2.6.1.log

# write to site-library
chmod -R 777 /yakdata/sysdata/R/4.1.3/site-library

# pull images in docker-compose 
docker-compose pull shinyproxy cadvisor prometheus nginx grafana
```

Next, complete all steps in [/yakdata/SSL_SETUP.md](SSL_SETUP.md). 

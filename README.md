# Building an IBM Data Server Manager Docker Container

## Download Data Server Manager

IBM Data Server Manager from [developerworks](http://www.ibm.com/developerworks/downloads/im/dsm/)

or

Go to [IBM Fix Central](https://www-945.ibm.com/support/fixcentral/?productGroup0=ibm/fcpower)

Go to Tab **Select Product**. Choose Product Group **Information Management**, select **Data Server Manager** and select the latest version from the Installed Version and select **Linux** platform.

Download the Data Server Manager latest fix pack.

Optionally, you can also download the EE license from IBM Passport Advantage site.

The name of the license file is : `ibm-datasrvrmgr-enterprise-license-activation-kit-linux-x86_64.tgz`

## Unzip Contents
Unzip the contents of the latest version of the Fix Pack in a directory of your choice.

The example given here is for DSM 2.1.5.
```
tar xvfz 2.1.5-IM-Data-Server-Manager-linux-x86_64.tgz
```
If you also donwloaded the EE license file from Passport advantage, extract the content in the

`tar xvfz /tmp/ibm-datasrvrmgr-enterprise-license-activation-kit-linux-x86_64.tgz -C ./ibm-datasrvrmgr`

## Build Docker Container
The Dockerfile is as shown below:

```
FROM centos:7
ARG CONT_IMG_VER="latest"
MAINTAINER vikram@zinox.com
WORKDIR /opt
ADD ibm-datasrvrmgr /opt/ibm-datasrvrmgr/
ADD start_dsm.sh /opt/
RUN yum -y update &&  yum -y install curl tar wget which && yum clean all
RUN chmod +x /opt/start_dsm.sh
ENTRYPOINT [ "/opt/start_dsm.sh" ]
```

Run command
```Bash
docker build -t ibm/dsm:v2.1.5 -f Dockerfile .
```
Replace the version number with the number that you downloaded from IBM Fix Central.

## Run and Deploy IBM Data Server Manager Image

In order to run the docker container, we need to pass environment variables for the configuration of the Data Server Manager and the repository database.

Environment Variables - Keep them in file dsm.env

### Option - 1 (Community Edition - No persistence of data in a repository)

```
HTTP_PORT=11080
HTTPS_PORT=11081
STATUS_PORT=11082
WEB_USER=admin
WEB_PWD=password
```
Choose appropriate values of the http port, https port, status port, web user name and the password and modify the dsm.env

### Option - 2 (Enterprise Edition - Respository database to store history)
```
HTTP_PORT=11080
HTTPS_PORT=11081
STATUS_PORT=11082
WEB_USER=admin
WEB_PWD=password
REP_HOST=localhost
REP_PORT=50000
REP_DBNAME=DSMDB
REP_USER=dsm
REP_PWD=password
```
### Different Run Options

#### Simple RUN

Expose port 11080 for the http access. Use container host name as **dsmhost**, name of the container **dsm**, pass all parameters using `--env-file` option and the name of the environment file `dsm.env`.
```
docker run -d -it \
  --name=dsm \
  --env-file=./dsm.env \
  -h dsmhost \
  -p 11080:11080 \
  ibm/dsm:v2.1.5
```
#### Externalize Config and log folder from container to the host

```
docker run -d -it \
  --name=dsm \
  --env-file=./dsm.env \
  -h dsmhost \
  -p 11080:11080 \
  -v ./Config:/opt/ibm-datasrvrmgr/Config \
  -v ./logs:/opt/ibm-datasrvrmgr/logs \
  ibm/dsm:v2.1.5
```

#### Check progress

After starting the container, you can run the command: `docker logs -f dsm` to check the logs file of the install. Please note: When you run docker run command for the first time, the Data Server Manager software gets installed. If you stop the container and start it again, it will start the Data Server Manager without having to go through the install of the program. We control this through the `/opt/start_dsm.sh` script.

### Stop Container

```
docker stop dsm
```

### Start Container
```
docker start dsm
```

#### Run Web UI

```
docker ps
```

You will notice that we are port forwarding 11080 to the Container. You can launch the browser and run http://localhost:11080 to open the WEB UI of the data server manager.

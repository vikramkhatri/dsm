FROM centos:7
ARG CONT_IMG_VER="latest"
MAINTAINER vikram@zinox.com
WORKDIR /opt
ADD software/2.1.5-IM-Data-Server-Manager-linux-x86_64-IF201803061555.tgz /opt
ADD software/ibm-datasrvrmgr-enterprise-license-activation-kit-linux-x86_64.tgz /opt/ibm-datasrvrmgr/
ADD start_dsm.sh /opt/
RUN yum -y update &&  yum -y install curl tar wget which && yum clean all && chmod +x /opt/start_dsm.sh
ENTRYPOINT [ "/opt/start_dsm.sh" ]

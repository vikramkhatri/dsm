FROM centos:7
ARG CONT_IMG_VER="latest"
MAINTAINER vikram@zinox.com
WORKDIR /opt
ADD ibm-datasrvrmgr /opt/ibm-datasrvrmgr/
ADD start_dsm.sh /opt/
RUN yum -y update &&  yum -y install curl tar wget which && yum clean all
RUN chmod +x /opt/start_dsm.sh
ENTRYPOINT [ "/opt/start_dsm.sh" ]

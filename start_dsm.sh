#!/bin/bash

set +x

DSMHOME=/opt/ibm-datasrvrmgr
FLAG="/var/log/firstboot.log"

if  [ ! -f $FLAG ] ; then
   WEB_PWD=$($DSMHOME/dsutil/bin/crypt.sh ${WEB_USER:=admin})

   echo ####################################################
   env
   echo ####################################################

   if [[ -z $REP_HOST || -z $REP_PORT || -z $REP_DBNAME || -z $REP_USER || -z $REP_PWD ]] ; then
     tee $DSMHOME/setup.conf <<-EOF
        product.license.accepted=y
        port=${HTTP_PORT:=11080}
        https.port=${HTTPS_PORT:=11081}
        status.port=${STATUS_PORT:=11082}
        admin.user=${WEB_USER:=admin}
        admin.password=${WEB_PWD}
EOF
   else
      REP_PWD=$($DSMHOME/dsutil/bin/crypt.sh ${REP_USER:=admin})
      tee $DSMHOME/setup.conf <<-EOF
         product.license.accepted=y
         port=${HTTP_PORT:=11080}
         https.port=${HTTPS_PORT:=11081}
         status.port=${STATUS_PORT:=11082}
         admin.user=${WEB_USER:=admin}
         admin.password=${WEB_PWD}
         repositoryDB.dataServerType=DB2LUW
         repositoryDB.host=${REP_HOST:=localhost}
         repositoryDB.port=${REP_PORT:=50000}
         repositoryDB.databaseName=${REP_DBNAME:=DSMDB}
         repositoryDB.user=${REP_USER:=dsm}
         repositoryDB.password=${REP_PWD}
EOF
   fi

   sed -i "s/^[ \t]*//" $DSMHOME/setup.conf

   echo ####################################################
   echo Install Data Server Manager in the container
   echo ####################################################
   cd $DSMHOME
   ./setup.sh -silent
   touch $FLAG
else
   echo ####################################################
   echo Starting Data Server Manager
   echo ####################################################
   cd $DSMHOME/bin
   ./start.sh
fi

## Run forever so that container does not stop
tail -f /dev/null

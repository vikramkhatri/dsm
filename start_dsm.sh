#!/bin/bash

set +x

echo "Starting DSM health API"
/usr/bin/dsm-api &

DSMHOME=/opt/ibm-datasrvrmgr
FLAG=/var/log/firstboot.log
rm -f /var/log/healthiness
rm -f /var/log/liveliness

if  [ ! -f $FLAG ] ; then
   WEB_PWD=$($DSMHOME/dsutil/bin/crypt.sh ${WEB_PWD:=password})

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
      REP_PWD=$($DSMHOME/dsutil/bin/crypt.sh ${REP_PWD:=password})
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
   echo ####################################################
   echo Add cookie.secureOnly=false for http access
   echo ####################################################
   if ! grep -qs cookie.secureOnly $DSMHOME/Config/dswebserver.properties ; then
      echo "cookie.secureOnly=false" >> $DSMHOME/Config/dswebserver.properties
   fi
   touch $FLAG
else
   echo ####################################################
   echo Starting Data Server Manager
   echo ####################################################
   cd $DSMHOME/bin
   ./start.sh
fi

touch /var/log/healthiness
touch /var/log/liveliness

echo "--done--"

## Run forever so that container does not stop
tail -f /dev/null

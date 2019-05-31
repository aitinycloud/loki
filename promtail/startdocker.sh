#!/usr/bin/env bash
#

BINPATH=$(cd `dirname $0`; pwd)
PROJECTPATH=$(cd $BINPATH/; pwd)
INSTALLPATH=/usr/local/lokisystem
#mkfifo for docker log
# please add docker name in list.
APPNAMELIST=("tm-ni" "openresty")

cd $PROJECTPATH
echo "start install docker and docker-compose."
# install docker.
docker -v >> /dev/null 2>&1
if [ $? -eq  0 ]; then
  echo ""
else
  echo "please wait install docker."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
fi
# install docker-compose.
docker-compose --version >> /dev/null 2>&1
if [ $? -eq  0 ]; then
  echo ""
else
  echo "please wait install docker-compose."
  #curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  cp -rf $PROJECTPATH/../binmaster/grafana/bin/docker-compose /usr/local/bin/
  chmod +x /usr/local/bin/docker-compose
fi

echo "docker and docker-compose info : "
docker --version
docker-compose --version
cd $PROJECTPATH
if [ ! -d $INSTALLPATH ];then
    mkdir -p $INSTALLPATH
    mkdir -p $INSTALLPATH/config
    mkdir -p $INSTALLPATH/data
	cp -Rf $PROJECTPATH/config/promtail $INSTALLPATH/config/promtail
	cp -Rf $PROJECTPATH/data/promtail $INSTALLPATH/data/promtail
	rm -rf $INSTALLPATH/log && mkdir $INSTALLPATH/log
fi

#docker log
for APPNAME in ${APPNAMELIST[@]}
do
    rm -rf $INSTALLPATH/log/$APPNAME.log
    docker logs -f $APPNAME >> $INSTALLPATH/log/$APPNAME.log &
done

docker-compose up -d &
sleep 1
echo "success ."

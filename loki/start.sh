#!/usr/bin/env bash
#

BINPATH=$(cd `dirname $0`; pwd)
PROJECTPATH=$(cd $BINPATH/; pwd)
INSTALLPATH=/usr/local/lokisystem

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
  curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi

echo "docker and docker-compose info : "
docker --version
docker-compose --version
cd $PROJECTPATH
if [ ! -d $INSTALLPATH ];then
    echo "INSTALLPATH is not exist. mkdir create."
    mkdir -p $INSTALLPATH
    mkdir -p $INSTALLPATH/config
    mkdir -p $INSTALLPATH/data
fi
if [ ! -d $INSTALLPATH/config/grafana ];then
        cp -rf $PROJECTPATH/config/grafana $INSTALLPATH/config/grafana
        cp -rf $PROJECTPATH/config/loki $INSTALLPATH/config/loki
        cp -rf $PROJECTPATH/data/grafana $INSTALLPATH/data/grafana
        cp -rf $PROJECTPATH/data/loki $INSTALLPATH/data/loki
else
	rm -rf $INSTALLPATH/config/grafana $INSTALLPATH/config/loki $INSTALLPATH/data/grafana $INSTALLPATH/data/loki
	cp -rf $PROJECTPATH/config/grafana $INSTALLPATH/config/grafana
	cp -rf $PROJECTPATH/config/loki $INSTALLPATH/config/loki
	cp -rf $PROJECTPATH/data/grafana $INSTALLPATH/data/grafana
	cp -rf $PROJECTPATH/data/loki $INSTALLPATH/data/loki
fi
# set firewall-cmd
#firewall-cmd -q --zone=public --add-port=3000/tcp --permanent
#firewall-cmd -q --zone=public --add-port=3100/tcp --permanent
#firewall-cmd -q --reload
#sleep 3
docker-compose up -d

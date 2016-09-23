#!/bin/bash

source "/vagrant/scripts/common.sh"

function installLocalCassandra {
	echo "install Confluent from local file"
	FILE=/vagrant/resources/$CASSANDRA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}
function installRemoteCassandra {
	echo "install Confluent from remote file"
	curl -sS -o /vagrant/resources/$CASSANDRA_ARCHIVE -O -L $CASSANDRA_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$CASSANDRA_ARCHIVE -C /usr/local
}
function installCassandra {
	if resourceExists $CASSANDRA_ARCHIVE; then
		installLocalCassandra
		else
			installRemoteCassandra
			fi
	ln -s /usr/local/$CASSANDRA_VERSION-bin /usr/local/cassandra
	mkdir -p /usr/local/cassandra/logs
}

function startServices {
	echo "starting cassandra service"
	/usr/local/cassandra/bin/cassandra -R &
}

echo "setup cassandra"
installCassandra
startServices
echo "cassandra install complete"
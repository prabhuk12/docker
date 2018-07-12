# Main Docker File for All the SEMOSS pieces

# Start from the loaded R-Base-with-java
# Using R 3.5

FROM docker.io/semoss/semoss-r35-alpha1

LABEL maintainer="semoss@semoss.org"

# need to add semoss scripts to the $PATH

# Install tomcat on this
# Download Tomcat
# Unzip Tomcat
# Synchronize R, properties, solr, test db eventually
# pull the latest devel into web apps
# Unzip the development environment
# unzip the properties etc. 

# Commands
# update-semoss - semoss update - updates all of the code - i.e. downloads only semoss.jar, monolith.war 
# update-props - properties update
# pull-db all - goes into every db folder and runs a git pull 
# pull-db <dbname> - updates the specific db 
# delete-db <dbname> - deletes
# create-user-db <user repository> - will run through each of the repository, ask the user and then create the db 
# push-db all - push-db.sh
# push-db <dbname> - done

# read from a file
# source <filename>
# echo $MYVARIABLE

ENV LD_LIBRARY_PATH=/usr/lib:/usr/local/lib/R/site-library/rJava/jri
ENV R_HOME=/usr/lib/R
ENV SEMOSS_VERSION=0.0.3
ENV PATH=$PATH:/opt/apache-maven-3.5.3/bin:/opt/semosshome/semoss-artifacts/artifacts/scripts

RUN wget -P /opt https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz \
	&& cd /opt && tar -xvf /opt/apache-tomcat-8.0.41.tar.gz \
	&& mkdir /opt/apache-tomcat-8.0.41/webapps/SemossWeb \
	&& mkdir /opt/apache-tomcat-8.0.41/webapps/Monolith \
	&& wget -P /opt http://apache.claz.org/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
	&& cd /opt && tar -xvf apache-maven-3.5.3-bin.tar.gz \
	&& export PATH=$PATH:/opt/apache-maven-3.5.3/bin \
	&& mkdir /opt/semosshome \
	&& cd /opt/semosshome \
	&& apt install curl \
	&& git clone https://github.com/SEMOSS/semoss-artifacts \
	&& chmod 777 /opt/semosshome/semoss-artifacts/artifacts/scripts/* \
	&& /opt/semosshome/semoss-artifacts/artifacts/scripts/update_latest_dev.sh \
	&& mkdir /opt/semosshome/tmp \
	&& chmod 777 /opt/apache-tomcat-8.0.41/bin/*.sh
	#&& apt install nginx
 
WORKDIR /opt/apache-tomcat-8.0.41/bin

CMD ["catalina.sh", "run"]








# Main Docker File for All the SEMOSS Pieces

# Start from the loaded R-Base-with-java
# Using R 3.5

FROM docker.io/semoss/semoss-r35-alpha1

LABEL maintainer="semoss@semoss.org"

ENV LD_LIBRARY_PATH=/usr/lib:/usr/local/lib/R/site-library/rJava/jri
ENV R_HOME=/usr/lib/R
ENV PATH=$PATH:/opt/apache-maven-3.5.3/bin:/opt/semoss-artifacts/artifacts/scripts
#ENV SEMOSS_VERSION=3.3.1

# Install Apache Tomcat
RUN wget -P /opt https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz \
	&& cd /opt && tar -xvf /opt/apache-tomcat-8.0.41.tar.gz \
	&& chmod 777 /opt/apache-tomcat-8.0.41/bin/*.sh \
	
	# Install Apache Maven
	&& wget -P /opt https://apache.claz.org/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
	&& cd /opt && tar -xvf apache-maven-3.5.3-bin.tar.gz \
	&& export PATH=$PATH:/opt/apache-maven-3.5.3/bin \
	
	# Clone semoss-artifacts scripts
	&& git config --global http.sslverify false \
	&& cd /opt && git clone https://github.com/SEMOSS/semoss-artifacts \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/* \
	
	# Create semosshome (can be overridden by user later via a shared drive)
	&& mkdir /opt/semosshome \

	# Install curl (needed for update scripts)
	&& apt install -y curl \
	
	# Update latest dev code
	&& /opt/semoss-artifacts/artifacts/scripts/update_latest_dev.sh \
	
	# Install nginx
	&& apt install -y nginx \
	
	# Install mc
	&& wget -P /opt/semoss-artifacts/artifacts/scripts https://dl.minio.io/client/mc/release/linux-amd64/mc \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/mc \
	
	# Install minio
	&& wget -P /opt/semoss-artifacts/artifacts/scripts https://dl.minio.io/server/minio/release/linux-amd64/minio \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/minio

WORKDIR /opt/semoss-artifacts/artifacts/scripts

CMD ["catalina.sh", "run"]

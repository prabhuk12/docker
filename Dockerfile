# Main Docker File for All the SEMOSS Pieces

# Start from the loaded R-Base-with-java
# Using R 3.5

FROM docker.io/semoss/semoss-r35-alpha1

LABEL maintainer="semoss@semoss.org"

ENV LD_LIBRARY_PATH=/usr/lib:/usr/local/lib/R/site-library/rJava/jri
ENV R_HOME=/usr/lib/R
ENV PATH=$PATH:/opt/apache-maven-3.5.4/bin:/opt/semoss-artifacts/artifacts/scripts:/opt/apache-tomcat-8.0.41/bin
#ENV SEMOSS_VERSION=3.3.1

# Install Apache Tomcat
# Install Apache Maven
# Clone semoss-artifacts scripts
# Create semosshome (can be overridden by user later via a shared drive)
# Install curl (needed for update scripts)
# Update latest dev code
# Install nginx
# Install mc
# Install minio
RUN wget -P /opt https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz \
	&& cd /opt && tar -xvf /opt/apache-tomcat-8.0.41.tar.gz && rm /opt/apache-tomcat-8.0.41.tar.gz \
	&& chmod 777 /opt/apache-tomcat-8.0.41/bin/*.sh \
	&& wget -P /opt https://apache.claz.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz \
	&& cd /opt && tar -xvf /opt/apache-maven-3.5.4-bin.tar.gz && rm /opt/apache-maven-3.5.4-bin.tar.gz \
	&& git config --global http.sslverify false \
	&& cd /opt && git clone https://github.com/SEMOSS/semoss-artifacts \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/* \
	&& mkdir /opt/semosshome \
	&& apt-get -y --allow-releaseinfo-change update \
	&& apt-get -y update \
	&& apt install -y curl \
	&& /opt/semoss-artifacts/artifacts/scripts/update_latest_dev.sh \
	&& apt install -y nginx \
	&& wget -P /opt/semoss-artifacts/artifacts/scripts https://dl.minio.io/client/mc/release/linux-amd64/mc \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/mc \
	&& wget -P /opt/semoss-artifacts/artifacts/scripts https://dl.minio.io/server/minio/release/linux-amd64/minio \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/minio \
	&& apt install -y nano \
	&& apt install -y fuse \
	&& curl https://rclone.org/install.sh | bash \
	&& wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get -y update \
	&& apt install -y google-chrome-stable \
	&& chmod 777 /opt/semosshome/config/Chromedriver/* 

WORKDIR /opt/semoss-artifacts/artifacts/scripts

CMD ["run.sh", "run"]

FROM centos:latest
MAINTAINER devneko<dotneet@gmail.com>

RUN yum install -y wget tar unzip net-tools ruby java-1.7.0-openjdk 

RUN wget http://getdrill.org/drill/download/apache-drill-0.8.0.tar.gz && \
      tar zxf apache-drill-0.8.0.tar.gz && \
      mv apache-drill-0.8.0 /opt/drill && \
      rm apache-drill-0.8.0.tar.gz

WORKDIR /opt/drill

RUN wget http://bitbucket.org/jmurty/jets3t/downloads/jets3t-0.9.3.zip && \
    unzip jets3t-0.9.3.zip && \
    cp jets3t-0.9.3/jars/jets3t-0.9.3.jar jars/3rdparty/ && \
    cat bin/hadoop-excludes.txt | awk '/jets3t/{$0 = "";} /./' > tmp && mv tmp bin/hadoop-excludes.txt && \
    rm -rf jets3t-0.9.3 && \
    rm jets3t-0.9.3.zip 

# Install Cloudera Repository for zookeeper-server
RUN wget http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
RUN yum -y --nogpgcheck localinstall cloudera-cdh-5-0.x86_64.rpm

RUN yum -y install zookeeper-server && /etc/init.d/zookeeper-server init

ADD core-site.xml.erb ./
ADD bootstrap.sh ./

EXPOSE 8047 2181

CMD ["./bootstrap.sh"] 


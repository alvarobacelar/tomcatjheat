FROM tomcat:8.0.35-jre8

ENV XMX=6000 \
    XMS=1024 \
    MAXPERM=2000 \
    PORT_JMX=9404

ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.15.0/jmx_prometheus_javaagent-0.15.0.jar /home/jmx_prometheus_javaagent-0.15.0.jar
ADD https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/tomcat.yml /home/tomcat.yaml   

ENV CATALINA_OPTS="-Xms${XMS}M -Xmx${XMX}M -XX:MaxPermSize=${MAXPERM}m -server -XX:+UseParallelGC -Djava.awt.headless=true -Duser.timezone=America/Fortaleza -Duser.language=pt -Duser.region=BR -javaagent:/home/jmx_prometheus_javaagent-0.15.0.jar=${PORT_JMX}:/home/tomcat.yaml"

ADD . /home

RUN mv /home/web.xml /usr/local/tomcat/conf/web.xml
RUN mv /home/server.xml /usr/local/tomcat/conf/server.xml
RUN mv /home/catalina.properties /usr/local/tomcat/conf/catalina.properties
RUN cp /usr/share/zoneinfo/America/Fortaleza /etc/timezone
RUN mv /home/localtime /etc/localtime

VOLUME ["/usr/local/tomcat/logs"]

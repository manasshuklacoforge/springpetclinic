FROM adoptopenjdk/openjdk11:jre-11.0.18_10
ADD /target/spring-petclinic-2.7.3.jar /home
RUN apt-get update && apt-get install -y \
    unzip \
    rsync
ADD /target/spring-petclinic-2.7.3.jar /home
RUN true
ADD https://staticdownloads.site24x7.com/apminsight/agents/apminsight-javaagent.zip /tmp
RUN true 
RUN mkdir -p /tmp/apm
RUN unzip /tmp/apminsight-javaagent.zip -d /tmp/apm
RUN sed -i 's/license.key=/license.key=SITE24x7_APM_KEY/g' /tmp/apm/apminsight.conf
RUN sed -i 's/application.name=My Application/application.name=springbootpetclinic/g' /tmp/apm/apminsight.conf
RUN mkdir -p /home/apm
RUN mv /tmp/apm /home 
WORKDIR /home
RUN pwd 
RUN ls /home/apm
RUN cat /home/apm/apminsight.conf
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=mysql
ENTRYPOINT ["java", \
            "-javaagent:/home/apm/apminsight-javaagent.jar", \
            "-jar", "/home/spring-petclinic-2.7.3.jar"]
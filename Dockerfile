FROM openjdk:11-jdk-bullseye
ENV JAVA_OPTS -Xmx2G
RUN apt-get -y update && apt-get -y dist-upgrade && apt-get -qq -y install unzip wget \
 && wget -q https://services.gradle.org/distributions/gradle-6.5.1-bin.zip  \
 && unzip -d /usr/local/ gradle-6.5.1-bin.zip 
ARG REPOS_FRAMEWORK_URL="https://gitbox.apache.org/repos/asf/ofbiz-framework.git"
ARG REPOS_PLUGIN_URL="https://gitbox.apache.org/repos/asf/ofbiz-plugins.git"
RUN git clone $REPOS_FRAMEWORK_URL ofbiz-framework \
 && git clone $REPOS_PLUGIN_URL plugins \
 && ls -la ./ofbiz-framework/
#RUN ln -s ./plugins ./ofbiz-framework/plugins 

WORKDIR /ofbiz-framework
#ENV DB_HOST="db"

RUN wget -q https://jdbc.postgresql.org/download/postgresql-42.4.1.jar -O ./lib/postgresql-42.4.1.jar \
 && sed -i 's/datasource-name="localderby"/datasource-name="localpostgres"/g; s#jdbc:postgresql://127.0.0.1/ofbiz#jdbc:postgresql://db/ofbiz#g' ./framework/entity/config/entityengine.xml \
 && ./gradlew cleanAll loadAll 

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT [ "/ofbiz-framework/gradlew"]
CMD ["ofbiz --start"]

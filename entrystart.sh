#!/bin/bash
#ENV DB_PLATTFORM="D"
#ENV JDBC_LIB_FILE="postgresql-42.4.1.jar"
#ENV DB_HOST="127.0.0.1"
#ENV DB_NAME="ofbiz"
#ENV DB_USER="ofbiz"
#ENV DB_PASSWORD="ofbiz"
#ENV DOMAINLIST="localhost,127.0.0.1"

# https://cwiki.apache.org/confluence/display/OFBIZ/Apache+OFBiz+Technical+Production+Setup+Guide#ApacheOFBizTechnicalProductionSetupGuide-DatabaseSetup
if [ $DB_PLATTFORM = "P" ] 
then
	wget -q https://jdbc.postgresql.org/download/$JDBC_LIB_FILE -O ./lib/$JDBC_LIB_FILE\
	&& sed -i 's|<group-map group-name="org.apache.ofbiz" datasource-name="localderby"/>|<group-map group-name="org.apache.ofbiz" datasource-name="localpostgres"/>|g' ./framework/entity/config/entityengine.xml \
 	&& sed -i 's|<group-map group-name="org.apache.ofbiz.olap" datasource-name="localderbyolap"/>|<group-map group-name="org.apache.ofbiz.olap" datasource-name="localpostgresolap"/>|g' ./framework/entity/config/entityengine.xml \
 	&& sed -i 's|<group-map group-name="org.apache.ofbiz.tenant" datasource-name="localderbytenant"/>|<group-map group-name="org.apache.ofbiz.tenant" datasource-name="localpostgrestenant"/>|g' ./framework/entity/config/entityengine.xml
	sed -i 's#jdbc:postgresql://127.0.0.1/ofbiz#jdbc:ostgresql://'"$DB_HOST"'/'"$DB_NAME"'#g' ./framework/entity/config/entityengine.xml 
fi

sed -i 's/jdbc-username=\"ofbiz\"/jdbc-username=\"'"$DB_USER"'\"/g' ./framework/entity/config/entityengine.xml \
&& sed -i 's/jdbc-password=\"ofbiz\"/jdbc-password=\"'"$DB_PASSWORD"'\"/g' ./framework/entity/config/entityengine.xml 
sed -i 's/host-headers-allowed=.*/host-headers-allowed='"$DOMAINLIST"'/g' ./framework/security/config/security.properties
/ofbiz-framework/gradlew "ofbizBackground --start" \
 && /ofbiz-framework/gradlew "ofbiz --load-data readers=seed,demo,ext" \
 && /ofbiz-framework/gradlew "ofbiz --shutdown" \
 && /ofbiz-framework/gradlew "ofbiz --start"

FROM docker.io/alfresco/alfresco-content-repository-community:23.4.1

ARG TOMCAT_DIR=/usr/local/tomcat
ARG IMAGEUSERNAME=alfresco

USER root

# Install modules and addons
RUN mkdir -p $TOMCAT_DIR/amps
COPY modules/amps $TOMCAT_DIR/amps
COPY modules/jars $TOMCAT_DIR/webapps/alfresco/WEB-INF/lib

RUN java -jar $TOMCAT_DIR/alfresco-mmt/alfresco-mmt*.jar install \
    $TOMCAT_DIR/amps $TOMCAT_DIR/webapps/alfresco -directory -nobackup -force

### Controlador BBDD ###
#COPY lib $TOMCAT_DIR/lib

RUN sed -i "s|<Context>|<Context>\n<Resources cacheMaxSize=\"51200\"/> |g" $TOMCAT_DIR/conf/context.xml

# 1. Instalar dependencias y configurar el repositorio de Docker
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    dnf install -y docker-ce docker-ce-cli containerd.io && \
    dnf clean all

# 2. Crear grupo "docker" con el mismo GID que en el host (ej: 999)
# NOTA: Reemplaza "999" con el GID de tu grupo "docker" en el host (ver: `ls -n /var/run/docker.sock`)
#RUN groupadd -g 999 docker

# 3. Añadir usuario "alfresco" al grupo "docker"
RUN usermod -aG docker alfresco
RUN groupadd -g 1001 monitor
RUN usermod -aG monitor alfresco

USER alfresco
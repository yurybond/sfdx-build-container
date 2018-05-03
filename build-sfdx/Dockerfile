# Set the base image
FROM golang:latest
# Dockerfile author / maintainer 
MAINTAINER Yury Bondarau <ybondarau@atlasprofessionals.com> 

# Install utilities required for Force.com CLI and Salesforce CLI. 
RUN apt-get update \
  && apt-get install -y wget \
  && apt-get install xz-utils \
  && apt-get install -y git

# Install Force.com CLI. 
#RUN wget http://force-cli.herokuapp.com/releases/v0.22.84/linux-amd64/force -O /usr/local/bin/force \
#	&& chmod +x /usr/local/bin/force
RUN go get -u github.com/ForceCLI/force \
  && cp $GOPATH/bin/force /usr/local/bin/ \
  && chmod +x /usr/local/bin/force

# Install Salesforce DX CLI. 
RUN wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz -O sfdx-linux-amd64.tar.xz -q\
  && mkdir sfdx \ 
	&& tar -xJf sfdx-linux-amd64.tar.xz -C sfdx --strip=1 \
  && rm -rf sfdx-linux-amd64.tar.xz \
	&& cd sfdx \
  && ls -la \
	&& ./install \
	&& sfdx update \
	&& cd ~
# Create a bash script to 
COPY deploy-delta.sh /usr/local/bin/deploy-delta.sh
RUN chmod +x /usr/local/bin/deploy-delta.sh

# Expose default port
#EXPOSE 6379

# Set the default command
#ENTRYPOINT ["force apiversion"]
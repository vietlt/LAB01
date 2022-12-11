# Use an official HashiCorp Terraform runtime as a base image.
FROM ubuntu:alpine as builder
WORKDIR /infra
COPY . .

RUN \
# Update
apt-get update -y && \
# Install Unzip
apt-get install unzip -y && \
# need wget
apt-get install wget -y && \
# vim
apt-get install vim -y

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip

# Unzip
RUN unzip terraform_1.3.6_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Check that it's installed
RUN terraform --version 

RUN apt-get install -y python3-pip
#RUN ln -s /usr/bin/python3 python
RUN pip3 install --upgrade pip
RUN python3 -V
RUN pip --version

RUN pip3 install pywinrm && \
    pip3 install ansible

RUN apt-get install openssh-server -y
# RUN systemctl enable ssh
# RUN systemctl start ssh
# RUN ansible --version

# Use the base image to create a packaged image. 
FROM builder AS package
#To add to the working directory.
WORKDIR /root/.aws
# To copy the AWS credentials to root folder.
COPY ./Key/aws/config /root/.aws
COPY ./Key/aws/credentials /root/.aws



# Use the packaged image to create a final image.
FROM package AS final
#To add to the working directory.
WORKDIR /infra
# To Run Terraform init and initialize.
# ENTRYPOINT [ "terraform", "init" ]
RUN terraform init
#RUN command inside the container.
CMD ["terraform", "apply", "-auto-approve"]
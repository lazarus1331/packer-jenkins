#!/bin/bash -x

# Install pre-reqs
apt-get update
apt-get install -y openjdk-7-jre git python python-dev python-pip python-virtualenv

# Install jenkins
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y jenkins

# Install nginx 
apt-get install -y nginx
cd /etc/nginx/sites-available
if [[ -e default ]];then rm default ../sites-enabled/default;fi

# config nginx and restart 
cp /tmp/nginx-jenkins.conf /etc/nginx/sites-available/jenkins
ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/ || true
service nginx restart
systemctl status nginx 

# extract and move jenkins plugins
mkdir /tmp/plugins
tar -xzf /tmp/jenkinsplugins.tar.gz /tmp/plugins/
cp -R /tmp/plugins/* /var/lib/jenkins/plugins/
chown -R jenkins. /var/lib/jenkins

# restart jenkins to install plugins
service jenkins restart
systemctl status jenkins

# install latest ansible via pip
pip install ansible


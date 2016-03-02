# Apache

From http://httpd.apache.org/:

> The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT.

### Installation
```bash
sudo apt-get install apache2 apache2-threaded-dev
```

## mod-passenger

Refs:
https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-passenger-and-apache-on-ubuntu-14-04
https://www.phusionpassenger.com/library/install/apache/install/oss/trusty/

### Installation

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo tee -a /etc/apt/sources.list.d/passenger.list > /dev/null <<'EOF'
deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main
EOF
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update
sudo apt-get install -y libapache2-mod-passenger && sudo a2enmod passenger && sudo apache2ctl restart
```

Validate installation:
```bash
sudo passenger-config validate-install
```
and:
```bash
sudo passenger-memory-stats
```

#create docker image
docker build -t friendlyhello .

#list docker images
docker image ls

#Run docker imahe
docker run -p 4000:80 friendlyhello

#Open browser window and open link
http://localhost:4000




ANY PROBLEM ???
===============
Troubleshooting for Linux users
================================
Proxy server settings

Proxy servers can block connections to your web app once it’s up and running. If you are behind a proxy server, add the following lines to your Dockerfile, using the ENV command to specify the host and port for your proxy servers:

# Set proxy server, replace host:port with values for your servers
ENV http_proxy host:port
ENV https_proxy host:port
DNS settings

DNS misconfigurations can generate problems with pip. You need to set your own DNS server address to make pip work properly. You might want to change the DNS settings of the Docker daemon. You can edit (or create) the configuration file at /etc/docker/daemon.json with the dns key, as following:

{
  "dns": ["your_dns_address", "8.8.8.8"]
}
In the example above, the first element of the list is the address of your DNS server. The second item is the Google’s DNS which can be used when the first one is not available.

Before proceeding, save daemon.json and restart the docker service.

sudo service docker restart

Once fixed, retry to run the build command.

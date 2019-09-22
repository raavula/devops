#.dockerignore - This will prevent your local modules and debug logs from being copied onto your Docker image and possibly overwriting modules installed within your image.

docker build -t raavula/node-web-app .
docker run -p 49160:8080 -d raavula/node-web-app
docker ps
docker logs <container id>
docker exec -it <container id> /bin/bash
curl -i localhost:49160

Docker
Docker Images and Containers
# Lists images stored in the docker daemon's data root, by default /var/lib/docker.
$ docker image ls

# List all containers
$ docker ps -a

# List running containers including CPU/memory size
$ docker ps -s

# Specify format
$ docker ps -a --format "{{.ID}},{{.Names}},{{.Status}},{{.Image}},{{.Ports}}"

# Go inside the container; `-i` for `interactive, `t` for `terminal.
$ docker exec -it <container> bash

# Execute
$ docker exec -i ... # interactive mode
$ docker exec -d ... # detached mode

# Start a Ubuntu 20.04
$ docker run -it --entrypoint "/bin/bash" ubuntu:20.04

# Export a container’s filesystem as a tar archive
$ docker export --output="latest.tar" <container>

# port forwarding
$ docker run -p 8080:8080 myserver

# kill all containers
$ docker kill $(docker ps -q)

# Remove all containers in exited status
$ docker rm $(docker ps -a -f status=exited -q)

# Check port mapping
$ docker port CONTAINER_NAME
6443/tcp -> 127.0.0.1:34305

# Remove unused data (images, containters, networks, build cache, etc)
$ docker system prune
Docker Info and Daemon
Docker daemon communicates with the Linux kernel in order to create containers. docker CLI -> dockerd -> kernel.

# Run Docker daemon in the foreground
$ dockerd

# Run Docker daemon as a systemd service
$ sudo systemctl start docker

# Check if dockerd is running
$ sudo systemctl status docker

# Check docker status
$ curl -s --unix-socket /var/run/docker.sock http/_ping
OK%

# Check docker info (these 2 are the same)
$ docker info
$ docker system info

# Display the SBOM (Software Bill Of Materials) of any Docker image. This feature outputs the SBOM in a table or can be exported into SPDX and CycloneDX formats.
$ docker sbom

# Check disk usage
$ docker system df
$ docker system df -v  # v for verbose
Docker Registries
# Create a local registry
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2

# 5000 is used inside the container (hardcoded in Dockerfile);
# if 5000 is already used on local machine, change it to another port like 5001
$ docker run -d -p 5001:5000 --restart=always --name registry registry:2

# Check if registry is running
$ docker ps

# If needs login
$ docker login $REGISTRY

# Pull from docker.io/library/ubuntu:latest
$ docker pull ubuntu

# Tag and Push to local registry
$ docker tag ubuntu:22.04 $REGISTRY/demo/ubuntu:22.04
$ docker push $REGISTRY/demo/ubuntu:22.04

# Pull from local registry
$ docker pull $REGISTRY/library/ubuntu:22.04
Check registry:

$ curl -X GET http://myregistry:5000/v2/_catalog
{"repositories":["myimage"]}

$ curl -X GET http://myregistry:5000/v2/mymage/tags/list
{"name":"myimage","tags":["latest"]}

# with user and password
$ curl -X GET -u <user>:<pass> https://myregistry:5000/v2/_catalog

# with cert
$ curl --cacert domain.crt https://myregistry:5000/v2/_catalog
Docker image name = repository + ":" + tag

Source Code
The Git repo of the official Docker image for distribution. https://github.com/docker/distribution-library-image/tree/master

https://github.com/distribution/distribution

Download and run registry locally:

wget https://github.com/distribution/distribution/releases/download/v2.8.2/registry_2.8.2_linux_amd64.tar.gz

tar xvzf registry_2.8.2_linux_amd64.tar.gz

./registry --version
./registry github.com/docker/distribution 2.8.2
Notice github.com/docker/distribution instead of github.com/distribution/distribution

Registry Mirror
Docker registry mirror: add registry-mirrors to the /etc/docker/daemon.json configuration file.

{
  ...
  "registry-mirrors": ["https://mirror.gcr.io"]
}
Now docker pull will pull from the https://mirror.gcr.io instead of docker.io.

Side note: containerd registry mirror can be configured in /etc/containerd/config.toml

The official image: registry:2

Docker hub: https://hub.docker.com/_/registry
Source code: https://github.com/docker/distribution-library-image
Docker Networking
# List networks
$ docker network ls

# Create network
$ docker network create

# Remove network
$ docker network rm

# Connect container to network
$ docker network connect NETWORK_NAME CONTAINER_NAME

# Verify the `CONTAINER_NAME` is added to the `Containers` field of the network:
$ docker inspect NETWORK_NAME --type network
Check by docker network ls

Name	Driver	Note
bridge	bridge	Docker's default
kind	bridge	kind's default
host	host	no network isolation
none	null	
DRIVER:

null: the container does not have external network interfaces, only a local loopback interface.
host: the container is attached to the host's network, the configs inside the container matches the configs outside the container.
bridge: containers connected to the same bridge network can communicate; containers on different bridge networks cannot communicate directly with each other.
To get more details:

$ docker network inspect bridge
Containers Networking Options
container to container on the same node (the same Docker daemon host): through a bridge network
container to container on different nodes: through a overlay network
container to outside world: --publish or -p <hostport>:<containerport>
DNS
Inherit /etc/resolv.conf on the host, but can override per-container in docker run / docker create using the flags: --dns, --dns-search, --dns-opt, --hostname.

Isolation
On Linux, Docker manipulates iptables rules to provide network isolation.

credHelper
credHelpers can be set in ~/.docker/config.json

"credHelpers": {
    "gcr.io": "gcloud"
}
It means any image pull from gcr.io will use the binary docker-credential-gcloud to get the username and secret. (The binary = docker-credential- + suffix.)

$ echo gcr.io | docker-credential-gcloud get
To login:

$ docker login 10.200.0.1 -u admin -p ${REGISTRY_PASSWORD}
Configurations and Files
Docker Root Dir (used by the docker daemon to keep track of the state).

/var/lib/docker/, e.g.
/var/lib/docker/overlay2: image and container layers.
/var/lib/docker/volumes
Server ("Rootful"):

dockerd (daemon) config: /etc/docker/daemon.json
Socket: /var/run/docker.sock
Server (Rootless Mode):

dockerd (daemon) config: ~/.config/docker
Socket: $XDG_RUNTIME_DIR/docker.sock
$XDG_RUNTIME_DIR is typically set to /run/user/$UID
Data dir: ~/.local/share/docker by default
Client:

~/.docker/config.json is for the docker CLI.
Registry:

config: /etc/registry/config.yaml
storage: /var/lib/registry
Build
docker can build a docker image or an OCI image:

docker buildx build --output type=oci .
docker buildx build --output type=docker .
docker build vs docker buildx build
2 Docker build commands:

docker build: the legacy builder; always takes a copy of the local filesystem.
docker buildx build: Extended build capabilities with BuildKit.
BuildKit has been integrated to docker build since Docker 18.09.
BuildKit only requests the resources that the build needs, when they're needed.
A drop-in replacement for the legacy build.
In newer versions of Docker Desktop and Docker Engine, you're using Buildx by default when you invoke the docker build command.
BuildKit, or buildkitd, is the daemon process that executes the build workloads. A build execution starts with the invocation of a docker build command. Buildx interprets your build command and sends a build request to the BuildKit backend.

# List builder (will show BUILDKIT version)
$ docker buildx ls

# Inspect builder
$ docker buildx inspect $BUILD_NAME
$ docker buildx inspect default
FAQ
What is Docker?
When we talk about Docker, usually we are referring to Docker Engine, which consists of

the Docker daemon (dockerd).
a REST API that specifies interfaces for interacting with the daemon.
a command line interface (CLI) client (docker) that talks to the daemon (through the REST API wrapper), e.g. docker run <image>, docker image ls.
Because Docker operates at the OS level, it can still be run inside a VM.

2 most important APIs: Images and Container APIs.

What's the virtual size?
virtual = image size + container layers size.

What is a dangling image?
"dangling images" refers to images that no longer have tags or are associated with any active containers.

Docker Compose vs Docker Stack vs Swarm
docker compose: a tool for defining and running multi-container Docker applications; v1 (the separate binary docker-compose was deprecated), v2 is a subcommand compose in the docker CLI.
docker stack: Manage Swarm stacks.
both works with docker-compose.yml, however docker stack only works with version 3.
Swarm: a cluster of Docker daemons. Now swarm is also a subcommand of docker CLI. Compose: multiple containers on the same host (daemon).
import vs load
import is used with the tarball which are created with docker export.
load is used with the tarball which are created with docker save.
Docker for Mac
The Docker for Mac application does not use docker-machine to provision that VM; but rather creates and manages it directly.

Rootless Mode
Allows running the dockerd and containers as a non-root user to mitigate potential vulnerabilities in the daemon and the container runtime.

Rootless mode executes the Docker daemon and containers inside a user namespace.

Specify CLI context:

$ docker context use rootless
root vs rootless:

root: DOCKER_HOST defaults to unix:///var/run/docker.sock (allows only local connections by the root user).
rootless: export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock, e.g. unix:///run/user/123456/docker.sock
Storage
Storage Options
Storage Driver: for writing ephemeral data in container's writable layer, at a lower speed.
can also use tmpfs mount for ephemeral data to avoid writing into the container’s writable layer, which increases container's performance.
Volume: for write-intensive application, persistent data, shared data; better performance. The data is stored in Docker's storage directory (unlike bind mount below, which can be any absolute path on the host machine).
a volume doesn’t increase the size of the containers using it
Bind Mount: a file or directory on the host machine is mounted into a container. Similar to hostpath in k8s.
Overlay: lower vs upper vs merged
lower: Image layers, read-only.
upper: Container layers, read-write. Each running containers has a thin read-write layer. Do not persiste after the container is deleted.
merged: the union mount of the lower and upper. If a name exists in both, the object in 'upper' is visible while the object in 'lower' is hidden or merged.
Storage Driver
Storage Driver:

controls how images and containers are stored and managed on your Docker host.
allows you to write to the container’s writable layer.
Check which storage driver is being used:

$ docker info
...
Server:
 Containers: 24
 Images: 507
 Storage Driver: overlay2
  Backing Filesystem: extfs
...
Storage Driver - Overlay2
overlay2 is the preferred storage driver.

OverlayFS is a feature provided by Linux Kernel.

OverlayFS layers multiple directories on a single Linux host and presents them as a single directory.

Layers can be found in /var/lib/docker/overlay2

Each image and container layer has its own folder.
the special l directory contains shortened layer identifiers as symbolic links, to avoid hitting the page size limitation on arguments to the mount command. ls -l /var/lib/docker/overlay2/l
Check mounts: mount | grep overlay

Backing filesystem: ext4 or xfs.



Dockerfile
A Dockerfile is a text file that contains all the commands a user could call on the command line to assemble an image. It acts as a blueprint for building Docker images.

1. FROM
Purpose: Defines the base image for your new image. Every Dockerfile must start with FROM.
Syntax: FROM <image>[:<tag>]
Example:
Ubuntu: FROM ubuntu:22.04
Node LTS version: FROM node:lts-slim
Tip: Use a specific tag (e.g., 22.04) instead of latest for consistent builds.
2. LABEL
Purpose: Adds metadata to an image. This can include information like maintainer, version, or description.
Syntax: LABEL <key>=<value> [<key>=<value>...]
Example: LABEL maintainer="John Doe <john.doe@example.com>" version="1.0" description="My Awesome App"
Tip: Useful for documentation and organizing images.
3. RUN
Purpose: Executes commands in a new layer on top of the current image and commits the results. Used for installing packages, creating directories, etc.
Syntax:
RUN <command> (shell form, default: /bin/sh -c on Linux)
RUN ["executable", "param1", "param2"] (exec form, preferred for clarity and avoiding shell string processing)
Example (shell form): RUN apt-get update && apt-get install -y git build-essential
Example (exec form): RUN ["/bin/bash", "-c", "echo Hello && echo World"]
Tip: Chain multiple RUN commands with && and use \ for readability to reduce image layers.
4. WORKDIR
Purpose: Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow it.
Syntax: WORKDIR /path/to/workdir
Example:
WORKDIR /app
COPY . . # Copies content to /app in the image
Tip: Use WORKDIR to keep your Dockerfile clean and avoid absolute paths in subsequent commands.
5. COPY
Purpose: Copies new files or directories from the host machine (<src>) to the filesystem of the container at path <dest>.
Syntax: COPY <src>... <dest>
Example:
COPY ./src /app/src
COPY requirements.txt /app/
Tip: Preferred over ADD for copying local files as it's more transparent.
6. ADD
Purpose: Similar to COPY but has additional features:
Can extract tar files from <src> (local or remote URL).
Can accept a URL for <src>.
Syntax: ADD <src>... <dest>
Example (local tar): ADD app.tar.gz /app/
Example (remote URL): ADD http://example.com/latest.zip /app/
Tip: Use COPY unless you specifically need the tar extraction or URL download features of ADD.
7. EXPOSE
Purpose: Informs Docker that the container listens on the specified network ports at runtime. This is purely for documentation and doesn't actually publish the port.
Syntax: EXPOSE <port> [<port>...]
Example: EXPOSE 80 443
Tip: To actually publish ports, use the -p or --publish flag with docker run.
8. ENV
Purpose: Sets environment variables. These variables persist when a container is run and can be accessed by applications inside the container.
Syntax: ENV <key>=<value> [<key>=<value>...]
Example: ENV NODE_ENV=production PORT=3000
Tip: Can be overridden with docker run -e <key>=<value>.
9. ARG
Purpose: Defines a variable that users can pass at build-time to the builder using docker build --build-arg <varname>=<value>.
Syntax: ARG <name>[=<default value>]
Example:
ARG BUILD_VERSION=1.0
RUN echo "Building version: $BUILD_VERSION"
Tip: ARG variables are not available after the image is built, unlike ENV.
10. VOLUME
Purpose: Creates a mount point with the specified name and marks it as holding externally mounted volumes from the native host or other containers.
Syntax: VOLUME ["/data"] or VOLUME /data
Example: VOLUME /var/log/app
Tip: Use volumes to persist data generated by and used by Docker containers, especially for database files or logs.
11. USER
Purpose: Sets the user name or UID to use when running the image and for any RUN, CMD, and ENTRYPOINT instructions that follow it.
Syntax: USER <user>[:<group>]
Example: USER appuser
Tip: Running containers as a non-root user is a security best practice.
12. HEALTHCHECK
Purpose: Tells Docker how to test a container to check if it is still working.
Syntax: HEALTHCHECK [OPTIONS] CMD command
Example: HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost/ || exit 1
Tip: Essential for robust container orchestration (e.g., Kubernetes) to determine container readiness.
13. ENTRYPOINT
Purpose: Configures a container that will run as an executable. It defines the command that will always be executed when the container starts.
Syntax:
ENTRYPOINT ["executable", "param1", "param2"] (exec form, preferred)
ENTRYPOINT command param1 param2 (shell form)
Example (exec form): ENTRYPOINT ["/usr/bin/supervisord", "-n"]
Tip: Often used in conjunction with CMD to provide default arguments to the ENTRYPOINT.
14. CMD
Purpose: Provides defaults for an executing container. There can only be one CMD instruction in a Dockerfile.

Syntax:

CMD ["executable","param1","param2"] (exec form, as the main command)
CMD ["param1","param2"] (as default arguments to ENTRYPOINT)
CMD command param1 param2 (shell form)
Example (with ENTRYPOINT):

    ENTRYPOINT ["nginx"]
    CMD ["-g", "daemon off;"]
    # Default arguments for nginx
Example (without ENTRYPOINT): CMD ["python", "app.py"]

Tip: When ENTRYPOINT is defined, CMD provides the default arguments for it. If ENTRYPOINT is not defined, CMD provides the default command to execute. The docker run command line arguments will override CMD.

CMD vs ENTRYPOINT
Both CMD and ENTRYPOINT instructions define what command gets executed when running a container. There are few rules that describe their co-operation.

Dockerfile should specify at least one of CMD or ENTRYPOINT commands.
ENTRYPOINT should be defined when using the container as an executable.
CMD should be used as a way of defining default arguments for an ENTRYPOINT command or for executing an ad-hoc command in a container.
CMD will be overridden when running the container with alternative arguments.
Dockerfile Best Practices:
Order matters: Place instructions that change less frequently at the top to leverage Docker's build cache.
Minimize layers: Combine RUN commands where possible using && and \ for efficiency.
Remove unnecessary files: Clean up temporary files, caches (apt-get clean, rm -rf /var/lib/apt/lists/*) to keep image size small.
Use .dockerignore: Exclude files and directories not needed in the image (like .git, node_modules, *.log).
Run as non-root: Create a dedicated user and group for your application for security.
Specific tags: Always use specific version tags for base images instead of latest.
Example: Containerize a Node app
Use this Dockerfile template:

# node
FROM node:12-slim

# the path inside the container
WORKDIR /usr/src/app

# copy the package.json and package-lock.json, and install dependencies
COPY package*.json ./
RUN npm install

# copy all the source code
COPY . .

# port
EXPOSE 8080

# run the command inside the container
CMD [ "node", "app.js" ]
And add a .dockerignore file:

Dockerfile
.dockerignore
node_modules
npm-debug.log
What is || : &&
|| : && creates a conditional execution flow:

The command before || is executed.
If it succeeds, the || : part is skipped, and the command after && is executed.
If it fails, the || : part is executed (doing nothing), and then the command after && is executed regardless.
This pattern is often used to ensure that subsequent commands in a RUN instruction are always executed, even if a previous command fails. This is useful for tasks like cleaning up or setting up configurations that should happen regardless of earlier failures.

RUN apt-get update || : && apt-get install -y --no-install-recommends some-package
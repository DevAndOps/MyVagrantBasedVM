export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y install curl
curl -sSL https://get.docker.com/ | sh
usermod -aG docker vagrant
mkdir -p Application
git clone https://github.com/DevAndOps/JavaHelloWorld.git Application
chown -R vagrant Application

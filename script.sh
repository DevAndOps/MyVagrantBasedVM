export DEBIAN_FRONTEND=noninteractive
echo "export VAR=value" >> /home/$Username/.profile
apt-get -y install curl
curl -sSL https://get.docker.com/ | sh
usermod -aG docker $Username
mkdir -p Application
git clone https://github.com/DevAndOps/JavaHelloWorld.git Application
chown -R $Username Application
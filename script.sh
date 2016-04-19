export DEBIAN_FRONTEND=noninteractive
echo ". ~/EnvVaribles.txt" >> /home/$Username/.profile
apt-get -y install curl
curl -sSL https://get.docker.com/ | sh
usermod -aG docker $Username
mkdir -p Application
git clone https://github.com/DevAndOps/JavaHelloWorld.git Application
chown -R $Username Application 
docker run -d cgswong/vault:latest server -dev
#vaultContainerID=$(docker ps -q)
#docker exec -it $vaultContainerID bash
#export VAULT_ADDR='http://127.0.0.1:8200'
#vault status
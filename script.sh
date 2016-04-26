export DEBIAN_FRONTEND=noninteractive
echo ". ~/EnvVaribles.txt" >> /home/$Username/.profile
apt-get -y install curl
curl -sSL https://get.docker.com/ | sh
usermod -aG docker $Username
mkdir -p Application
mkdir -p Vault
git clone https://github.com/DevAndOps/JavaHelloWorld.git Application
chown -R $Username Application 
docker run -d \
	   -v /home/vagrant/vault/vault_data/:/root/vault/vault_data/ \
       -v /home/vagrant/vault.conf:/root/vault.conf cgswong/vault:latest \
       server -config /root/vault.conf
       
export VAULT_ADDR='http://127.0.0.1:8200'
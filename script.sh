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
       -v /home/vagrant/vault.conf:/root/vault.conf \
       -p 127.0.0.1:8200:8200 \
       cgswong/vault:latest \
       server -config /root/vault.conf 

IFS=',' read -a VaultKey <<< "$Vault_Key"

curl \
	-X GET \
	http://127.0.0.1:8200/v1/sys/seal-status

count=0
while [ "x${VaultKey[count]}" != "x" ]
do
	curl \
	-H "Content-Type: application/json" \
    -X PUT \
    -d '{"key": "'"${VaultKey[$count]}"'"}' \
    http://127.0.0.1:8200/v1/sys/unseal

   	count=$(( $count + 1 ))
done	

    

#vaultContainerID=$(docker ps -q)
#	docker exec $vaultContainerID bash -c "echo 'export VAULT_ADDR=\'http://127.0.0.1:8200\' >> /etc/.profile' && . /etc/.profile"
       
#export VAULT_ADDR='http://127.0.0.1:8200'
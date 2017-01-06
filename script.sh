export DEBIAN_FRONTEND=noninteractive
echo ". ~/EnvVaribles.txt" >> /home/$Username/.profile

usermod -aG docker $Username

cd ./docker
docker-compose up -d

# it takes few moments for vault to initialise.
sleep 2m

# get vault details from discovery service
vaultServicePort=$(curl -s -X GET http://localhost:8500/v1/catalog/service/vault | jq -c '.[0].ServicePort')

curl -X GET "http://localhost:$vaultServicePort/v1/sys/seal-status"

for key in $Vault_Key
do
	curl \
	-H "Content-Type: application/json" \
    -X PUT \
    -d '{"key": "'"$key"'"}' \
    "http://127.0.0.1:$vaultServicePort/v1/sys/unseal"
done  

#vaultContainerID=$(docker ps -q)
#	docker exec $vaultContainerID bash -c "echo 'export VAULT_ADDR=\'http://127.0.0.1:8200\' >> /etc/.profile' && . /etc/.profile"
       
#export VAULT_ADDR='http://127.0.0.1:8200'
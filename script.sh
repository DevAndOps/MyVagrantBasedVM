export DEBIAN_FRONTEND=noninteractive
echo ". ~/EnvVaribles.txt" >> /home/$Username/.profile

usermod -aG docker $Username

cd ./docker
docker-compose up -d

# it takes few moments for vault to initialise.
sleep 2m

cd ./vault
# get vault details from discovery service
vaultServicePort=$(curl -s -X GET http://localhost:8500/v1/catalog/service/vault | jq -c '.[0].ServicePort')

# just display the current vault status (should be sealed)
curl -X GET "http://localhost:$vaultServicePort/v1/sys/seal-status"

# unseal vault
for key in $Vault_Key
do
	curl \
	-H "Content-Type: application/json" \
    -X PUT \
    -d '{"key": "'"$key"'"}' \
    "http://localhost:$vaultServicePort/v1/sys/unseal"
done  

# allows to use 'vault <command>' in docker container
docker-compose exec -T vault /bin/bash -lc "echo 'export VAULT_ADDR=\"http://127.0.0.1:8200\"' > /etc/profile.d/vault_congifure.sh && . /etc/profile"

# add developer policy
#curl -s -X PUT -H "X-Vault-Token:$Vault_token" -d @policy.json http://localhost:$vaultServicePort/v1/sys/policy/developer

#vaultContainerID=$(docker ps -q)
#	docker exec $vaultContainerID bash -c "echo 'export VAULT_ADDR=\'http://127.0.0.1:8200\' >> /etc/.profile && . /etc/.profile"
       
#export VAULT_ADDR='http://127.0.0.1:8200'
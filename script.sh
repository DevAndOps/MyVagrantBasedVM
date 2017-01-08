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
docker-compose exec -T vault /bin/bash -lc "echo 'export VAULT_ADDR=\"http://localhost:$vaultServicePort\"' > /etc/profile.d/vault_congifure.sh && . /etc/profile"

# add developer policy

# formatting policy file in such a way so that it can be used in HTTP API
acljson=$(cat configuration/developer_acl.json | jq @json)
printf "{\"rules\":%s}" $acljson > ./configuration/developer_acl_deliver.json

# adding developer policy (idempotent)
curl -s -X PUT -H "X-Vault-Token:$Vault_token" -d @./configuration/developer_acl_deliver.json \ 
http://localhost:$vaultServicePort/v1/sys/policy/developer

# prepaing client token for all future interaction with vault (idempotent)
curl -s -X PUT -H "X-Vault-Token:$Vault_token" http://localhost:$vaultServicePort/v1/sys/revoke-prefix/auth/token/create 
clientToken=$(curl -s -X POST -H "X-Vault-Token:$Vault_token" -d "{\"policies\":[\"developer\"]}" \
http://localhost:$vaultServicePort/v1/auth/token/create | jq -r .auth.client_token)

# root token not to be used
unset Vault_token


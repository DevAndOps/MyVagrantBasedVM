export DEBIAN_FRONTEND=noninteractive
echo ". ~/EnvVaribles.txt" >> /home/$Username/.profile

usermod -aG docker $Username

cd ./docker
docker-compose up -d

# it takes few moments for vault to initialise.
sleep 2m

curl \
	-X GET \
	http://127.0.0.1:8200/v1/sys/seal-status

IFS=',' read -a VaultKey <<< "$Vault_Key"
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
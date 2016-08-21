export DEBIAN_FRONTEND=noninteractive
echo ". ~/EnvVaribles.txt" >> /home/$Username/.profile

: '
#usermod -aG docker $Username
mkdir -p Application

git config --global user.email "$GitEmail"
git config --global user.name "$GitUsername"
#mv ~/.gitconfig /home/$Username/
#chown -R $Username /home/$Username/.gitconfig
eval `ssh-agent -s`
#ssh-add /home/$Username/.ssh/github_rsa
ssh-add ~/.ssh/github_rsa
if [ ! -f ~/.ssh/known_hosts ]; then
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts
fi
git clone git@github.com:DevAndOps/JavaHelloWorld.git Application
#chown -R $Username Application 


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
'
    

#vaultContainerID=$(docker ps -q)
#	docker exec $vaultContainerID bash -c "echo 'export VAULT_ADDR=\'http://127.0.0.1:8200\' >> /etc/.profile' && . /etc/.profile"
       
#export VAULT_ADDR='http://127.0.0.1:8200'
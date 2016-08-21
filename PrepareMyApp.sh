mkdir -p Application

git config --global user.email "$GitEmail"
git config --global user.name "$GitUsername"
eval `ssh-agent -s`
ssh-add ~/.ssh/github_rsa
if [ ! -f ~/.ssh/known_hosts ]; then
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts
fi
git clone git@github.com:DevAndOps/JavaHelloWorld.git Application

sed -i 's,$privatekey,'"$ssh_privatekey"',g' additionalProfileContent.txt
echo ". ~/additionalProfileContent.txt" >> ~/.profile
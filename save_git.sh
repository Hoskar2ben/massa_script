cd ..
cd /home/x/massa_script
nom=$(date +%Y_%m_%d_%H_%M_%S__)
echo $nom > save_git.log
git add .
git commit -m $nom
git push

# Stop all docker comtainers, remove them, delete all volumes, remove all images, prune system
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q) -f
docker volume rm $(docker volume ls -q)
docker rmi $(docker images -a -q) -f
docker system prune -a -f

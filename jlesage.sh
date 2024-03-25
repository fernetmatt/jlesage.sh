#!/bin/bash
# Convenience script for starting jlesage container apps

HOME_DIR="/home/user"
MEDIA_DIR="/run/media/user"

if [[ ! -n $1 ]]; then
    echo "Commands: stopall, ps, ls, {app_name}"
    exit
fi

if [ $1 == "stopall" ]; then
    running=$(docker inspect --format='{{.Config.Image}} {{.Id}}' $(docker ps -aq) | sed /jlesage/\!d | cut -d" " -f2)
    if [[ -n "$running" ]]; then
        docker stop $running 2>&1 >/dev/null
        docker rm $running 2>&1 >/dev/null
    fi

    exit
fi

if [ $1 == "stop" ]; then
    app=$2
    container_id=$(docker ps -qaf name="$app")
    running=$(docker inspect --format='{{.Config.Image}} {{.Id}}' $(docker ps -aq) | sed /jlesage/\!d | cut -d" " -f2)
    docker stop $running 2>&1 >/dev/null
    docker rm $running 2>&1 >/dev/null
    exit
fi

if [ $1 == "ps" ]; then
    docker ps -a | sed /jlesage/\!d
    exit
fi

if [ $1 == "ls" ]; then
    # docker search jlesage | cut -d" " -f 1 | sed '1d'
    docker search --format "{{.Name}} ==> {{.Description}}" jlesage
    exit
fi

app=$1
container_id=$(docker ps -qaf name="$app")

if [[ -n "$container_id" ]]; then
    container_running=$(docker ps -qf name="$app")
    if [[ ! -n "$container_running" ]]; then
        docker start $container_id
    fi
else
    port=$(echo $((5800 + $RANDOM % 100)))
    docker run -d \
        --name=$app \
        -p $port:5800 \
        -v $HOME_DIR/.config/$app:/config:rw \
        -v $HOME_DIR:/storage-home:rw \
        -v $MEDIA_DIR:/storage-external:rw \
        jlesage/$app
fi

port=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "5800/tcp") 0).HostPort}}' $app)
sleep 3
xdg-open "http://127.0.0.1:$port"

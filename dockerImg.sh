#!/bin/bash

cd "$(dirname "$0")" || exit 1
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 {build|run|exec|pull|del} dockername"
  exit 1
fi
dockername=$2
imagename="$3"
del() {
  docker rmi "$dockername"
}
#创建容器
run() {
  docker run  -e username="william" --name "$dockername" -d "$imagename" /bin/zsh
}

build() {

  docker build -t "$dockername" .
}
#执行进入容器
exe() {
  docker exec -it -u william "$dockername" /bin/zsh
}

case $1 in
del)
  del
  echo "del done"
  ;;
build)
  build
  echo "build done"
  ;;
run)
  run
  echo "runing image"
  ;;
exec)
  exe
  echo "exec docker"
  ;;
esac

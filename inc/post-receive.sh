#!/bin/bash
LIVE="/var/www/raymii.org/html/s"
HOSTS=("vps1" "vps3" "vps5" "vps6" "vps8" "vps11" "vps12" "vps13" "vps14" "vps19" "vps20" "vps23" "vps24" "vps22")
read oldrev newrev refname
if [ $refname = "refs/heads/master" ]; then
  echo "===== DEPLOYING TO LIVE SITE ====="
  unset GIT_DIR
  cd $LIVE
  git pull origin master

  echo "===== DONE ====="
  echo "===== DEPLOYING ON CLUSTER ====="

  for HOST in ${HOSTS[@]}; do
    echo "${HOST}.sparklingclouds.nl"
    rsync -avzh --delete /var/www/raymii.org/html/s/ ${HOST}.sparklingclouds.nl:/var/www/s/
    echo ""
  done

  echo "===== DONE ====="

fi
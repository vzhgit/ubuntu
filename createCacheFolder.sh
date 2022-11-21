#!/bin/bash
mntPath=/mnt/.cache

checkLink () {
  my_link=$1
  if [ -L ${my_link} ] && [ -e ${my_link} ] ; then
    echo "${my_link} is Good link"
  else
    echo "${my_link} is Broken link"
    if [ -h ${my_link} ] ; then
      rm ${my_link}
    fi
    if [ -d "${mntPath}/${my_link}" ] ; then
      echo "Target folder is present"
    else
      echo "Target doesn't exist. Creating ..."
      mkdir -p ${mntPath}/${my_link}
    fi
    ln -s ${mntPath}/${my_link}
  fi
}
if [ -d $mntPath ] ; then
  echo "$mntPath folder for a cache is present"
else
  echo "Creating $mntPath folder ..."
  mkdir $mntPath
  chown -R buildadmin:buildadmin $mntPath
fi
cd /home/buildadmin/.cache
checkLink "yarn"
cd /home/buildadmin/.nuget
checkLink "packages"

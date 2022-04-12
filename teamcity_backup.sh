#!/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
# or export JAVA_HOME=/usr/lib/jvm/java-11-oracle

pathToTeamCity=/data/TeamCity
pathToBackup=/home/$USER/backup/
backupFile=artifacts
pathToArtifacts=${pathToTeamCity}/system/artifacts

echo "Archiving Postgres DB ..."
/home/$USER/TeamCity/bin/maintainDB.sh backup -A $pathToTeamCity --include-config --include-database --include-supplementary-data
if [[ "$(date +%A)" == "Sunday" ]]; then
  dtFull=$(date +'%Y%m%d')
  zipOption=""
else
  dt=$(date +'%Y%m%d')
  dtFull=$(date +'%Y%m%d' -d "$(date +%u) days ago")
  zipOption="-DF --out ${pathToBackup}${backupFile}_${dtFull}_increment_${dt}.zip"
fi
zipFile=${pathToBackup}${backupFile}_${dtFull}.zip

echo "Archiving $backupFile ..."
zip -r $zipFile $pathToArtifacts $zipOption --quiet

if [[ "$(date +%A)" == "Sunday" ]]; then
  expectedBackups=2
  numberOfArchives=$(find ${pathToBackup}*.zip -type f -name "*${dtFull}*" | wc -l)
  if [[ $numberOfArchives -ge $expectedBackups ]]; then
    echo "Deleting old archives ..."
    find ${pathToBackup}*.zip -type f -not -name "*${dtFull}*" -exec rm -rf {} \;
  else
   echo "Number of backup files less than expected!"
  fi
fi

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
  dt=$(date +'%Y.%m.%d')
  zipOption=""
else
  dt=$(date +'%Y.%m.%d' -d "$(date +%u) days ago")
  zipOption="-DF --out ${pathToBackup}/increment_for_${dt}.zip"
fi
zipFile=${pathToBackup}${backupFile}_${dt}.zip

echo "Archiving $backupFile ..."
zip -r $zipFile $pathToArtifacts $zipOption --quiet

numberOfDays=14
lastNdays=$(find ${pathToBackup}*.zip -type f -mtime -${numberOfDays} | wc -l)
if [[ $lastNdays -ge $numberOfDays ]]; then
  echo "Deleting old archives ..."
  find ${pathToBackup}*.zip -type f -mtime +${numberOfDays} -exec rm -rf {} \;
else
  echo "Number of backups less than expected!"
fi

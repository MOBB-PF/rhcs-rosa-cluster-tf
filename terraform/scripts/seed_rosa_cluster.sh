#!/bin/bash
# login rosa 
rosa login -t $token
# Check if cluster is ready
i=0
while [ true ]
do
  result=`rosa list clusters|grep -i $cluster|awk '{print $3}'`
  echo "result = $result"
  if [[ $result == "ready" ]]
    then
      break
  fi
  ((i++))
  if [[ "$i" == '100' ]]
    then
      echo "Number $i!"
      exit 1
  fi
  echo "cluster not ready sleeping 30"
  sleep 30
done
# Create admin user
login=`rosa create admin --cluster=$cluster| grep -i oc`
if [ $? -ne 0 ]
then
  echo "Failed to create Rosa cluster-admin user"
  exit 1
else
  echo "Successfully created rosa cluster-admin user."
fi
pw=`echo $login | awk '{print $7}'`
url=`echo $login | awk '{print $3}'`
echo $login
echo $pw
# Update secret value
aws secretsmanager put-secret-value --secret-id $secret --secret-string "{\"user\":\"cluster-admin\",\"password\":\"$pw\",\"url\":\"$url\"}"
if [ $? -ne 0 ]
then
  echo "Failed to updated AWS secret with cluster admin password."
  exit 1
else
  echo "Updated Rosa cluster-admin password to aws secret"
fi
# log into cluster
i=0
while [ true ]
do
  result=`$login --insecure-skip-tls-verify |grep -i default`
  echo "result = $result"
  if [[ $result =~ "default" ]]
    then
      break
  fi
  ((i++))
  if [[ "$i" == '100' ]]
    then
      echo "Number $i!"
      exit 1
  fi
  echo "cluster login not ready sleeping 30"
  sleep 30
done
# helm deployment.
sleep 120
oc project openshift-operators
helm repo add --username foster-rh --password $helm_token helm_repo $helm_repo 
helm repo update
i=0
while [ true ]
do
  helm install operators helm_repo/$helm_chart --version $helm_chart_version --insecure-skip-tls-verify
  if [ $? -eq 0 ]
    then
      echo "Helm installed initial helm operators successfully."
      break
  fi
  ((i++))
  if [[ "$i" == '5' ]]
    then
      echo "Helm failed to install initial helm operators successfully attemp $i - exiting"
      exit 1
  fi
  echo "Helm failed to install initial helm operators successfully sleeping 30 attemp $i"
  sleep 30
done



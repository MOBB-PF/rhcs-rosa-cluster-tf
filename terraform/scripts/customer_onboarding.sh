#!/bin/bash
# Create admin user
#retrieve secret value
sleep 20
url=`aws secretsmanager get-secret-value  --secret-id $secret --query SecretString --output text|jq -r ."url"|xargs`
pw=`aws secretsmanager get-secret-value  --secret-id $secret --query SecretString --output text|jq -r ."password"|xargs`
user=`aws secretsmanager get-secret-value  --secret-id $secret --query SecretString --output text|jq -r ."user"|xargs`
echo "$url"
echo "$pw"
echo "$user"
if [ $? -ne 0 ]
then
  echo "Failed to get AWS secret."
  exit 1
else
  echo "Retrieved aws secret"
fi
# log into cluster
i=0
while [ true ]
do
  echo "oc login $url --username $user --password $pw --insecure-skip-tls-verify"
  `oc login $url --username $user --password $pw --insecure-skip-tls-verify`
  if [ $? -eq 0 ]
    then
      break
  fi
  ((i++))
  if [[ "$i" == '5' ]]
    then
      echo "Number $i!"
      exit 1
  fi
  echo "cluster login not ready sleeping 30"
  sleep 30
done
oc project openshift-gitops  
# # helm deployment.
helm repo add --username foster-rh --password $helm_token helm_repo $customer_helm_repo 
helm repo update
i=0
while [ true ]
do
  helm install $customer_name helm_repo/$customer_helm_chart --version $customer_helm_chart_version --insecure-skip-tls-verify --set --set repo=$customer_repo --set name=$customer_name
  if [ $? -eq 0 ]
    then
      echo "Helm successfully install customer onboarding chart $customer_name."
      break
  fi
  ((i++))
  if [[ "$i" == '3' ]]
    then
      echo "Helm failed to install customer onboarding $customer_name $i - exiting"
      exit 1
  fi
  echo "Helm failed to install customer onboarding $customer_name sleeping 30 attemp $i"
  sleep 30
done



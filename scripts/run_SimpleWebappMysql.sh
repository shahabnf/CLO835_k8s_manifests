#!/bin/sh
echo "\n--------------------------------------"
echo "*** Installing Simple Webapp MySQL ..."
echo "--------------------------------------\n"

kubectl apply -f ../create-namespace.yaml
kubectl apply -f ../mysql-pvc.yaml -n final
kubectl apply -f ../mysql-secret-data.yaml -n final
kubectl apply -f ../mysql-deployment-definition.yaml -n final
kubectl apply -f ../mysql-service.yaml -n final
kubectl apply -f ../webapp-configmap.yaml -n final
./serviceaccount-iam-role.sh
kubectl apply -f ../service-account-definition.yaml -n final
kubectl apply -f ../serviceaccount-role.yaml -n final
kubectl apply -f ../serviceaccount-rolebinding.yaml -n final
kubectl apply -f ../webapp-deployment-definition.yaml -n final
kubectl apply -f ../webapp-service.yaml -n final

sleep 10

echo "\n--------------------------------------------"
echo "*** All services installed successfully. ***"
echo "--------------------------------------------\n"
kubectl get all -n final


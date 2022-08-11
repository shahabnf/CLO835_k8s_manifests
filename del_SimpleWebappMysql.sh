#!/bin/sh

echo "\n------------------------------------"
echo "*** Removing Simple Webapp MySQL ..."
echo "------------------------------------\n"

kubectl delete -f secret-data.yaml -n final
kubectl delete -f mysql-deployment-definition.yaml -n final
kubectl delete -f mysql-service.yaml -n final
kubectl delete -f webapp-configmap.yaml -n final
kubectl delete -f webapp-deployment-definition.yaml -n final
kubectl delete -f mysql-pvc.yaml -n final
kubectl delete -f service-account-definition.yaml -n final
kubectl delete -f serviceaccount-role.yaml -n final
kubectl delete -f serviceaccount-rolebinding.yaml -n final
kubectl delete -f webapp-service.yaml -n final
# kubectl delete -f webapp-service-np.yaml -n final
# kubectl delete -f mysql-pod-definition.yaml -n final
# kubectl delete -f webapp-pod-definition.yaml -n final
sleep 3

echo "\n------------------------------------------"
echo "*** All services removed successfully. ***"
echo "------------------------------------------\n"
kubectl get all -n final


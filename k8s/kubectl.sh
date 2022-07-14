kubectl get pod -o yaml -n namespace my-pod
kubectl get statefulset -o yaml -n namespace my-pod
kubectl get replicaset -o yaml -n namespace my-pod
kubectl logs -n namespace -f my-pod
kubectl get events --sort-by='.metadata.creationTimestamp' -A

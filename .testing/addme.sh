kubectl get configmap -n kube-system aws-auth -o yaml > /tmp/aws-auth.yaml
cat add-me-config.yaml >> /tmp/aws-auth.yaml
kubectl apply -f /tmp/aws-auth.yaml

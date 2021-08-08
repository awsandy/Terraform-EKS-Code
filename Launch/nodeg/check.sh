 #kubectl describe daemonset aws-node -n kube-system | grep Image | cut -d "/" -f 2  
 #kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
 #kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.9.0/config/v1.9/aws-k8s-cni.yaml
 #kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
 kubectl describe daemonset aws-node -n kube-system | grep Image | cut -d "/" -f 2 
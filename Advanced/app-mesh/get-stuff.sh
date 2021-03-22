# side cafr injection
export MESH_NAME=color-mesh
export MESH_REGION=$AWS_REGION
curl -o install-color.sh https://raw.githubusercontent.com/aws/aws-app-mesh-inject/master/scripts/install.sh 
# color teller app
curl -o color.yaml https://raw.githubusercontent.com/aws/aws-app-mesh-controller-for-k8s/master/examples/color.yaml
 
# cre ingress
kubectl apply -f appmesh-alb-ingress.yaml

kubectl -n appmesh-demo describe ing/colorgateway



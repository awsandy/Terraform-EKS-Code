date
cur=`pwd`
#dirs="tf-setup net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp"

echo "Some post build verifications"
echo "Should have 23 pods running in total"
rc=$(kubectl get pods -A | grep Running | wc -l)
if [ $rc -lt 23 ]; then 
echo "ERROR: Found only $rc pods running - expected 23"
else
echo "Passed running pod count"
fi

rc=$(kubectl get pods -A -o wide | grep 100.64 | wc -l)
if [ $rc -lt 9 ]; then 
echo "ERROR: Found only $rc pods running on 100.64.x.x- expected 9"
else
echo "PASSED: 100.64.x.x pod count"
fi

# 
rc=$(kubectl get pods -n game-2048 | grep Running | wc -l)
if [ $rc -lt 2 ]; then 
echo "ERROR: Found only $rc game-2048 pods running - expected 2"
else
echo "PASSED: game-2048 pod count"
fi

rc=$(kubectl get pods -n game1-2048 | grep Running | wc -l)
if [ $rc -lt 4 ]; then 
echo "ERROR: Found only $rc game1-2048 pods running - expected 4"
else
echo "PASSED: game-2048 pod count"
fi

rc=$(kubectl get pods -n game2-2048 | grep Running | wc -l)
if [ $rc -lt 4 ]; then 
echo "ERROR: Found only $rc game2-2048 pods running - expected 4"
else
echo "PASSED: game-2048 pod count"
fi

rc=$(kubectl get pods -n fargate1 | grep Running | wc -l)
if [[ $rc -lt 2 ]]; then 
echo "ERROR: Found only $rc fargate pods running - expected 2"
else
echo "PASSED: fargate pod count"
fi
helm ls -A | grep aws-load-balancer-controller | grep deployed && echo "PASSED: helm lb deployed" || echo "FAILED: helm lb deployed"
kubectl get pods -n kube-system | grep aws-load-balancer-controller | grep Running && echo "PASSED: lb pod" || echo "FAILED: lb pod"
kubectl logs jobs/eks-iam-test-s3 | grep tf && echo "PASSED: irsa test" || echo "FAILED: irsa test"


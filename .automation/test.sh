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

# terraform state rm helm_release.aws-load-balancer-controller
helm ls -A 
# 

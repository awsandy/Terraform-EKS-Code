Reference:
https://marcincuber.medium.com/amazon-eks-with-oidc-provider-iam-roles-for-kubernetes-services-accounts-59015d15cb0c


```bash
aws eks describe-cluster --name mycluster1 --query cluster.identity.oidc.issuer --output text
```

https://oidc.eks.eu-west-1.amazonaws.com/id/0157FC61B583C27158E830022C58BD68

no iDP at this point


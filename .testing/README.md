kubectl exec --stdin --tty nginx-deployment-74b89459bc-g26fc  -- /bin/bash





securityContext:
  capabilities:
    add: ["NET_ADMIN", "SYS_TIME"]


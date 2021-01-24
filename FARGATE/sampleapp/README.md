kubectl describe deployment  deployment-2048 -n game-2048

kubectl describe pods deployment-2048-67c7bd54d5-d969k -n game-2048

kubectl rollout restart deployment deployment-2048 -n game-2048


kubectl get events -n deployment-2048


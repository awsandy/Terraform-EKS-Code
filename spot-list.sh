il=()
il+="["
for i in $(ec2-instance-selector --usage-class spot -c 2 -a x86_64 -a amd64 --deny-list t[2-3]\.* -m 8Gib);do 
echo $i
il+='"'
il+=$i
il+='"'
il+=','
done
il-=","
il+="]"
echo $il 


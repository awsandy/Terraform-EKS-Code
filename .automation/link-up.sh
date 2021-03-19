date
cur=`pwd`
cd ../tfinit
ldir=`pwd`

#dirs="tf-setup net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp"
#dirs="net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp extra/nodeg2 extra/eks-cidr2 extra/sampleapp2"
dirs="net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp"
dirs="sampleapp"
for i in $dirs; do
    cd $cur
    cd ../$i
    echo " "
    echo "**** Linking in $i ****"
    rm -f base.tf vars-main.tf get-tfid.sh *.txt tfplan
    ln -s ../tfinit/base.tf.child base.tf && echo "linked base.tf"
    ln -s ../tfinit/vars-main.tf vars-main.tf && echo "linked vars-main.tf"
    ln -s ../tfinit/get-tfid.sh get-tfid.sh  && echo "linked get-tfid.sh"
    terraform init -no-color > /dev/null
    terraform fmt > /dev/null
    terraform validate
    #(terraform plan -out tfplan 2> plan.txt) > /dev/null
    #if [ $? -ne 0 ]; then
    #    echo "Plan error"
    #    cat plan.txt
    #    exit
    #else
    #    echo "Plan OK"
    #fi

done
cd $cur


dirs="extra/nodeg2 extra/eks-cidr2 extra/sampleapp2"
for i in $dirs; do
    cd $cur
    cd ../$i
    echo " "
    echo "**** Linking in $i ****"
    rm -f base.tf vars-main.tf get-tfid.sh *.txt tfplan
    ln -s ../../tfinit/base.tf.child base.tf && echo "linked base.tf"
    ln -s ../../tfinit/vars-main.tf vars-main.tf && echo "linked vars-main.tf"
    ln -s ../../tfinit/get-tfid.sh get-tfid.sh  && echo "linked get-tfid.sh"
    terraform init -no-color > /dev/null
    terraform fmt > /dev/null
    terraform validate
done
cd $cur

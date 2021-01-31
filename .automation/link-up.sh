date
cur=`pwd`
cd ../tfinit
ldir=`pwd`

#dirs="tf-setup net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp"
#dirs="net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp extra/nodeg2 extra/eks-cidr2 extra/sampleapp2"
dirs="net iam c9net"
for i in $dirs; do
    cd $cur
    cd ../$i
    echo " "
    echo "**** Linking in $i ****"
    rm -f base.tf vars-main.tf get-tfid.sh *.txt tfplan
    ln -s $ldir/base.tf.child base.tf && echo "linked base.tf"
    ln -s $ldir/tfinit/vars-main.tf vars-main.tf && echo "linked vars-main.tf"
    ln -s $ldir/tfinit/get-tfid.sh get-tfid.sh  && echo "linked get-tfid.sh"
done
cd $cur
    
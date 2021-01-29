resource "null_resource" "backend" {
triggers = {
    always_run = timestamp()
}
depends_on = [aws_dynamodb_table.terraform_locks]
provisioner "local-exec" {
    when = create
    command     = <<EOT
        
        id=${random_id.id1.hex}
        p1=${lower(basename(path.cwd))}
        reg=${data.aws_region.current.name}
        
        idfile="backend.tf"

        printf "terraform {\n" > $idfile
        printf "backend \"s3\" {\n" >> $idfile
        printf "bucket=\"tf-eks-state-%s\"\n" ${random_id.id1.hex} >> $idfile
        printf "key = \"terraform/terraform_state_%s.tfstate\"\n" $p1 >> $idfile
        printf "region = \"%s\"\n" $reg >> $idfile
        printf "dynamodb_table = \"terraform_locks_%s\"\n" $p1 >> $idfile
        printf "encrypt = "true"\n" >> $idfile
        printf "}\n" >> $idfile
        printf "}\n" >> $idfile

        # cat backend.tf
        terraform init -lock=false -force-copy -no-color > /dev/null
        terraform refresh -lock=false
        echo "sleep 1m for sync"
        sleep 60
        #echo "done"
     EOT
    #command = "./gen-s3.sh"
}
}
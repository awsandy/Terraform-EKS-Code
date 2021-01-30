resource "null_resource" "backend" {
triggers = {
    always_run = timestamp()
}
depends_on = [aws_dynamodb_table.terraform_locks]
provisioner "local-exec" {
    when = create
    command     = <<EOT
            noout=${var.no-output}
            id=${random_id.id1.hex}
            p1=${lower(basename(path.cwd))}
            reg=${data.aws_region.current.name}
            
            idfile="backend.tf"

            printf "terraform {\n" > $idfile
            printf "backend \"s3\" {\n" >> $idfile
            printf "bucket=\"tf-eks-state-%s\"\n" $id >> $idfile
            printf "key = \"terraform/tf_state_%s.tfstate\"\n" $p1 >> $idfile
            printf "region = \"%s\"\n" $reg >> $idfile
            printf "dynamodb_table = \"tf_lock_%s_%s\"\n" $id $p1 >> $idfile
            printf "encrypt = "true"\n" >> $idfile
            printf "}\n" >> $idfile
            printf "}\n" >> $idfile

            terraform init -lock=false -force-copy -no-color
            rm -f *.tfstate*
            #echo "done"
     EOT
    #command = "./gen-s3.sh"
}
}
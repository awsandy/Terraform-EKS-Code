resource "null_resource" "backend" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [aws_dynamodb_table.terraform_lock]
  provisioner "local-exec" {
    when    = create
    command = <<EOT
            noout=${var.no-output}
            p1=${lower(basename(path.cwd))}
            reg=${data.aws_region.current.name}
            idfile="backend.tf.new"
            
            echo "***** Writing backend.tf for S3 state *****"
            
            id=${var.tfid}

            printf "terraform {\n" > $idfile
            printf "backend \"s3\" {\n" >> $idfile
            printf "bucket=\"tf-eks-state-%s\"\n" $id >> $idfile
            printf "key = \"terraform/tf_state_%s.tfstate\"\n" $p1 >> $idfile
            printf "region = \"%s\"\n" $reg >> $idfile

            printf "dynamodb_table = \"tf_lock_%s_%s\"\n" $id $p1 >> $idfile
            
            printf "encrypt = "true"\n" >> $idfile
            printf "}\n" >> $idfile
            printf "}\n" >> $idfile

            mv backend.tf.new backend.tf
    
            #rm -f tf-out.txt 
            #echo "done"

     EOT

  }
}
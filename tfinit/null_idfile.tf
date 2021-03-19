resource "null_resource" "gen_idfile" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [random_id.id1]
  provisioner "local-exec" {
    when    = create
    command = <<EOT
        noout=${var.no-output}
        #idfile=$HOME/.tfid
	      #rm -f $idfile
        id=${random_id.id1.hex}
        #echo $id
        #printf "{\n" > $idfile
        #printf "\"id\" : \"%s\"\n" $id >> $idfile
        #printf "}\n" >> $idfile
        #echo "done"
        varfile="../.stub/var-tfid.tf"
        printf "variable \"tfid\" {\n" > $varfile
        printf "description = "The unique ID for the project\"\n" >> $varfile
        printf "type        = string\n" >> $varfile
        printf "default     = \"%s\"\n" $id >> $varfile
        printf "}\n" >> $varfile

     EOT

  }
}

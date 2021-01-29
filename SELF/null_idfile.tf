resource "null_resource" "gen_idfile" {
triggers = {
    always_run = timestamp()
}
depends_on = [random_id.id1]
provisioner "local-exec" {
    when = create
    command     = <<EOT
        idfile=$HOME/.tfid
        id=${random_id.id1.hex}
        echo $id
        printf "{\n" > $idfile
        printf "\"id\" : \"%s\"\n" $id >> $idfile
        printf "}\n" >> $idfile
        echo "done"
     EOT
    
}
}

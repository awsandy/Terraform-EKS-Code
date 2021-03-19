resource "random_id" "id1" {
   byte_length = 4 
}


#resource "random_id" "id2" {
#  keepers = {
#    # Generate a new id each time we switch to a new AMI id
#    name = "${var.ami_id}"
#  }

#  byte_length = 8
#}
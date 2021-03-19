#!/bin/bash
# Exit if any of the intermediate steps fail
#set -e

idfile=$HOME/.tfid
gotid=0
rm -f tf-out.txt
# get the subdir and basedir




# Method 1 - it's in the hidden file already 
if [ $gotid -eq 0 ]; then
    # state does not exist
    echo "no terraform random_id.id1 exists" >> tf-out.txt
    echo "check $idfile exists" >> tf-out.txt
        if [ -f "$idfile" ]; then
            echo "file exists - trying to get id" >> tf-out.txt
            id=$(cat $idfile | jq -r .id)
            echo "id from file = $id" >> tf-out.txt
            idl=$(echo $id | wc -c)
            if [ $idl -lt 16 ]; then
                exit 2 # id should be 8 byte hexidecimal value
            else
                gotid=1
            fi
        fi
fi

# Method 2 - a single state file bucket exists
# If thefre are multiple we will exit with an error - as that is unexpected
if [ $gotid -eq 0 ]; then       
            echo "no random_id and no $idfile" >> tf-out.txt
            echo "look for bucket" >> tf-out.txt
            (aws s3 ls | grep tf-eks-state 2> /dev/null) > /dev/null
            if [ $? -eq 0 ]; then
                echo "s3 buck exists - get it's name" >> tf-out.txt
                s3n=$(aws s3 ls | grep tf-eks-state | wc -l)
                if [ $s3n -eq 1 ]; then
                    id=$(aws s3 ls | grep tf-eks-state- | awk '{print $3}' | cut -f4 -d'-')
                    echo "check $idfile exists" >> tf-out.txt
                    if [ -f "$idfile" ]; then
                            echo "$idfile exists unexpected !" >> tf-out.txt
                            exit 3
                    else
                        gotid=1
                        echo "$idfile does not exist - write it" >> tf-out.txt
                        printf "{\n" > $idfile
                        printf "\"id\" : \"%s\"\n" $id >> $idfile
                        printf "}\n" >> $idfile
                        cat $idfile >> tf-out.txt
                    fi
                else
                    echo "multiple state buckets" >> tf-out.txt
                    exit 4
                fi
            else
                echo "s3 buck does not exist yet" >> tf-out.txt 
                id=`hexdump -n 8 -e '4/4 "%08X" 1 "\n"' /dev/random | tr -d ' '`
                if [ -f "$idfile" ]; then
                    echo "$idfile exists unexpected !" >> tf-out.txt
                    exit 3
                else
                    gotid=1
                    echo "$idfile does not exist - write it" >> tf-out.txt
                    printf "{\n" > $idfile
                    printf "\"id\" : \"%s\"\n" $id >> $idfile
                    printf "}\n" >> $idfile
                    cat $idfile >> tf-out.txt
                fi

            fi
fi

# Method 3 - it's in the state already - most likely we're setting up depends_on ramdom_id
if [ $gotid -eq 0 ]; then
    (terraform state list 2> /dev/null) > /dev/null
    if [ $? -eq 0 ]; then
        echo "it might exist" >> tf-out.txt
        terraform state list | grep random_id.id1 > /dev/null
        if [ $? -eq 0 ]; then
            echo "it does get it" >> tf-out.txt
            id=$(terraform state show random_id.id1 | grep hex | cut -f2 -d'=' | tr -d '"' | tr -d ' ')
            echo "id from state = $id" >> tf-out.txt
            gotid=1
            echo "check $idfile exists" >> tf-out.txt
            if [ -f "$idfile" ]; then
                    echo "$idfile exists" >> tf-out.txt
            else
                echo "$idfile does not exist - write it" >> tf-out.txt
                printf "{\n" > $idfile
                printf "\"id\" : \"%s\"\n" $id >> $idfile
                printf "}\n" >> $idfile
                cat $idfile >> tf-out.txt
            fi

        fi
    fi
fi

BUCKET_NAME=`printf "tf-eks-state-%s" $id | awk '{print tolower($0)}'`
jq -n --arg bn "$BUCKET_NAME" '{"Name":$bn}'
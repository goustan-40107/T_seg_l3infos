#!/bin/bash
NSXMGR=$1

# Update the authorization:Basic field with your
curl -k --request POST --url https://$NSXMGR/policy/api/v1/search/aggregate   --header 'authorization: Basic YWRtaW46QWRtaW4hMjNBZG1pbg=='   --header 'content-type: application/json'   --header 'user-agent: vscode-restclient'   --data '{"primary":{"resource_type":"Segment"},"related":[{"resource_type":"Tier0 OR Tier1","join_condition":"path:connectivity_path","alias":"connectivity","included_fields":"path,id,display_name,resource_type"}]}' > segt0t1.json

# Select only useful fields
cat segt0t1.json | grep -e '"type" :' -e 'network' -e '"resource_type" : "Ti' -e 'display_name' > selsegt0t1.txt


# Char/Strings manipulations
sed 's/  //g' selsegt0t1.txt > sed01
sed 's/"//g' sed01 > sed02
sed 's/,//g' sed02 > sed03
sed 's/ //g' sed03 > sed04
cat sed04 | tr -s '\n' ' ' > sed05

# Add NewLine before each “type”field 
sed "s/ type/\\`echo -e '\n'type`/g" sed05 > sed06
sed 's/type://' sed06 > sed07
sed 's/ display_name:/,/' sed07 > sed08
sed 's/ network:/,/' sed08 > sed09
sed 's/ resource_type:/,/' sed09 > sed10
sed 's/ display_name:/,/' sed10 > sed11
echo "Type,Seg_Name,Subnet,LR_Type,LR_Name" > seginfo.csv

# Create final csv output
cat sed11 >> seginfo.csv

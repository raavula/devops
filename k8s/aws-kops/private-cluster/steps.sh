
#STEP-1
source ~/Documents/SBG/aws/aws-east/source-raghav
aws s3api create-bucket --bucket raavula-kops-s3-bucket-for-cluster-state --region us-east-1
export NAME=privatekopscluster.k8s.local
export KOPS_STATE_STORE=s3://raavula-kops-s3-bucket-for-cluster-state

#STEP-2
kops create cluster \
--cloud=aws \
--master-zones=us-east-1a,us-east-1b,us-east-1c \
--zones=us-east-1a,us-east-1b,us-east-1c \
--node-count=2 \
--topology private \
--networking kopeio-vxlan \
--node-size=t2.micro \
--master-size=t2.micro \
${NAME}

#STEP-3
kops update cluster ${NAME} --yes

#STEP-4
kops validate cluster

#STEP-5
kops delete cluster ${NAME} --yes

#STEP-6
aws s3 rb s3://raavula-kops-s3-bucket-for-cluster-state --force


# Komande-koraci korištene tokom implementacije taska:

## Branching Models

There are two popular branching models that we see customers typically use in their organization. One is Trunk-based and other is Feature-based or "GitFlow" model.

## Trunk-based development

In Trunk-based model, developers collaborate on code in a single branch called “trunk” resisting any pressure to create other long-lived development branches by employing documented techniques. This leads to avoiding merging complexity and hence effort. At Amazon, we strongly encourage our teams to practice Continuous Integration via Trunk-based development where developers merge their changes several times a day into a central repository.

## Feature-based aka GitFlow development

So why do teams use Feature-based model? There are several reasons why:

- Not many teams have achieved CI/CD nirvana
- Multiple teams may be working on different feature releases with different launch timelines
- Organizations that provide SAAS (Software As-A Service) may have customers who do not wish to be on the "latest" version at all times, and thus forcing them to create multiple "Release" and "Hotfix" branches
- Certain teams within an Organization may have specific QA/UAT requirements that require manual approvals, that may delay the time since a new feature is introduced until it's released to production

We developed this workshop considering above, and also our customers have asked us for information that would help them use our tools to automate merge and release tasks.

### GitFlow

GitFlow involves creating multiple levels of branching off of master where changes to feature branches are only periodically merged all the way back to master to trigger a release.

- `Master` always and exclusively contains production code
- `Develop` is the basis for any new development efforts you make.

These two branches are so-called long-running branches: they remain in your project during its whole lifetime. Other branches, e.g. for features or releases, only exist temporarily: they are created on demand and are deleted after they've fulfilled their purpose.

### GitFlow guidelines:

- Use development as a continuous integration branch.
- Use feature branches to work on multiple features.
- Use release branches to work on a particular release (multiple features).
- Use hotfix branches off of master to push a hotfix.
- Merge to master after every release.
- Master contains production-ready code.

```
$ df -h - za provjeru veličine volumes-a

```

**resize.sh skripta:**

```

#!/bin/bash

# Specify the desired volume size in GiB as a command line argument. If not specified, default to 20 GiB.
SIZE=${1:-20}

# Get the ID of the environment host Amazon EC2 instance.
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
INSTANCEID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id 2> /dev/null)
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/region 2> /dev/null)

# Get the ID of the Amazon EBS volume associated with the instance.
VOLUMEID=$(aws ec2 describe-instances \
  --instance-id $INSTANCEID \
  --query "Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId" \
  --output text \
  --region $REGION)

# Resize the EBS volume.
aws ec2 modify-volume --volume-id $VOLUMEID --size $SIZE

# Wait for the resize to finish.
while [ \
  "$(aws ec2 describe-volumes-modifications \
    --volume-id $VOLUMEID \
    --filters Name=modification-state,Values="optimizing","completed" \
    --query "length(VolumesModifications)"\
    --output text)" != "1" ]; do
sleep 1
done

# Check if we're on an NVMe filesystem
if [[ -e "/dev/xvda" && $(readlink -f /dev/xvda) = "/dev/xvda" ]]
then
# Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/xvda 1
# Expand the size of the file system.
# Check if we're on AL2
  STR=$(cat /etc/os-release)
  SUB="VERSION_ID=\"2\""
  if [[ "$STR" == *"$SUB"* ]]
  then
    sudo xfs_growfs -d /
  else
    sudo resize2fs /dev/xvda1
  fi

else
# Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/nvme0n1 1

# Expand the size of the file system.
# Check if we're on AL2
  STR=$(cat /etc/os-release)
  SUB="VERSION_ID=\"2\""
  if [[ "$STR" == *"$SUB"* ]]
  then
    sudo xfs_growfs -d /
  else
    sudo resize2fs /dev/nvme0n1p1
  fi
fi

```

```
$ bash resize.sh 30 - pokretanje skripte sa target size-om
```

**Setup:**

```
$ git config --global user.name "bilaldjedovic"`  `$ git config --global user.email bilaldjedovic@gmail.com

Konfiguracija AWS CLI Credential helper za HTTPS
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

```

**Instalacija GitFlow:**

```
curl -OL https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh
chmod +x gitflow-installer.sh
sudo git config --global url."https://github.com".insteadOf git://github.com
sudo ./gitflow-installer.sh

```

![](Images/gitflow-only.png)

**AWS Cloudformation:**

**Steps:**

```
$ aws codecommit create-repository --repository-name gitflow-workshop --repository-description "Repository for Gitflow Workshop"

$ git clone https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/gitflow-workshop

ASSETURL="https://static.us-east-1.prod.workshops.aws/public/442d5fda-58ca-41f0-9fbe-558b6ff4c71a/assets/workshop-assets.zip"; wget -O gitflow.zip "$ASSETURL"

unzip gitflow.zip -d gitflow-workshop/

cd gitflow-workshop
git add -A

git commit -m "Initial Commit"

git push origin master

aws cloudformation create-stack --template-body file://appcreate.yaml --stack-name gitflow-eb-app


aws cloudformation create-stack --template-body file://envcreate.yaml --parameters file://parameters.json --capabilities CAPABILITY_IAM --stack-name gitflow-eb-master --disable-rollback

aws cloudformation describe-stacks --stack-name gitflow-eb-master

aws cloudformation create-stack --template-body file://envcreate.yaml --parameters file://parameters.json --stack-name gitflow-eb-master --capabilities CAPABILITY_NAMED_IAM

```

**AWS Lambda:**

```
aws cloudformation create-stack --template-body file://lambda/lambda-create.yaml --stack-name gitflow-workshop-lambda --capabilities CAPABILITY_IAM


```

**Dev Branch**

```
git flow init

aws cloudformation create-stack --template-body file://envcreate.yaml --parameters file://parameters-dev.json --capabilities CAPABILITY_IAM --stack-name gitflow-workshop-develop


```

**Feature Branch**

```
git flow feature start change-color

aws cloudformation create-stack --template-body file://envcreate.yaml --capabilities CAPABILITY_IAM --stack-name gitflow-workshop-changecolor --parameters ParameterKey=Environment,ParameterValue=gitflow-workshop-changecolor ParameterKey=RepositoryName,ParameterValue=gitflow-workshop ParameterKey=BranchName,ParameterValue=feature/change-color

Commit and push na Feature Branch:

git status
git add -A
git commit -m "Changed Color"
git push --set-upstream origin feature/change-color

Merge Feature sa Dev

git flow feature finish change-color

Delete Feature Branch

git push origin --delete feature/change-color

Push Dev brancha na CodeCommit

git push --set-upstream origin develop
```

**Celan your enviroment:**

```
Delete Develop & Master Environments
aws cloudformation delete-stack --stack-name gitflow-eb-master
aws cloudformation delete-stack --stack-name gitflow-workshop-develop

Delete Feature Environment
aws cloudformation delete-stack --stack-name gitflow-workshop-feature-change-color

Delete Lambda Functions
aws cloudformation delete-stack --stack-name gitflow-workshop-lambda

Delete Elastic Beanstalk Application
aws cloudformation delete-stack --stack-name gitflow-eb-app

Delete code commit repository
aws codecommit delete-repository --repository-name gitflow-workshop

Delete AWS Cloud9

-   In the AWS  [Cloud9](https://console.aws.amazon.com/cloud9) console, highlight your Cloud9 workspace
-   Select  **Delete**
```

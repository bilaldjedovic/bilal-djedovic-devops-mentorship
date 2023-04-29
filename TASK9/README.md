[TASK-9: Static website with S3 and CloudFront](https://github.com/allops-solutions/devops-aws-mentorship-program/issues/63)

- S3 website endpoint - non-encrypted: http://bilal-djedovic-devops-mentorship-program-week-11.s3-website.eu-central-1.amazonaws.com/
- Distrubtion endpoint - encrypted: https://d2hzrdxvi2av2x.cloudfront.net/
- R53 record - encrypted: https://www.bilal-djedovic.awsbosnia.com/

**S3 BUCKET:**

S3 Bucket files:

![](./s3BucketFiles.png)

S3 Bucket Static Website:

![](./s3StaticWebsite.png)

S3 Bucket endpoint:

![](./s3Non-encrypted.png)

S3 Bucket Policy:

    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::bilal-djedovic-devops-mentorship-program-week-11/*"
        }
    ]
    }

ACM Certificate in us-east-1:

![](./ACM-Certificate.png)

CloudFront distribution:

![](./CloudFront.png)

CloudFront distribution Origins:

![](./CloudFrontOrigins.png)

CloudFront distribution Behaviors:

![](./CloudFrontBehaviors.png)

CloudFront distribution index.html:

![](./CloudFrontDistributionIndexHTML.png)

CloudFront distribution error.html:

![](./CloudFrontDistributionErrorHTML.png)

CloudFront distribution encrypted:

![](./CloudFrontEncrypted.png)

R53 record:

![](./www.bilal-djedovic.awsbosnia.com.png)

![](./cert.png)

Komande korištene:

```
aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"_806e56829bf740b00d4d76cf6ae86a89.www.bilal-djedovic.awsbosnia.com.","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"_f7a0128314993370a3548a2163ca58e8.fpgkgnzppq.acm-validations.aws."}]}}]}' `

aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"www.bilal-djedovic.awsbosnia.com","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"d2hzrdxvi2av2x.cloudfront.net"}]}}]}'

aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "www.bilal-djedovic.awsbosnia.com.") | {Name, Value}'
```

![](./route53.png)

**Serverless**

**Monolitna arhitektura**

- možemo zamisliti kao blackbox
- postoje tri tiera:

  - upload
  - processing
  - store and manage

- pad jednog monolita vodi padu svih
- skaliranje je zajedničko (vertikalno skaliranje)
- naplaćivanje zajedničko

**Tiered arhitektura**

- dijelimo monolite u tierove svaki tier može biti na svom ili na istom
  serveru
- mogu se zasebno vertikalno skalirati te moguće je skaliranje i
  horizontalno
- možemo koristiti internal load balancera(zbog load balancera
  moguće je imati više servera)

**Nedostaci:**

- tierovi su povezani(coupled)
- moraju postojati tierovi, ukoliko želimo da sve funkcioniše kako
  treba
- nemoguće skaliranje na 0

**Razvoj sa redovima(Evolving with QUEUE)**

- proširujemo arhitekturu sa redovima čekanja(QUEUE)
- korištenjem redova čekanja(QUEUE) razdvajamo(decouple) tierove
- komunikacija između tierova nije direktna
- skaliranje se radi sa dužinom reda čekanja(Queue Lenght)

**Mikroservisna arhitektura**

- kolekcija mikroservisa
- mikroservis možemo zamisliti kao male aplikacije koje imaju svoju
  zasebnu logiku, zasebno čuvanje podataka.

**Event-Driven arhitektura**

- kolekcija proizvođača(producers,components) događaja(evenata)

**Postoje:**

     - Proizvođači događaja(Events Producers)
     - Potrošači događaja(Events Consumers)

- Komponenta može biti i proizvođač i potrošač
- Servisi se aktiviraju na event ne čekaju ga, ne koriste resurse
- Event Router centralna tačka razmjene za događaje (Event Bus -
  konstanta dostava)
- Servisi nisu konstatno pokrenuti i ne čekaju za događaj
- Produceri generišu kada se nešto dogodi neki event(Klik, error,
  kriterij postignut, upload pokrenut..)
- Nakon što se događaj pokrene, eventi su dostavljeni consumerima te su
  akcije pokrenute nakon izvršavanja sistem se vraća u "čekanje"
- Event-driven arhitektura samo koristi resurse dok rukuje(handle)
  evente.

**AWS Lambda**

Function as a Service (FaaS)

- Plaćanje na osnovu broja zahtjeva i koda kompajliranog(vremena do
  izvršenja)
- Koristi se za Serverless ili Event-driven arhitekturu
- Nije dobro koristiti Lambdu za konterizaciju(Docker je anti-pattern)
- Moze koristiti Lambda funkcije kao kontejnere
- Na svaki poziv lambde kreira se novi čisti enviroment kada se izvrši
  terminira se te se podaci ne pamte
- 512 MB memorije je dostupno(/tmp) moguće skaliranje na 10240 MB
- Maksimalno vrijeme izvršavanja lambda funckije je 900sec(15 minuta)
  za duže workflows potrebno je koristiti Step Functions
- Sigurnost ostvarena i kontrolisana uz pomoć execution role(IAM Role)

**Lambda ima dva network moda:**

     - Public kao defaultni

     - VPC network mode

- Integrisana sa CloudWatchom za metriku, monitoring

- Moguće je integrisati sa X-Rayom za praćenje putanje korisnika

**Poziv lambde:**

     - Sinhrono pozivanje

     - Asinhrono pozivanje

     - Event source mapping

- -Podržava verzionisanje

**CloudWatch Events i Event Bridge**

- CloudWatch Events bilježi near realtime evente sve promjene na AWS
  servisima.

- Event Bridge servis koji replicira CloudWatch Events, ima sve
  mogućnosti CloudWatch Events ali može da handla evente.

**Važan koncept:**

**_Ako se X dogodi ili Y puta uradi Z._**

**Serverless arhitektura:**

- Serverless computing ( ili serverless skraćeno ) je model gdje je
  cloud provajder ( AWS, AZure ili Google Cloud ) odgovoran za
  izvršavanje dio kod-a dinamički dodjeljivanjem resursa. Samo se
  naplaćuje količina resursa koji su korišteni za pokretanje tog kod-a.
  Kod se obično pokreće unutar statless konteinera koji mogu biti
  pokrenuti raznim događajima uključujući HTTP zahtjeve, Database
  events, queuing services, monitoring alerts, file uploads, scheduled
  events ( cron jobs ) itd. Kod koji se pošalje cloud provajderu za
  izvršavanje obično je u obliku funkcije ili manjih dijelova
  kod-a.(https://itbase.ba/vijesti/sta-je-serverless/1021)

- Aplikacije se kolekcije malih ili specijalnih funkcija
- Statless i kratkotrajna okruženja - naplaćivanje u vremenu trajanja
- Koristi se samo ukoliko je pokrenuta na event, ukoliko se ne koristi
  ne pravi troškove
- Koristi se veliki broj managed servisa, izbjegavaju se no self
  managed servisi

**Simple Notification Service (SNS)**

- Javno dostupan AWS servis
- Kordinira slanje i dostavljanje poruka
- Veličine poruke su <= 256 kB
- SNS Topic je bazni entitet SNS-a
- Publisher šalje poruke u kreirani TOPIC
- Svaki TOPIC ima svoje pretplatnike koji primaju poruke
- Pretplatnici mogu biti: HTTP, Email, SQS, Mobile Push, SMS Messages i
  Lambda
- HA i Skalabilan
- Server Side Enkripcija - bilo koji podaci koji trebaju biti sačuvani
  na disk mogu biti sačuvani u enkriptovanoj formi
- Mogućnost Cross-Accounta uz pomoć Topic Policy

**AWS Step Functions**

- Serverless workflow START -> STATES -> END
- Maksimalno trajanje 1 godina

**Dva workflowa:**

- Standard workflow

- Express workflow

- Može biti pokrenuta uz pomoć API Gatewaya, IOT Pravila, Event Bridge,
  Lambde

- IAM Role se koriste za permisije

**STATES**:

1.  SUCCEED OR FAIL
2.  WAIT STATE
3.  CHOICE
4.  PARALLEL
5.  MAP STATE
6.  TASK STATE

- Step funkcije kreiraju States Machines
- State machines su dugotrajni Serverless workflows
- Ima States koje pokreće Lambda
- Koristi se za ogromne workflows

**API Gateway**

- Kreira i upravlja API-ma(APPLICATION PROGRAMMING INTERFACE)
- Endpoint/Entry point aplikacija
- "Sjedi" između aplikacija i integracija(servisa)
- Može konektovati na servise/endpointe u AWS-u ili on-premises

**Vrste API-a**

1. HTTP API

2. REST API

3. WEBSOCKET API

**Ima:**

     - Request fazu(authorize, validate, transform)
     - Integraciju sa servisima
     - Response(transform, prepare, return)

- API Gateway Cache može biti korišten za smanjenje broja poziva prema
  backend integraciju te može poboljšati klijentove performanse

**Endpoint tipovi:**

      -Edge-Optimized

      -Regional

      -Private

**Stages:**

- API su deployani na stageove
- verzionisanje omogućeno
- postoji rollback na stages

**Errori:**

    -4xx Client Error - Invalid request on client side

    -5xx Server Error - Invalid Request, backend issue



    -400 - Bad request - Generic

    -403 - Access denied - Authorizer denies or WAF

    -429 - API Gateway can throttle

    -502 - Bad gateway exception - bad output returned

    -503 - Service unavaliable - backend endpoint offline

    -504 - Integration Failure/Timeout - 29 sec limit for integration

**Simple Queue Service**

- Javno dostupan, potpuno kontrolisan i visoko dostupan
- Koristi se za asinhrono razdvajanje aplikacija
- Neograničen broj poruka u redu čekanja
- Maksimalna veličina poruke 256KB.
- Consumer povlači poruku iz reda čekanja. Kada consumer procesira
  poruku poruka se briše.
- Consumeri mogu biti EC2 instanca ili Lambda funkcija
- Maksimalno zadržavanje poruke u redu čekanja 14 dana.
- Dead Letter Queue se koristi za problematične poruke.

**Dva tipa:**

_1. Standard Queue_

    -neograničen protok

    -malo kašnjenje

    -može imati duple poruke

_2. FIFO Queue_
-Limitiran protok

    -Mora imati .fifo sufix

**Amazon Kinesis- Data streams**

- Javno dostupan i visoko dostupan servis
- Skalabilan streaming servis
- Dizajnirarn za veliko uzimanje podataka
- Može imati veliki broj consumera

**Shards:**

    1 MB - ingestion

    2 MB - consumption

- Za povećanje performansi potrebno je promijeniti shards.

**Amazon Kinesis Data Firehose**

- Fully managed servis za učitavanje podataka.
- Automatsko skaliranje, fully serverless
- Near Real Time delivery(~60s)
- Transformira podatke uz pomoć Lambda funkcije
- Plaćanje samo za obim podataka kroz firehose

**Validne destinacije**

    1. HTTP <splunk

    2. Redshift

    3. ElasticSearch

    4. Destination Bucket

- Iako dobija podatke u realnom vremenu, dostavlja u Near real time

**Amazon Kinesis Data Analytics**

- Real time processing podataka
- Koristi SQL da kreira outpute
- Uzima podatke iz Data Streams ili Firehose

**Validne destinacije**

    1. Firehose

    2. Lambda

    3. Kinesis Data Streams

- Plaćanje samo za procesirane podatke

**Amazon Kinesis Video Streams**

- Uzima(koristi) live video podatke sa producera(Security Kamere,
  Telefoni, Automobili, Audio)
- Consumeri mogu pristupiti podacima frame po frame
- Integracija moguća sa AWS Servisima Rekognition i Connect..

**Amazon Cognito**

- Amazon Cognito vam omogućava da brzo i jednostavno dodate
  registraciju korisnika, prijavu i kontrolu pristupa vašim web i
  mobilnim aplikacijama. Amazon Cognito se prilagođava milionima
  korisnika i podržava prijavu sa provajderima društvenog identiteta,
  kao što su Apple, Facebook, Google i Amazon, i dobavljačima
  korporativnih identiteta putem SAML 2.0 i OpenID Connect.

- Pruža autentifikaciju, autorizaciju i user menadžment

      User pools - Sign in i dobij JWT ne omogućava pristup AWS servisima

      Identity pools - Daje pristup AWS Servisima uz pomoć Temporary AWS Credentials

**AWS Glue 101**

- Serverless ETL(Extract, transform and load)
- Moves and transforms data between source and destination
- Crawls data sources and generates AWS Glue Data

**Amazon MQ**

- Mnoge organizacije koje koriste topics i queue i žele migrirati na
  AWS koriste Amazon MQ.
- Open source message broker
- Baziran na Managed Apache ActiveMQ
- Pruža Queue i Topics
- VPC baziran servis nije javno dostupan!

**Amazon AppFlow**

- Fully managed integracijski servis
- Razumjenjuje podatke korištenjem flows
- Omogućava sync podataka i agregaciju podataka
- Public endpoint ali ima mogućnost rada sa privatnim linkovima

**Kodovi korišteni**

_U dijelu Automated EC2 Control using Lambda and Events:_

**_IAM ROLE:_**

    {

    "Version": "2012-10-17",

    "Statement": [

    {

    "Effect": "Allow",

    "Action": [

    "logs:CreateLogGroup",

    "logs:CreateLogStream",

    "logs:PutLogEvents"

    ],

    "Resource": "arn:aws:logs:_:_:_"

    },

    {

    "Effect": "Allow",

    "Action": [

    "ec2:Start_",

    "ec2:Stop*"

    ],

    "Resource": "*"

    }

    ]

    }

**_Lambda instance start:_**

    import boto3

    import os

    import json



    region = 'us-east-1'

    ec2 = boto3.client('ec2', region_name=region)



    def lambda_handler(event, context):

    instances=os.environ['EC2_INSTANCES'].split(",")

    ec2.start_instances(InstanceIds=instances)

    print('started instances: ' + str(instances))

**_Lambda instance stop:_**

    import boto3

    import os

    import json



    region = 'us-east-1'

    ec2 = boto3.client('ec2', region_name=region)



    def lambda_handler(event, context):

    instances=os.environ['EC2_INSTANCES'].split(",")

    ec2.stop_instances(InstanceIds=instances)

    print('stopped instances: ' + str(instances))

**_Lambda instance protect:_**

    import json



    region = 'us-east-1'

    ec2 = boto3.client('ec2', region_name=region)



    def lambda_handler(event, context):

    print("Received event: " + json.dumps(event))

    instances=[ event['detail']['instance-id'] ]

    ec2.start_instances(InstanceIds=instances)

    print ('Protected instance stopped - starting up instance: '+str(instances))

**Komande korištene u dijelu Build A Serverless App - Pet-Cuddle-o-Tron**

    import boto3, os, json



    FROM_EMAIL_ADDRESS = 'REPLACE_ME'



    ses = boto3.client('ses')



    def lambda_handler(event, context): # Print event data to logs ..

    print("Received event: " + json.dumps(event)) # Publish message directly to email, provided by EmailOnly or EmailPar TASK

    ses.send_email( Source=FROM_EMAIL_ADDRESS,

    Destination={ 'ToAddresses': [ event['Input']['email'] ] },

    Message={ 'Subject': {'Data': 'Whiskers Commands You to attend!'},

    'Body': {'Text': {'Data': event['Input']['message']}}

    }

    )

    return 'Success!'

**_Amazon States Language for state machine:_**

    {

    "Comment": "Pet Cuddle-o-Tron - using Lambda for email.",

    "StartAt": "Timer",

    "States": {

    "Timer": {

    "Type": "Wait",

    "SecondsPath": "$.waitSeconds",

    "Next": "Email"

    },

    "Email": {

    "Type": "Task",

    "Resource": "arn:aws:states:::lambda:invoke",

    "Parameters": {

    "FunctionName": "EMAIL_LAMBDA_ARN",

    "Payload": {

    "Input.$": "$"

    }

    },

    "Next": "NextState"

    },

    "NextState": {

    "Type": "Pass",

    "End": true

    }

    }

    }

**_API Lambda:_**

    import boto3, json, os, decimal



    SM_ARN = 'YOUR_STATEMACHINE_ARN'



    sm = boto3.client('stepfunctions')



    def lambda_handler(event, context): # Print event data to logs ..

    print("Received event: " + json.dumps(event))





    data = json.loads(event['body'])

    data['waitSeconds'] = int(data['waitSeconds'])





    checks = []

    checks.append('waitSeconds' in data)

    checks.append(type(data['waitSeconds']) == int)

    checks.append('message' in data)





    if False in checks:

    response = {

    "statusCode": 400,

    "headers": {"Access-Control-Allow-Origin":"*"},

    "body": json.dumps( { "Status": "Success", "Reason": "Input failed validation" }, cls=DecimalEncoder )

    }



    else:

    sm.start_execution( stateMachineArn=SM_ARN, input=json.dumps(data, cls=DecimalEncoder) )

    response = {

    "statusCode": 200,

    "headers": {"Access-Control-Allow-Origin":"*"},

    "body": json.dumps( {"Status": "Success"}, cls=DecimalEncoder )

    }

    return response


    class DecimalEncoder(json.JSONEncoder):

    def default(self, obj):

    if isinstance(obj, decimal.Decimal):

    return int(obj)

    return super(DecimalEncoder, self).default(obj)

**_S3 Policy:_**

    {

    "Version":"2012-10-17",

    "Statement":[

    {

    "Sid":"PublicRead",

    "Effect":"Allow",

    "Principal": "_",

    "Action":["s3:GetObject"],

    "Resource":["REPLACEME_PET_CUDDLE_O_TRON_BUCKET_ARN/_"]

    }

    ]

    }

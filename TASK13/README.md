## Key commands in TASK13

**Install Maven & Java**

1.  Install Apache Maven using the commands below (enter them in the terminal prompt of Cloud9):

    ```bash
    sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
    sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
    sudo yum install -y apache-maven
    ```

2.  Maven comes with Java 7. For the build image that we're going to use later on we will need to use at least Java 8. Therefore we are going to install Java 8, or more specifically [, which is a free, production-ready distribution of the Open Java Development Kit (OpenJDK) provided by Amazon:

    ```bash
    sudo amazon-linux-extras enable corretto8
    sudo yum install -y java-1.8.0-amazon-corretto-devel
    export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64
    export PATH=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre/bin/:$PATH
    ```

3.  Verify that Java 8 and Maven are installed correctly:

    ```bash
    java -version
    mvn -v
    ```

    **Create the Application**

4.  Use mvn to generate a sample Java web app

    ```bash
    mvn archetype:generate \
        -DgroupId=com.wildrydes.app \
        -DartifactId=unicorn-web-project \
        -DarchetypeArtifactId=maven-archetype-webapp \
        -DinteractiveMode=false
    ```

5.  Modify the **index.jsp** file to customize the HTML code (just to make it your own!). You can modify the file by double-clicking on it in the Cloud9 IDE. We will be modifying this further to include the full Unicorn branding later.

    ```html
    <html>
      <body>
        <h2>Hello Unicorn World!</h2>
        <p>This is my first version of the Wild Rydes application!</p>
      </body>
    </html>
    ```

After completing this commands you need to create CodeCommit Repository and Clone HTTPS URL.
The URL will have the following format:

```md
https://git-codecommit.<region>.amazonaws.com/v1/repos/<project-name>
```

[](https://catalog.us-east-1.prod.workshops.aws/workshops/752fd04a-f7c3-49a0-a9a0-c9b5ed40061b/en-US/codecommit#commit-your-code)

**Commit your Code**

1.  Back in the Cloud9 environment setup your Git identity:

    ```bash
    git config --global user.name "<your name>"
    git config --global user.email <your email>
    ```

2.  Make sure you are in the ~/environment/unicorn-web-project and init the local repo and set the remote origin to the CodeCommit URL you copied earlier:

    ```bash
    cd ~/environment/unicorn-web-project
    git init -b main
    git remote add origin <HTTPS CodeCommit repo URL>
    ```

3.  Now we can commit and push our code!
        ```bash
        git add *
        git commit -m "Initial commit"
        git push -u origin main
        ```
    Next step is to create Domain and Repository with attached Domain into CodeArtifact service. After that we need to connect the CodeArtifact repository.
    [](https://catalog.us-east-1.prod.workshops.aws/workshops/752fd04a-f7c3-49a0-a9a0-c9b5ed40061b/en-US/codeartifact#connect-the-codeartifact-repository)

**Connect the CodeArtifact repository**

1.  On the next page, click **View connection instructions**. In the dialog, choose **Mac & Linux** for **Operating system** and **mvn** as package manager.
2.  Copy the command for the authorization token and run it in your Cloud9 command prompt. This will look similar to the below. Be sure to adjust the **domain-owner** and, if present, the **region** to your account ID and region, respectively.

    ```bash
    export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain unicorns --domain-owner 123456789012 --query authorizationToken --output text`
    ```

3.  For the next steps, we'll have to update the **settings.xml**. As this doesn't exist yet, let's create it first:

    ```bash
    cd ~/environment/unicorn-web-project
    echo $'<settings>\n</settings>' > settings.xml
    ```

4.  Open the newly created **settings.xml** in the Cloud9 directory tree and follow the remaining steps in the **Connection instructions** dialog in the **CodeArtifact** console including the mirror section. The complete file will look similar to the one below. Close the dialog when finished by clicking **Done**.

```xml
<settings>
    <profiles>
        <profile>
            <id>unicorns-unicorn-packages</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <repositories>
                <repository>
                    <id>unicorns-unicorn-packages</id>
                    <url>https://unicorns-123456789012.d.codeartifact.us-east-2.amazonaws.com/maven/unicorn-packages/</url>
                </repository>
            </repositories>
        </profile>
    </profiles>
    <servers>
        <server>
            <id>unicorns-unicorn-packages</id>
            <username>aws</username>
            <password>${env.CODEARTIFACT_AUTH_TOKEN}</password>
        </server>
    </servers>
    <mirrors>
        <mirror>
            <id>unicorns-unicorn-packages</id>
            <name>unicorns-unicorn-packages</name>
            <url>https://unicorns-123456789012.d.codeartifact.us-east-2.amazonaws.com/maven/unicorn-packages/</url>
            <mirrorOf>*</mirrorOf>
        </mirror>
    </mirrors>
</settings>
```

**Create CodeArtifact Policy:**

```xml
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [ "codeartifact:GetAuthorizationToken",
                      "codeartifact:GetRepositoryEndpoint",
                      "codeartifact:ReadFromRepository"
                      ],
          "Resource": "*"
      },
      {
          "Effect": "Allow",
          "Action": "sts:GetServiceBearerToken",
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "sts:AWSServiceName": "codeartifact.amazonaws.com"
              }
          }
      }
  ]
}
```

**CodeBuild**

We first need to create an S3 bucket which will be used to store the output from CodeBuild i.e. our WAR file! After creating S3 Bucket we can proceed to Create a CodeBuild build project. Next step is to create **buildspec.yml** file into Cloud9 IDE.

    version: 0.2

    phases:
      install:
        runtime-versions:
          java: corretto17
      pre_build:
        commands:
          - echo Initializing environment
          - export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain unicorns --domain-owner 123456789012 --query authorizationToken --output text`
      build:
        commands:
          - echo Build started on `date`
          - mvn -s settings.xml compile
      post_build:
        commands:
          - echo Build completed on `date`
          - mvn -s settings.xml package
    artifacts:
      files:
        - target/unicorn-web-project.war
      discard-paths: no

And we need to push this file:

```bash
cd ~/environment/unicorn-web-project
git add *
git commit -m "Adding buildspec.yml file"
git push -u origin main
```

**CodeDeploy**

1.  Create a new folder **scripts** under **~/environment/unicorn-web-project/** .
2.  Create a file **install_dependencies.sh** file in the **scripts** folder and add the following lines:

    ```bash
    #!/bin/bash
    sudo yum install tomcat -y
    sudo yum -y install httpd
    sudo cat << EOF > /etc/httpd/conf.d/tomcat_manager.conf
    <VirtualHost *:80>
        ServerAdmin root@localhost
        ServerName app.wildrydes.com
        DefaultType text/html
        ProxyRequests off
        ProxyPreserveHost On
        ProxyPass / http://localhost:8080/unicorn-web-project/
        ProxyPassReverse / http://localhost:8080/unicorn-web-project/
    </VirtualHost>
    EOF

    ```

3.  Create a **start_server.sh** file in the **scripts** folder and add the following lines:

    ```bash
    #!/bin/bash
    sudo systemctl start tomcat.service
    sudo systemctl enable tomcat.service
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    ```

4.  Create a **stop_server.sh** file in the **scripts** folder and add the following lines:

    ```bash
    #!/bin/bash
    isExistApp="$(pgrep httpd)"
    if [[ -n $isExistApp ]]; then
    sudo systemctl stop httpd.service
    fi
    isExistApp="$(pgrep tomcat)"
    if [[ -n $isExistApp ]]; then
    sudo systemctl stop tomcat.service
    fi
    ```

5.  CodeDeploy uses an application specification (AppSpec) file in YAML to specify what actions to take during a deployment, and to define which files from the source are placed where at the target destination. The AppSpec file must be named **appspec.yml** and placed in the root directory of the source code.

Create a new file **appspec.yml** in the **~/environment/unicorn-web-project/** folder and add the following lines:

```yaml
version: 0.0
os: linux
files:
  - source: /target/unicorn-web-project.war
    destination: /usr/share/tomcat/webapps/
hooks:
  BeforeInstall:
    - location: scripts/install_dependencies.sh
      timeout: 300
      runas: root
  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 300
      runas: root
  ApplicationStop:
    - location: scripts/stop_server.sh
      timeout: 300
      runas: root
```

7.  To ensure that that the newly added scripts folder and appspec.yml file are available to CodeDeploy, we need to add them to the zip file that CodeBuild creates. This is done by modifying the **artifacts** section in the **buildspec.yml** like shown below:

```yaml
artifacts:
  files:
    - target/unicorn-web-project.war
    - appspec.yml
    - scripts/**/*
  discard-paths: no
```

8.  Now commit all the changes to CodeCommit:

    ```bash
    cd ~/environment/unicorn-web-project
    git add *
    git commit -m "Adding CodeDeploy files"
    git push -u origin main
    ```

pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/RAMESHKUMARVERMAGITHUB/Candycrush.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=candycrush \
                    -Dsonar.projectKey=candycrush'''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar'
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
         stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                       sh "docker build -t rameshkumarverma/candycrush:latest ."
                       // sh "docker tag uber rameshkumarverma/uber:latest "
                       sh "docker push rameshkumarverma/candycrush:latest"
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image rameshkumarverma/candycrush:latest > trivyimage.txt"
            }
        }
        // stage("deploy_docker"){
        //     steps{
        //         sh "docker run -d --name uber -p 3000:3000 rameshkumarverma/candycrush:latest"
        //     }
        // }
        stage('Deploy to kubernets'){
            steps{
                script{
                    // dir('K8S') {
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                                sh 'kubectl apply -f deployment-service.yml'
                                // sh 'kubectl apply -f service.yml'
                        }
                    // }
                }
            }
        }
    }
}

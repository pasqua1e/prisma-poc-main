//def files = [ 'main.tf','variables.tfvars','variables.tf']

pipeline {
    agent {
        node {
            label 'LinuxGenericOld'
            //Files to scan with types included
            //files= [['AWS_S3_VersioningConfiguration.json','CFT'],[ 'main.tf','tf012'],['sockshop.yaml','k8s']]
               //files= [[ 'main.tf','variables.tfvars','variables.tf']]
                   //withCredentials([usernamePassword(credentialsId: 'prisma-cloud-accesskey', passwordVariable: 'PC_PASS', usernameVariable: 'PC_USER')]) {
                //PC_TOKEN = sh(script:"curl -s -k -H 'Content-Type: application/json' -H 'accept: application/json' --data '{\"username\":\"$PC_USER\", \"password\":\"$PC_PASS\"}' https://${AppStack}/login | jq --raw-output .token", returnStdout:true).trim()
                //}
            }
    }
    environment {
        PRISMAAUTH = credentials('prisma-cloud-accesskey')
        PC_CONSOLE = 'https://europe-west3.cloud.twistlock.com/eu-2-143568833'
        //AppStack = 'https://api2.eu.prismacloud.io'
    }
    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

        //$PC_USER,$PC_PASS,$PC_CONSOLE
        stage('Download latest twistcli') {
            steps {
            withCredentials([usernamePassword(credentialsId: 'prisma-cloud-accesskey', passwordVariable: 'PC_PASS', usernameVariable: 'PC_USER')]) {
                sh 'curl -k -u $PC_USER:$PC_PASS --output ./twistcli $PC_CONSOLE/api/v1/util/twistcli'
                sh 'sudo chmod a+x ./twistcli'
            }
            }
        }
        stage ('get files'){
            steps {
                withCredentials([usernamePassword(credentialsId: 'prisma-cloud-accesskey', passwordVariable: 'PC_PASS', usernameVariable: 'PC_USER')]) {
                    script {
                    PC_TOKEN = sh(script:"curl -k -H 'Content-Type: application/json' -H 'accept: application/json' --data '{\"username\":\"$PC_USER\", \"password\":\"$PC_PASS\"}' https://api.prismacloud.io/login | jq --raw-output .token", returnStdout:true).trim()
                        }
                    //files = [[ 'main.tf','variables.tfvars','variables.tf']]
                    //PC_TOKEN = sh(script:"curl -s -k -H 'Content-Type: application/json' -H 'accept: application/json' --data '{\"username\":\"$PC_USER\", \"password\":\"$PC_PASS\"}' https://api2.eu.prismacloud.io/login | jq --raw-output .token", returnStdout:true).trim()
                }
            }
        }
        
        stage ('scan terraform templates') {
            steps {
                script {
            def files = [ 'main.tf','with-issues.tf']
                    sh "echo Going to echo a list"
                    for (int i = 0; i < files.size(); i++) {
                        sh "echo Hello ${files[i]}"
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        withCredentials([usernamePassword(credentialsId: 'prisma-cloud-accesskey', passwordVariable: 'PC_PASS', usernameVariable: 'PC_USER')]) {
                        //sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name Jenkins-IaC --tags env:jenkins  --address $PC_CONSOLE example/${files[i]}"
                        //sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name Jenkins-IaC --tags env:jenkins --compliance-threshold high --address https://$PC_CONSOLE --type ${item[2]} files/${item[0]}"
                        //sh "./twistcli iac scan --u $PC_USER --p $PC_PASS --compliance-threshold high --address https://$PC_CONSOLE files/${item}"
                            sh "ls"
                            sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name ${files[i]} --tags env:jenkins  --address  https://europe-west3.cloud.twistlock.com/eu-2-143568833   --type tf012 example/${files[i]}"
                        }
                    }
                    }
                }
            }
        }
        stage ('scan helm charts') {
            steps {
                script {
            def files = [ 'with-issues.yaml','without-issues.yaml']
                    sh "echo Going to echo a list"
                    for (int i = 0; i < files.size(); i++) {
                        sh "echo Hello ${files[i]}"
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        withCredentials([usernamePassword(credentialsId: 'prisma-cloud-accesskey', passwordVariable: 'PC_PASS', usernameVariable: 'PC_USER')]) {
                        //sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name Jenkins-IaC --tags env:jenkins  --address $PC_CONSOLE example/${files[i]}"
                        //sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name Jenkins-IaC --tags env:jenkins --compliance-threshold high --address https://$PC_CONSOLE --type ${item[2]} files/${item[0]}"
                        //sh "./twistcli iac scan --u $PC_USER --p $PC_PASS --compliance-threshold high --address https://$PC_CONSOLE files/${item}"
                            sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name ${files[i]} --tags env:k8s  --address  https://europe-west3.cloud.twistlock.com/eu-2-143568833   --type K8S kubernetes/${files[i]}"
                        }
                    }
                    }
                }
            }
        }
//         stage ('Scan with Rest API v2') {
//         steps {
//                 script {
//                     def response
//                     response = sh(script:"curl -sq -X POST -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://api2.eu.prismacloud.io/iac/v2/scans --data-binary '@scan-asset.json'", returnStdout:true).trim()
                        
//                     def SCAN_ASSET = readJSON text: response

//                     //Save the ScanId and ScanURL
//                     //The ScanURL is the s3 location to upload 
//                     def SCAN_ID = SCAN_ASSET['data'].id
//                     def SCAN_URL = SCAN_ASSET['data']['links'].url

//                     //Upload files
//                     sh(script:"curl -sq -X PUT  --url '${SCAN_URL}' -T 'example/${files[0]}'", returnStdout:true).trim()

//                     //start the Scan
//                     response = sh(script:"curl -sq -X POST -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://api2.eu.prismacloud.io/iac/v2/scans/${SCAN_ID} --data-binary '@${files[i]}'", returnStdout:true).trim()


//                     //Get the Status
//                     def SCAN_STATUS
//                     def STATUS
//                     //Need a Do-While loop here.   Haven't found a good syntax with Groovy in Jenkins
//                     response = sh(script:"curl -sq -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://api2.eu.prismacloud.io/iac/v2/scans/${SCAN_ID}/status", returnStdout:true).trim()
//                     SCAN_STATUS = readJSON text: response
//                     STATUS = SCAN_STATUS['data']['attributes']['status']
                        
//                     while  (STATUS == 'processsing'){
//                     response = sh(script:"curl -sq -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://api2.eu.prismacloud.io/iac/v2/scans/${SCAN_ID}/status", returnStdout:true).trim()
//                     SCAN_STATUS = readJSON text: response
//                     STATUS = SCAN_STATUS['data']['attributes']['status']
//                     print "${STATUS}"
//                     }
                

//                     //Get the Results
//                     response = sh(script:"curl -sq -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://api2.eu.prismacloud.io/iac/v2/scans/${SCAN_ID}/results", returnStdout:true).trim()
//                     def SCAN_RESULTS= readJSON text: response
//                     print "${SCAN_RESULTS}"
//                 }
//             }
//         }


//         files.each { item ->
//             stage("Scan IaC file ${item[0]} with twistcli") {
//                 steps {
//                 catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
//                     withCredentials([usernamePassword(credentialsId: 'prisma-cloud-accesskey', passwordVariable: 'PC_PASS', usernameVariable: 'PC_USER')]) {
//                         sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name Jenkins-IaC --tags env:jenkins  --address https://$PC_CONSOLE --type ${item[2]} example/${item[0]}"
//                         //sh "./twistcli iac scan -u $PC_USER -p $PC_PASS --asset-name Jenkins-IaC --tags env:jenkins --compliance-threshold high --address https://$PC_CONSOLE --type ${item[2]} files/${item[0]}"
//                         //sh "./twistcli iac scan --u $PC_USER --p $PC_PASS --compliance-threshold high --address https://$PC_CONSOLE files/${item}"
//                     }
//                 }
//                 }
//             }
//         }

//         //files.each { item ->
//            stage("Scan with Rest API v2 - ${item[2]}") {
//                steps {
//                     //Define a Scan
//                     def response
//                     response = sh(script:"curl -sq -X POST -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://${AppStack}/iac/v2/scans --data-binary '@scan-asset.json'", returnStdout:true).trim()

//                     def SCAN_ASSET = readJSON text: response

//                     //Save the ScanId and ScanURL
//                     //The ScanURL is the s3 location to upload 
//                     def SCAN_ID = SCAN_ASSET['data'].id
//                     def SCAN_URL = SCAN_ASSET['data']['links'].url

//                     //Upload files
//                     sh(script:"curl -sq -X PUT  --url '${SCAN_URL}' -T 'files/${item[0]}'", returnStdout:true).trim()

//                     //start the Scan
//                     response = sh(script:"curl -sq -X POST -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://${AppStack}/iac/v2/scans/${SCAN_ID} --data-binary '@${item[1]}'", returnStdout:true).trim()


//                     //Get the Status
//                     def SCAN_STATUS
//                     def STATUS

//                     //Need a Do-While loop here.   Haven't found a good syntax with Groovy in Jenkins
//                     response = sh(script:"curl -sq -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://${AppStack}/iac/v2/scans/${SCAN_ID}/status", returnStdout:true).trim()
//                     SCAN_STATUS = readJSON text: response
//                     STATUS = SCAN_STATUS['data']['attributes']['status']

//                     while  (STATUS == 'processsing'){
//                            response = sh(script:"curl -sq -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://${AppStack}/iac/v2/scans/${SCAN_ID}/status", returnStdout:true).trim()
//                            SCAN_STATUS = readJSON text: response
//                            STATUS = SCAN_STATUS['data']['attributes']['status']
//                            print "${STATUS}"
//                     }

//                     //Get the Results
//                     response = sh(script:"curl -sq -H 'x-redlock-auth: ${PC_TOKEN}' -H 'Content-Type: application/vnd.api+json' --url https://${AppStack}/iac/v2/scans/${SCAN_ID}/results", returnStdout:true).trim()
//                     def SCAN_RESULTS= readJSON text: response
//                         print "${SCAN_RESULTS}"
//                     }
//            }
//         }
    }
}

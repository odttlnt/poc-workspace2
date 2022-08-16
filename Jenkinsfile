// Sample Jenkinsfile using ssh and a zDT Agent (Nlopez)
def myApp       = 'poc-app'
scripts         = '/u/nlopez/tmp/dbb-zappbuild/scripts'

pipeline {
    agent  { label 'myZOS-Agent' }
    options { skipDefaultCheckout(true) }

    stages {
        stage('Clone') {
            steps {
                println '** Cloning on USS ...'                             
                //sh 'rm -r ' + env.WORKSPACE+'/* >/dev/null 2>&1 ; ' + scripts+'/CI/Clone.sh ' +  env.WORKSPACE + ' ' +  myApp + ' git@github.com:nlopez1-ibm/poc-workspace.git ' + env.BRANCH_NAME 
            }          
        }  

        stage('Build') {
            steps {
                  println  '** Building feature with DBB ...'                  
                  //sh scripts+'/CI/Build.sh ' + env.WORKSPACE + ' poc-workspace  ' + myApp + ' poc-app/cobol/datbatch.cbl'
            }
        }             

        stage('Publish') {
            steps {
                  println  '** Packaging artifacts and Publishing to UCD Code Station ...'
                  //sh scripts+'/CD/UCD_Pub.sh ' + env.BUILD_ID + ' ' + env.WORKSPACE+'/poc-workspace  '
            }
        }                
    }    
}

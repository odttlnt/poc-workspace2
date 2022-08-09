// Sample Jenkinsfile for testing (Nlopez) using ssh and a minimal Agent Setup
// Running ssh over mywazi  (sin eVpN)

def zAgent      = 'myWazi_Agent'
def myApp       = 'poc-app'
def myHLQ       = 'IBMUSER.JENKINS'
def zAppBuild   = "/u/ibmuser/waziDBB/dbb-zappbuild/build.groovy"

pipeline {
    // point to the USS Agent and skip Git auto-checkout. 
    agent  { label zAgent }
    options { skipDefaultCheckout(true) }
    stages {
        stage('Clone') {
            steps {
                println '** Cloning with SSH ...'   
                sh "pwd "
                sh "env"
                sh "/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Clone.sh " +  env.WORKSPACE + " " +  myApp + " git@github.com:nlopez1-ibm/poc-workspace.git " + env.BRANCH_NAME 
            }          
        }  

        stage('DBB Build') {
            steps {
                  println  '** Building with DBB ...'
                  sh 'groovyz /u/ibmuser/waziDBB/dbb-zappbuild/build.groovy   -w ' + env.WORKSPACE+'/poc-workspace -a ' + myApp + ' -o dbb-logs -h IBMUSER  poc-app/cobol/datbatch.cbl'
            }
        }        

        stage('Publish With UCD ') {
            steps {
                  println  '** WIP ...'                  
            }
        }        
    }    
}

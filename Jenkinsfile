// Sample Jenkinsfile for testing (Nlopez) using ssh and a minimal Agent Setup
// Running ssh over mywazi  (sin eVpN)
// Bug in Jenkins gi api limit I have 60 and Jenk doesnt see it and holds the pipe

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
                sh "rm -r " + env.WORKSPACE+"/*" 
                sh "/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Clone.sh " +  env.WORKSPACE + " " +  myApp + " git@github.com:nlopez1-ibm/poc-workspace.git " + env.BRANCH_NAME 
            }          
        }  

        stage('DBB Build') {
            steps {
                  println  '** Building with DBB ...'
                  sh '/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Build.sh ' + env.WORKSPACE + ' poc-workspace  ' + myApp + 'poc-app/cobol/datbatch.cbl'
            }
        }        

        stage('Publish With UCD ') {
            steps {
                  println  '** WIP ...'                  
            }
        }        
    }    
}

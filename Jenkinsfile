// Sample Jenkinsfile for testing (Nlopez) using ssh and a minimal Agent Setup
// testing v3 new GitPluging
// Run on mywazi 

// Define some basic variables
def zAgent      = 'myWazi_Agent'
def myApp       = 'poc-app'
def zAppBuild   = "/u/ibmuser/waziDBB/dbb-zappbuild/build.groovy"


pipeline {
    // point to the USS Agent and skip Git auto-checkout. 
    agent  { label zAgent }
    options { skipDefaultCheckout(true) }
    stages {
        stage('Clone') {
            steps {
                println '** Init Step: Setting up a Git Env with SSH from USS'   
                sh "pwd "
                sh "/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Clone.sh " +  env.WORKSPACE + " " +  myApp + " git@github.com:nlopez1-ibm/poc-workspace.git " + env.BRANCH_NAME 
            }          
        }  


        stage('DBB Build') {
            steps {
                  println  '** Building..'
                  sh "ls  "
                  sh "groovyz " + "/u/ibmuser/waziDBB/dbb-zappbuild/build.groovy" + " -w " + env.WORKSPACE+"/poc-workspace" " -a " + myApp + " -o dbb-logs -h " + env.USER + "poc-app/cobol/datbatch.cbl"
            }
        }        

        stage('Publish With UCD ') {
            steps {
                  println  '** WIP ...'                  
            }
        }        
    }    
}

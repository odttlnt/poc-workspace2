// Sample Jenkinsfile for testing (Nlopez) using ssh and a minimal Agent Setup
// testing v3 new GitPluging
// Run on mywazi 

// Define some basic variables
def zAgent      = 'myWazi_Agent'
def myApp       = 'poc-app'
def zAppBuild   = "/u/ibmuser/waziDBB/dbb-zappbuild/build.groovy"


pipeline {
    // point to the USS Agent and skip Git auto-checkout. 
    agent  { node { label zAgent }}
    // options { skipDefaultCheckout(true) }
    stages {
        stage('clone') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/develop']],
                    userRemoteConfigs: [[url: 'git@github.com:nlopez1-ibm/poc-workspace.git' ]]
                ])
            }  
        }  
        
        stage('Build') {
            steps {
                  println  '** Building..'
                  sh "ls  "
        //          sh "groovyz " + zAppBuild + " -w " + env.wkDir + " -a " + myApp + " -o dbb-logs -h " + env.USER + "poc-app/cobol/datbatch.cbl"
            }
        }        
    }    
}

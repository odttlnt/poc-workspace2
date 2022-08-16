// Sample Jenkinsfile using ssh and a WaaS Agent (Nlopez)
//   This reference model uses Git as the integration point between WaaS Dev builds and CI/CD
//   After a Dev stands up a pre-defined core image and applies his App-IaC he can work on his features
//   Then he Pushes his work to trigger an existing CI/CD flow (on-perm off or hybrid).
// ** With this model you dont need Jenkins.. so this script is not needed . but nice to have 

def zAgent      = 'myZDT_Agent'
def myApp       = 'poc-app'

pipeline {
    // point to the USS Agent and skip Git auto-checkout. 
    agent  { label zAgent }
    options { skipDefaultCheckout(true) }

    stages {
        stage('Clone') {
            steps {
                println '** Cloning on USS ...'             
                sh "rm -r " + env.WORKSPACE+"/* >/dev/null 2>&1"
                //sh "/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Clone.sh " +  env.WORKSPACE + " " +  myApp + " git@github.com:nlopez1-ibm/poc-workspace.git " + env.BRANCH_NAME 
                sh "/u/nlopez/tmp/dbb-zappbuild/scripts/CI/Clone.sh " +  env.WORKSPACE + " " +  myApp + " git@github.com:nlopez1-ibm/poc-workspace.git " + env.BRANCH_NAME 
            }          
        }  

        stage('Build') {
            steps {
                  println  '** Building feature with DBB ...'
                  // sh '/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Build.sh ' + env.WORKSPACE + ' poc-workspace  ' + myApp + ' poc-app/cobol/datbatch.cbl'
                  sh "/u/nlopez/tmp/dbb-zappbuild/scripts/CI/Build.sh " + env.WORKSPACE + ' poc-workspace  ' + myApp + ' poc-app/cobol/datbatch.cbl'
            }
        }             

         stage('Publish') {
            steps {
                  println  '** Packaging artifacts and Publishing to UCD Code Station ...'
                  // sh '/u/ibmuser/waziDBB/dbb-zappbuild/scripts/CI/Build.sh ' + env.WORKSPACE + ' poc-workspace  ' + myApp + ' poc-app/cobol/datbatch.cbl'
                  //sh "/u/nlopez/tmp/dbb-zappbuild/scripts/CI/Build.sh " + env.WORKSPACE + ' poc-workspace  ' + myApp + ' poc-app/cobol/datbatch.cbl'
                  sh "/u/nlopez/tmp/dbb-zappbuild/scripts/CD/UCD_Pub.sh " + env.BUILD_ID + " " + env.WORKSPACE+'/poc-workspace  '
            }
        }                
    }    
}

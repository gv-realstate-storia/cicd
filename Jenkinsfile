#!/usr/bin/env groovy 
node {
   try {
       stage 'Clean Workspace'
       deleteDir()
       stage 'Checkout'
       checkout scm
       stage 'Handle Dependencies'   
            sh 'rm cicd/docker/src/dummyapp -Rf'
            sh 'cd cicd/docker/src && sudo chmod 777 init-repos.sh && ./init-repos.sh'	      
      stage 'Build Docker Instance'
	   def myEnv = docker.build 'lalala'
      stage 'Run Unit Tests'	   
	   	  myEnv.inside {
			  sh 'php -v'
			   sh 'ls -l'
			  //sh 'cd phpunit  && phpunit'
	   	        sh 'cd phpunit && phpunit --log-junit "reports/unitreport.xml" --coverage-html "reports/coverage" --coverage-clover "reports/coverage/coverage.xml" tests/'
			//junit '**/target/*.xml'
		  }
	        sh 'php -v'
	   sh 'ls -l'
	   sh 'cd phpunit/reports && ls -l'
	        //junit "phpunit/reports/coverage/coverage.xml"
	   	// sh 'cd phpunit && composer update && phpunit'
	   	//sh 'cd phpunit && composer update && phpunit --log-junit "reports/unitreport.xml" --coverage-html "reports/coverage" --coverage-clover "reports/coverage/coverage.xml" tests/'
		//sh 'junit "**/coverage/*.xml"'
      stage 'Run Functional Tests'
	      sh 'echo "RUN FUNCTIONAL TESTS"'
      stage 'Notify Slack'
      
   } catch (e) {
    // Set the build to failed
    currentBuild.result = "FAILED"
    throw e
  } finally {
    // Always send notifications
    //currentBuild.result = "Error"  
      
   // notifyBuild(currentBuild.result, getSlackUserNameFromGitCommit())
  }
}

def getSlackUserNameFromGitCommit(){
   
   def gitUserEmail = sh(returnStdout: true, script: 'git show -s --pretty=%ae').trim()
   
   if(gitUserEmail==''){
      return null
   }
   return '@' + gitUserEmail.split('@')[0]
}

def notifyBuild(String buildStatus = 'STARTED', String channel) {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' ${env.GIT_AUTHOR_EMAIL}"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }
   
  slackSend (color: colorCode, message: channel)
   
  // Send notifications
  slackSend (color: colorCode, message: summary, channel: channel)
}

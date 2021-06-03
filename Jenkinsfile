 import groovy.transform.Field

@Field def github='https://github.com/llStrevensll/hello-world-java.git'
@Field def tagCompilation
@Field def nameContainer

pipeline {
    agent any
    tools {
        nodejs 'node'
    }
    environment { 
    	registry = "" 
    	registryCredential = 'dockerhub-llstrevensll' 
    	dockerImage = ""
    }
    stages {
        stage ('Clone') {
			steps {	
				script{
				    cleanWs()
					sh """echo 'testing variable with bash: ${github}' """
                    
                    git branch: 'main', credentialsId: 'cdd99910-5eab-4c23-8227-387f0abd212b', url: "${github}"
                    
				    
				}
			}
		}
		
		stage ('Build-Maven') {
			steps {	
				script{
				    echo "build"
				    sh """ 
                            mvn clean package
                            
                        """
				}
			}
		}
		stage ('Sonarqube') {
			steps {	
				script{
				    echo "sonarqube"
				    withSonarQubeEnv("Sonar8.9.0") {
				        sh 'mvn sonar:sonar -Dsonar.projectKey=hello-world-java'
				    }
				    /*sh """ 
                            mvn 
 
                        """*/
				}
			}
		}
		
		stage ('Docker-Image') {
			steps {	
				script{
				    try {
                        echo "docker-image"
                        tagCompilation = "${env.BUILD_NUMBER}-dev"
                        registry = "llstrevensll/hello-world-java:${tagCompilation}"
                        dockerImage = "hello-world-java:${tagCompilation}"
				        sh """ 
                            docker version
                            docker build -t ${registry} .
                            docker images
                        """
                        
                    } catch (Exception e) {
                            echo 'Exception occurred: ' + e.toString()
                            //sh """ currentBuild.result = 'SUCCESS' """
                            //currentBuild.result = 'SUCCESS'
                            //return
                    }
				    
				}
			}
		}
		stage ('Docker-Run') {
			steps {	
				script{
				    try {
				        nameContainer = "helloworld${env.BUILD_NUMBER}"
                        echo "docker-run"
				        sh """ 
                            docker run --name ${nameContainer} -d -p 5000:5000 ${registry}
                            docker ps
                        """
                        input message: 'Finished using the web site? (Click "Proceed" to continue)'
                        
                    } catch (Exception e) {
                            echo 'Exception occurred: ' + e.toString()
                            //sh """ currentBuild.result = 'SUCCESS' """
                            //currentBuild.result = 'SUCCESS'
                            //return
                    }
				    
				}
			}
		}
		stage ('Deploy') {
			steps {	
				script{
				    
				    try {
				        docker.withRegistry( '', registryCredential ) { 
                            sh """
                                docker push ${registry}
                            """
                        }
                        
                    } catch (Exception e) {
                            echo 'Exception occurred: ' + e.toString()
                            //sh """ currentBuild.result = 'SUCCESS' """
                            //currentBuild.result = 'SUCCESS'
                            //return
                    }
				    
				}
			}
		}
		stage ('Docker-Remove') {
			steps {	
				script{
				    try {
                        echo "docker-rm"
				        sh """ 
				            docker stop ${nameContainer}
				            docker rm ${nameContainer}
                            docker rmi ${registry}
                        """
                        //npm test -- --coverage
                    } catch (Exception e) {
                            echo 'Exception occurred: ' + e.toString()
                            //sh """ currentBuild.result = 'SUCCESS' """
                            //currentBuild.result = 'SUCCESS'
                            //return
                    }
				    
				}
			}
		}
		
    }
}
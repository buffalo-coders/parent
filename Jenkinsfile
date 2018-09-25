#!groovy

pipeline {

  agent any

  stages {

    stage ('Preparation') {
      steps {
        checkout scm
        withMaven() {
          sh "mvn clean"
        }
      }
    }

    stage ('Unit Test') {
      steps {
        withMaven() {
          sh "mvn install"
        }
      }
    }

    stage ('Post Build Cleanup') {
      steps {
        withMaven() {
          sh "mvn clean"
        }
      }
    }

  }

}

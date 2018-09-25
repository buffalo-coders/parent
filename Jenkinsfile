#!groovy

pipeline {

  agent any

  stages {

    stage ('Preparation') {
      steps {
        checkout scm
        withMaven(maven: 'default') {
          sh "mvn clean"
        }
      }
    }

    stage ('Unit Test') {
      steps {
        withMaven(maven: 'default') {
          sh "mvn install"
        }
      }
    }

    stage ('Post Build Cleanup') {
      steps {
        withMaven(maven: 'default') {
          sh "mvn clean"
        }
      }
    }

  }

}

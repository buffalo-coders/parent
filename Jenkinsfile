#!groovy

pipeline {

  agent any

  environment {
    MAVEN_OPTS = '-Xmx2g -XX:MaxPermSize=512m'
    MVN_OPTS = '--batch-mode --errors --fail-fast --threads 1'
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '50'))
    timeout(time: 1, unit: 'HOURS')
  }

  tools {
    jdk   'java-1.8'
    maven 'maven-3.5'
  }

  triggers {
    pollSCM('H/5 * * * *')
  }

  stages {

    stage ('Preparation') {
      steps {
        checkout scm
        sh "mvn $MVN_OPTS clean"
      }
    }

    stage ('Unit Test') {
      steps {
        sh "mvn $MVN_OPTS clean install"
      }

      post {
        always {
          archive '**/target/*.jar'
          archive '**/target/*.pom'
          archive '**/target/*.war'
          junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
          warnings consoleParsers: [[parserName: 'Java Compiler (javac)'], [parserName: 'Maven']]
        }
      }
    }

    stage ('Maven Deployment') {
      when {
        branch 'master'
      }

      steps {
        sh "mvn $MVN_OPTS -Dmaven.test.skip=true -DskipTests=true clean deploy"
      }
    }

    stage ('Post Build Cleanup') {
      steps {
        sh "mvn $MVN_OPTS clean"
      }
    }

  }

}

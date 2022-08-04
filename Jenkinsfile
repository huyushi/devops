pipeline {
    agent any
    environment{
            harborHost = '139.196.102.187:80'
            harborRepo = 'repo'
            harborUser = 'admin'
            harborPasswd = 'Harbor12345'
        }

    // 存放所有任务的合集
    stages {
        stage('git pull code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'http://106.14.187.176:8929/root/flexiv_ccs_cloud.git']]])
              }
        }

        stage('unit test') {
            steps {
                echo '检测代码质量'
            }
        }

        stage('build image and push harbor') {
            steps {
                 sh '''
                 docker build -t ${JOB_NAME}:latest .
                 '''
                 sh '''
                 docker login -u ${harborUser} -p ${harborPasswd} ${harborHost}
                 docker tag ${JOB_NAME}:latest ${harborHost}/${harborRepo}/${JOB_NAME}:latest
                 docker push ${harborHost}/${harborRepo}/${JOB_NAME}:latest
                 '''
            }
        }
        stage('update yaml and send to k8s-master') {
                    steps {
                        sshPublisher(publishers: [sshPublisherDesc(configName: 'k8s', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'deploy.yaml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                    }
                }
        stage('k8s-master apply yaml') {
                    steps {
                       sh '''
                       ssh root@47.101.67.154 kubectl apply -f /usr/local/k8s/deploy.yaml
                       ssh root@47.101.67.154 kubectl rollout restart deployment pipeline
                       '''
                    }
                }
        }

}
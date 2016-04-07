set -e -x

docker build $* -t gcr.io/meta-iterator-105109/jenkins jenkins/
docker build $* -t gcr.io/meta-iterator-105109/libfuzzer-slave libfuzzer-slave/
docker build $* -t gcr.io/meta-iterator-105109/tpm2-slave tpm2-slave/

gcloud docker push gcr.io/meta-iterator-105109/jenkins
gcloud docker push gcr.io/meta-iterator-105109/libfuzzer-slave
gcloud docker push gcr.io/meta-iterator-105109/tpm2-slave

REGION=  //see left panel

BigQuery_output_table=  //task 1


cat << EOF > s.py
input_string = "$BigQuery_output_table"
parts = input_string.split(':')
LAB_NAME = parts[1].split('.')[0]
CUSTOMERS = parts[1].split('.')[1]
print("LAB_NAME:", LAB_NAME)
print("CUSTOMERS:", CUSTOMERS)
EOF
output=$(python s.py)
LAB_NAME=$(echo "$output" | awk '/LAB_NAME:/ {print $2}')
CUSTOMERS=$(echo "$output" | awk '/CUSTOMERS:/ {print $2}')
bq mk $LAB_NAME
gsutil mb gs://$DEVSHELL_PROJECT_ID-marking/
gsutil cp gs://cloud-training/gsp323/lab.csv  .
gsutil cp gs://cloud-training/gsp323/lab.schema .
gcloud dataflow jobs run Cloudhustler --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_BigQuery --region $REGION --worker-machine-type e2-standard-2 --staging-location gs://$DEVSHELL_PROJECT_ID-marking/temp --parameters javascriptTextTransformGcsPath=gs://cloud-training/gsp323/lab.js,JSONPath=gs://cloud-training/gsp323/lab.schema,javascriptTextTransformFunctionName=transform,outputTable=$BigQuery_output_table,inputFilePattern=gs://cloud-training/gsp323/lab.csv,bigQueryLoadingTemporaryDirectory=gs://$DEVSHELL_PROJECT_ID-marking/bigquery_temp
gcloud dataproc clusters create cluster-b53a --region $REGION --master-machine-type e2-standard-2 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type e2-standard-2 --worker-boot-disk-size 500 --image-version 2.1-debian11 --project $DEVSHELL_PROJECT_ID



TASK 2 OPEN ANOTHER SHELL
THEN SEARCH API
API & CREDINTIALS > CREATE CREDINTIALS > API KEY > COPY IT


API_KEY=

Bucket_TASK_3=

Bucket_TASK_4=


gcloud iam service-accounts create cloushustler \
  --display-name "my natural language service account"
gcloud iam service-accounts keys create ~/key.json \
  --iam-account cloushustler@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
cloud="/home/$USER/key.json"
gcloud auth activate-service-account cloushustler@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --key-file=$cloud
gcloud ml language analyze-entities --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." > result.json
gcloud auth login --no-launch-browser




// SELECT YES  --> OPEN LINK -> LOGIN  COPY PASTE AUTH CODE


gsutil cp result.json $Bucket_TASK_4
cat > request.json <<EOF 
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-training/gsp323/task3.flac"
  }
}
EOF
curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
gsutil cp result.json $Bucket_TASK_3
gcloud iam service-accounts create cloudhus
gcloud iam service-accounts keys create key.json --iam-account cloudhus@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file key.json
export ACCESS_TOKEN=$(gcloud auth print-access-token)
cat > request.json <<EOF 
{
   "inputUri":"gs://spls/gsp154/video/train.mp4",
   "features": [
       "TEXT_DETECTION"
   ]
}
EOF
curl -s -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @request.json
curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer $ACCESS_TOKEN" 'https://videointelligence.googleapis.com/v1/operations/OPERATION_FROM_PREVIOUS_REQUEST' > result1.json






SEARCH DATAPROC > CLICK ON CLUSTER-B53A
VM INSTANCE > SSH > hdfs dfs -cp gs://cloud-training/gsp323/data.txt /data.txt


FROM LEFT PANNEL SELECT JOBS > SUBMIT JOB
REGION FROM LAB > CLUSTER CLUSTER-B53A > JOB TYPE SPARK

MAIN CLASS OR JAR    org.apache.spark.examples.SparkPageRank

JAR FILES    file:///usr/lib/spark/examples/jars/spark-examples.jar

ARGUMENTS   /data.txt

MAX RESTARTS PER HOUR   1

SUBMIT

      

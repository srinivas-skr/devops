export INSTANCE=
export PORT_NO=
export FIREWALL=
export REGION=
export ZONE=



gcloud compute instances create $INSTANCE \
    --zone=$ZONE \
    --machine-type=e2-micro

TASK 2	
	
gcloud container clusters create nucleus-backend \
    --num-nodes=1 \
    --zone=$ZONE
	
	
	gcloud container clusters get-credentials nucleus-backend \
          --zone $ZONE
		  
		  
		  
		  kubectl create deployment hello-server \
          --image=gcr.io/google-samples/hello-app:2.0
		  
		  
		  
		  kubectl expose deployment hello-server \
          --type=LoadBalancer \
          --port $PORT_NO
		  
		
TASK 3
		  
		  
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF



gcloud compute instance-templates create web-server-template \
       --metadata-from-file startup-script=startup.sh \
       --machine-type g1-small \
       --region $REGION
	   
	   
	   
gcloud compute target-pools create nginx-pool --region $REGION
	   
	   
gcloud compute instance-groups managed create web-server-group \
--base-instance-name web-server \
--size 2 \
--template web-server-template \
--region $REGION


gcloud compute firewall-rules create $FIREWALL \
       --allow tcp:80
	   
	   
gcloud compute http-health-checks create http-basic-check


gcloud compute instance-groups managed \
       set-named-ports web-server-group \
       --named-ports http:80 \
       --region $REGION


gcloud compute backend-services create web-server-backend \
       --protocol HTTP \
       --http-health-checks http-basic-check \
       --global
	   
	   
	   
gcloud compute backend-services add-backend web-server-backend \
       --instance-group web-server-group \
       --instance-group-region $REGION \
       --global
	   
	   
	gcloud compute url-maps create web-server-map \
       --default-service web-server-backend
	   
	   
	   gcloud compute target-http-proxies create http-lb-proxy \
       --url-map web-server-map
	   
	   
	   
	   
	gcloud compute forwarding-rules create $FIREWALL \
     --global \
     --target-http-proxy http-lb-proxy \
     --ports 80
	 
	 
	 
	 
	 gcloud compute forwarding-rules list

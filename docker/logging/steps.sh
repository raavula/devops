docker-compose up
docker ps

# Wait untill all containers are up 
#Generate httpd Access Logs
for i in `seq 1 20`; do curl http://localhost:80/; done


#Confirm Logs from Kibana
Please go to http://localhost:5601/ with your browser. 
Then, you need to set up the index name pattern for Kibana. Please specify fluentd-* to Index name or pattern and press Create button.
Then, go to Discover tab to seek for the logs. As you can see, logs are properly collected into Elasticsearch + Kibana, via Fluentd.


# Refferences
https://docs.fluentd.org/v0.12/articles/quickstart







Deployed Vm and corresponding components on Azure using terraform code contents in azure_provsioner.tf 


Deployed prometheus docker container 

docker run -d -p 9090:9090 --user 111:116 --net=host -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v /data/prometheus:/data/prometheus prom/prometheus --config.file="/etc/prometheus/prometheus.yml" --storage.tsdb.path="/data/prometheus"



Deployed Node-exporter to ship metrics to grafana : 

docker run -d -p 9100:9100 --user 995:995 \
-v "/:/hostfs" \
--net="host" \
prom/node-exporter \
--path.rootfs=/hostfs

Deployed grafana Dashboard : 

docker run -d -p 3000:3000 --net=host grafana/grafana:8.4.4




Prometheus dashboard can be accessed from http://40.113.122.179/:9090/targets

Grafana dashboard can be accessed from http://40.113.122.179/:3000/

user: admin
password: admin 

for weather API i can pretty much use 
grafana-cli plugins install meteostat-meteostat-datasource
and get the API key from the client and retrive the data and process it on node exporter metrics to get a historical data for the same. 

Time being i'm unable to get the API key from the client to get this imlemented but this is the implementation plan. 



Docker version :  Version:           20.10.13 

Grafana version : grafana/grafana:8.4.4

Promethues : 2.34 



##/bin/bash

sudo docker run -p 9390:9090 --user 111:116 -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v prometheusdata:/data/prometheus prom/prometheus --config.file="/etc/prometheus/prometheus.yml" --storage.tsdb.path="/data/prometheus"




sudo docker run -d -p 9090:9090 --user 111:116 --net=host -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v /data/prometheus:/data/prometheus prom/prometheus --config.file="/etc/prometheus/prometheus.yml" --storage.tsdb.path="/data/prometheus"


sudo useradd -rs /bin/false prometheus
sudo mkdir /etc/prometheus
cd /etc/prometheus/ && sudo touch prometheus.yml
sudo mkdir -p /data/prometheus
sudo chown prometheus:prometheus /data/prometheus /etc/prometheus/*


cat >> # A scrape configuration scraping a Node Exporter and the Prometheus server
# itself.
scrape_configs:
  # Scrape Prometheus itself every 10 seconds.
  - job_name: 'prometheus'
    scrape_interval: 10s
    static_configs:
      - targets: ['localhost:9090']


##verify user id from /etc/passwd | grep prometheus
##Docker run for prometheus 

docker run -d -p 9090:9090 --user 111:116 --net=host -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v /data/prometheus:/data/prometheus prom/prometheus --config.file="/etc/prometheus/prometheus.yml" --storage.tsdb.path="/data/prometheus"



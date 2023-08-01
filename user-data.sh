#!/bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu
mkdir /home/ubuntu/nuvolar
cat <<EOF > /home/ubuntu/nuvolar/docker-compose.yml
services:
  api-gateway:
    image: nuvolar/api-gateway
    environment:
      ORDER_SERVICE_URL: http://order-service:8080
    ports:
      - 8080:8080
    restart: always
  order-service:
    image: nuvolar/order-service
    environment:
      CUSTOMER_SERVICE_URL: http://customer-service:8080
    restart: always
  customer-service:
    image: nuvolar/customer-service
    restart: always
EOF
cd /home/ubuntu/nuvolar
docker compose up -d

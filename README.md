# Prueba Nuvolar

## Requisitos previos

* make
* docker
* perfil AWS configurado (.aws/config y .aws/credentials)
* ssh
* curl

## Despliegue infraestructura

 ```bash
 make apply AWS_PROFILE=Nombre_Perfil_AWS
 ```

 En el resultado obtendremos los comandos necesarios para validar el funcionamiento (valores de ejemplo)

```bash
nuvolar-ssh = "ssh -i cloud-keys/nuvolar.pem ubuntu@18.135.123.139"
nuvolar-web = "curl https://d3jde9m3g43pm6.cloudfront.net/order"
```

## Validación infraestructura

Con los datos obtenidos del punto anterior podremos realizar las pruebas

```bash
curl https://d3jde9m3g43pm6.cloudfront.net/order
{"id":1,"customerId":1,"amount":80.0}
```

Tambíen podemos acceder al equipo para comprobar el estado de los contenedores docker desplegados con docker compose

```bash
$ ssh -i cloud-keys/nuvolar.pem ubuntu@18.135.123.139
$ docker ps 
CONTAINER ID   IMAGE                      COMMAND              CREATED         STATUS         PORTS                                       NAMES
0a4362c5c29e   nuvolar/api-gateway        "/cnb/process/web"   7 minutes ago   Up 7 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   nuvolar-api-gateway-1
a284c52f10fa   nuvolar/order-service      "/cnb/process/web"   7 minutes ago   Up 7 minutes                                               nuvolar-order-service-1
aac2f1fad24a   nuvolar/customer-service   "/cnb/process/web"   7 minutes ago   Up 7 minutes                                               nuvolar-customer-service-1
```

## Limpieza

Para eliminar los recursos simplemente ejecutar

```bash
make destroy
```

Confirmar y esperar que termine la destrucción de los recursos

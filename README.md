# Descripción
Proyecto para desplegar las aplicaciones a producción en un servidor usando [Docker](https://www.docker.com/), con [Traefik](https://doc.traefik.io/traefik/) se configura el reverse proxy para el redireccionamiento a los contenedores usando los dominios y el [Let's encrypt](https://doc.traefik.io/traefik/https/acme/) configurado para cada uno, por ejemplo el contenedor que tiene el codigo [ubicor-api](https://github.com/CrissAlvarezH/ubicor-api) tiene el dominio `api.ubicor.alvarezcristian.com` configurado en el `docker-compose.yaml`.

# ¿Que servicios contiene este repo?

### 1. Ubicor 
Ubicor es un proyecto para presentar y ubicar los bloques y salones de las universidades en el mapa, para mas información puede consultar [ubicor-api](https://github.com/CrissAlvarezH/ubicor-api) y [ubicor-frontend](https://github.com/CrissAlvarezH/ubicor-frontend).

### 2. Base de datos en Postgres
Para la persistencia de datos, se usa la imagen de docker [postgres:14-alpine](https://hub.docker.com/_/postgres?tab=description)

### 3. Proxy reverse
Para el proxy reverse encargado del routing, lets encrypt, middleware, etc. se usa [Traefik](https://doc.traefik.io/traefik/)

### 4. Backups automaticos
Se realizan backups a las bases de datos y a los archivos estaticos de los proyectos que corren bajo este repositorio, por ejemplo, la base de datos de ubicor-api y las imagenes de los bloques universitarios. Estos archivos son comprimidos y enviados a un bucket en [aws s3](https://aws.amazon.com/es/s3/?trk=5970b1e9-218b-48cc-9862-f23c151d81b2&sc_channel=ps&sc_campaign=acquisition&sc_medium=ACQ-P%7CPS-GO%7CBrand%7CDesktop%7CSU%7CStorage%7CS3%7CLATAMO%7CES%7CText&s_kwcid=AL!4422!3!590443989054!e!!g!!aws%20s3&ef_id=CjwKCAjwquWVBhBrEiwAt1KmwmH9LR8Z8P10kUoeAqpEHmV73byIT5IW3ZKkBnGjkyHrj8fvUgHY9xoCJs4QAvD_BwE:G:s&s_kwcid=AL!4422!3!590443989054!e!!g!!aws%20s3).
Para este proceso usamos la imagen docker del proyecto en github [automate-backups-to-s3](https://github.com/CrissAlvarezH/dockerfiles/tree/main/automate-backups-to-s3), el cual podemos encontrar en docker hub [aquí](https://hub.docker.com/r/crissalvarezh/automate-backups-to-s3)

# Desplegar

A continuación se enumeran los pasos para realizar el despliegue de los proyectos usando este repositorio

### Configurar las variables de entorno
Algunas imagenes de docker requiren variables de entorno, para esto hay que crear un .env correspondiente a cada servicio. Dentro de la carpeta `.env-services.example` veremos los .env de ejemplo para crear las versiones de producción, esto se puede hacer a mano pero lo indicado es utilizar el script creado para esto, este script se encarga de generar las contraseñas y demas secretos que se alojan en los .env.

```
make generate-env
```

###  Iniciar los contenedores
Para iniciar los contenedores se utiliza [docker compose](https://docs.docker.com/compose/), para esto corremos el siguiente comando:

```
make start
```

# Configurar hosts
En caso de que los pasos anteriores se estén realizando para hacer pruebas locales será necesario modificar el archivo de *hosts* en el computador para el correcto funcionamiento de los dominios configurados en el `docker-compose.yaml`. 
Dependiendo del sistema operativo este archivo tiene distinta ubicación:

 - **windows** `C:\Windows\System32\drivers\etc\hosts`
 - **linux** y **mac** `/etc/hosts`
 
La edición de este archivo consiste en agregar estas dos lineas al final

    127.0.0.1 ubicor.alvarezcristian.com
    127.0.0.1 api.ubicor.alvarezcristian.com

> Nota: a medida que se agreguen nuevos proyectos tambien será necesario agregar mas dominios al archivo *hosts*

### :heartbeat: ¡Y LISTO, YA TENEMOS LOS PROYECTOS CORRIENDO! :heartbeat:

# Actualizar versiones
Cuando se lance una nueva versión de algunas de las imagenes que tenemos en el `docker-compose.yaml` podemos ejecutar el siguiente comando para hacer un despliegue a las ultimas versiónes

```
make update
```

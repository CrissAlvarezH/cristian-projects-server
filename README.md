# Descripción
Proyecto para desplegar las aplicaciones a producción en un servidor usando [Docker](https://www.docker.com/), con [Traefik](https://doc.traefik.io/traefik/) se configura el reverse proxy para el redireccionamiento a los contenedores usando los dominios y el [Let's encrypt](https://doc.traefik.io/traefik/https/acme/) configurado para cada uno, por ejemplo el contenedor que tiene el codigo [ubicor-api](https://github.com/CrissAlvarezH/ubicor-api) tiene el dominio `api.ubicor.alvarezcristian.com` configurado en el `docker-compose.yaml`, para tener el codigo de los demas repositorios se utilizan [submodulos de git](https://git-scm.com/book/en/v2/Git-Tools-Submodules).


# Desplegar

A continuación se enumeran los pasos para realizar el despliegue de los proyectos usando este repositorio

### Iniciar y descargar los submodulos
Como cada proyecto a desplegar está en forma de [submodulo de git](https://git-scm.com/book/en/v2/Git-Tools-Submodules) es necesario, despues de clonar el repo, iniciarlos y actualizarlos para descargar el codigo de todos los submodulos.

	# clonamos el repositorio
    git clone https://github.com/CrissAlvarezH/cristian-projects-server

	# inicializamos y descargamos el codigo de los submodulos
    git submodule init
    git submodule update
    
> Nota: es posible que se necesite estar autenticado por ssh para descargar los submodulos

### Variables de entorno
Para cada proyecto se tiene un archivo de variables de entorno, la carpeta `.env-services.example` contiene un template de estos archivos con valores de prueba, por lo que debemos copiar esta carpeta y cambiar los valores de las variables de entorno de cada servicio, si solo se desea hacer una prueba con copiar el archivo y renombrar a `.env-services` será suficiente ya que los valores por defecto que tiene son completamente funcionales.

	# copiamos la carpeta de ejemplo y renombramos
    cp .env-services.example .env-services
    
Luego podemos configurar las variables de entorno que usará **docker compose** para la construcción de los contenedores, el procedimiento es el mismo y el archivo de ejemplo es `.env.example` y este no es del todo necesario usarlo ya que se pueden manejar los valores por defecto por motivos de pruebas.

###  Iniciar los contenedores
Para iniciar los contenedores se utiliza [docker compose](https://docs.docker.com/compose/), dentro del script `start.sh` podemos encontrar todos los comandos necesarios para construir y levantar el servidor, por lo que el paso siguiente es correr dicho script.

    # iniciamos la construcción y lanzamiento del servidor
    sh start.sh

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

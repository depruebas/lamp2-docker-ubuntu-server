Entorno de desarrollo LAMP dockerizado.

Tres servidores separados Apache2+PHP, MySql y PostgreSQL estos dos últimos tambien en servidores Ubuntu server 24.04, no como servicios docker.

Tiene un Makefile para ejecurlos contenedores desde el terminal:

```
Available commands:"                                                        
make all      			  - Create network and start Apache2, MySql & PostgreSQL containers
make create_network 	- Create the Docker network if it doesn't already exist
make apache2  			  - Start Apache2 PHP container
make mysql    			  - Start MySql container
make postgresql		    - Start PostgreSQL container
make stop 				    - Stop all container
make Down 				    - Stop and remove all container
make my			    	    - Enter into MySql Ubuntu Shell
make pg 				      - Enter into postgreSQL Ubuntu Shell
make help     			  - Show this help message
```

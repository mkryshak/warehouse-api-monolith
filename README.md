# warehouse-api-monolith
This project is an example warehouse API that can be used for demos and proof of concepts. Please note this API was not built for high scalability.

## Installation ##
1. Clone the *warehouse-api-monolith* repo:
   
   ```
   git clone https://github.com/mkryshak/warehouse-api-monolith.git
   cd warehouse-api-monolith
   ```
   
2. Build the NGINX Unit base container image:
   
   ```
   docker build --file ./nginx-unit/Dockerfile --tag <namespace>/nginx-unit:1.17 ./nginx-unit
   ```
   
3. Configure and initialize the warehouse database with pre-loaded data:
   
   ```
   docker build --file ./mysql/Dockerfile --tag <namespace>/warehouse-api:database ./mysql
   ```
   The username and password are configured as *root/root* in the ./mysql/Dockerfile file as environment variables
   ```
   FROM mysql/mysql-server:5.7
   
   LABEL maintainer="Matt Kryshak <matt.kryshak@nginx.com>"
   
   ENV MYSQL_USER=root \
	    MYSQL_ROOT_PASSWORD=root
   
   COPY init /docker-entrypoint-initdb.d
   
   EXPOSE 3306 33060
   
   CMD ["mysqld"]
   ```

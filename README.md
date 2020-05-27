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
   
   The username and password are configured as *root/root* in the *./mysql/Dockerfile* file as environment variables:
   
   ```
   FROM mysql/mysql-server:5.7
   
   ENV MYSQL_USER=root \
       MYSQL_ROOT_PASSWORD=root
   
   COPY init /docker-entrypoint-initdb.d
   
   EXPOSE 3306 33060
   
   CMD ["mysqld"]
   ```
   
   Any changes to the default username and password require a similar change to the *./mysql/init/init_db.sql* file:
   
   ```
   GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';
   FLUSH PRIVILEGES;
   ```
   
   Data can be pre-loaded using the *./mysql/init/db-warehouse.sql* file.
   
4. Build the *warehouse-api* application container image:
   - Update the *./warehouse-api/Dockerfile* file to use the NGINX Unit container image created in Step 1.
   - The hostname of the database container used by the *warehouse-api* application is stored in the *./warehouse-api/www/config.json* file
   - The default SSL certificate uses the hostname "warehouse-api.nginx.net"
   - To use a custom SSL certificate key, contatenate the certificate and key files together:
     ```cat <certificate_file> <key_file> ./warehouse-api/tls/<hostname>```
     
   

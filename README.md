# warehouse-api-monolith
This project is an example warehouse API that can be used for demos and proof of concepts. Please note this API was not built for high scalability.

## Installation ##
1. Clone the *warehouse-api-monolith* repo:
   
   ```
   git clone https://github.com/mkryshak/warehouse-api-monolith.git
   cd warehouse-api-monolith
   ```
   <br>
2. Build the NGINX Unit base container image:
   
   ```
   docker build --file ./nginx-unit/Dockerfile --tag <namespace>/nginx-unit:1.17 ./nginx-unit
   ```
   <br>
3. Configure and initialize the warehouse database with pre-loaded data:
   
   ```
   docker build --file ./mysql/Dockerfile --tag <namespace>/warehouse-api:database ./mysql
   ```
   
   ***Notes:***   
   The default username and password are configured as *root/root*. To specify a new username and password, modify the *./mysql/Dockerfile* file accordingly:
   
   ```
   FROM mysql/mysql-server:5.7
   
   ENV MYSQL_USER=<new_username> \
       MYSQL_ROOT_PASSWORD=<new_password>
   
   COPY init /docker-entrypoint-initdb.d
   
   EXPOSE 3306 33060
   
   CMD ["mysqld"]
   ```
   
   Any changes to the default username and password require a similar change to the *./mysql/init/init_db.sql* file:
   
   ```
   GRANT ALL PRIVILEGES ON *.* TO '<new_username>'@'%' IDENTIFIED BY '<new_password>';
   FLUSH PRIVILEGES;
   ```
   
   And to the *./warehouse-api/www/config.json* file:
   
   ```
   {
       "mysql": {
           "server": {
               "host": "warehouse-api-database",
               "port": "3306"
           },
           "username": "<new_username>",
           "password": "<new_password>"
       }
   }
   ```
   
   Data can be pre-loaded into the database at build time using the *./mysql/init/db-warehouse.sql* file.   
   <br>
4. Build the *warehouse-api* application container image:
   
   Update the *./warehouse-api/Dockerfile* file to refer to the NGINX Unit container image created in step one, then build the container image:
   
   ```
   docker build --file ./warehouse-api/Dockerfile --tag <namespace>/warehouse-api:monolith ./warehouse-api
   ```
   
   **Notes:**
     - The hostname of the database container used by the *warehouse-api* application is stored in the *./warehouse-api/www/config.json* file
     - The default SSL certificate uses the hostname "warehouse-api.nginx.net"
     - To use a custom SSL certificate key, contatenate the certificate and key files together:
       
       ```cat <certificate_file> <key_file> ./warehouse-api/tls/<hostname>```
       
     - Update the *./warehouse-api/unit/conf.json* file to reflect the new concatenated certificate and key file name:
       
       ```
       "listeners": {
           "*:80": {
           "pass": "applications/monolith"
       },
       "*:443": {
           "pass": "applications/monolith",
           "tls": {
               "certificate": "<new_file_name>"
           }
       }
       ```
       
5. 

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
   <br>
   
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
4. Update the *./warehouse-api/Dockerfile* file to reflect the NGINX Unit container image name created in step one:
   
   ```
   FROM <namespace>/nginx-unit:1.17
   ```
   <br>
5. Build the *warehouse-api* application container image:
   
   ```
   docker build --file ./warehouse-api/Dockerfile --tag <namespace>/warehouse-api:monolith ./warehouse-api
   ```
   <br>
   
   ***Notes:***
   - The hostname of the database container used by the *warehouse-api* application is stored in the *./warehouse-api/www/config.json* file. Modify as necessary.
   - The default SSL certificate uses the hostname "warehouse-api.nginx.net"
   - To use a custom SSL certificate and key, contatenate the certificate and key files together:
     
     ```cat <certificate_file> <key_file> ./warehouse-api/tls/<hostname>```
       
   - Update the *./warehouse-api/unit/conf.json* file to reflect the newly concatenated certificate/key file name:
     
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
     <br>  
6. Bring up the containers:
   
   ```
   docker-compose up -d
   ```

## API Specification ##
The *warehouse-api* application accepts both HTTP and HTTPS traffic on ports 80 and 443, respectively.  The default URI prefix is `/api/v1/warehouse` (this can be changed).

The following URIs will accept `GET` requests to fetch product information:
- `/api/v1/warehouse/product`
- `/api/v1/warehouse/prodcut/{sku}`
- `/api/v1/warehouse/product/description/{sku}`
- `/api/v1/warehouse/product/inventory/{sku}`
- `/api/v1/warehouse/product/price/{sku}`
- `/api/v1/warehouse/product/rating/{sku}`

\*\* `{sku}` represents the SKU ID (integer) of a specific product
<br>
The following URIs will accept `POST` requests to create products:
- `/api/v1/warehouse/product/{sku}`
\*\* The request body must contain the information about the product being created. Use a `GET` request from `/api/v1/warehouse/product/{sku}` as a template and remove the `created` and `updated` fields.
<br>
The following URIs will accept `PATCH` requests to update specific information about a product:
- `/api/v1/warehouse/product/description/{sku}`
- `/api/v1/warehouse/product/inventory/{sku}`
- `/api/v1/warehouse/product/price/{sku}`
- `/api/v1/warehouse/product/rating/{sku}`
<br>
The following URIs will accept `PUT` requests to update all information about a product:
- `/api/v1/warehouse/product/{sku}`

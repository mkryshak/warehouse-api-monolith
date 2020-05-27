FROM mysql/mysql-server:5.7

ENV MYSQL_USER=root \
	MYSQL_ROOT_PASSWORD=root

COPY init /docker-entrypoint-initdb.d

EXPOSE 3306 33060

CMD ["mysqld"]

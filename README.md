## xxl-job-puls
1. xxl-job support the database type: OpenGauss、GaussDB、DM、MariaDB、PostgreSQL、Oracle、SQLServer,
2. xxl-job支持多种数据库

## docker镜像启动
1. 拉取镜像
```shell
docker pull xxnzx/xxl-job-plus
```
2. 启动容器
```shell
docker run -d -e DB_URL='jdbc:postgresql://127.0.0.1:5432/xxl_job' \
        -e DB_USERNAME='gaussdb' \
        -e DB_PASSWORD='123456' \
        -e DB_DRIVER_CLASS_NAME='org.postgresql.Driver' \
        --name xxl-job-plus -p 8080:8080 xxnzx/xxl-job-plus
```
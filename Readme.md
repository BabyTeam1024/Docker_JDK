
# 0x01 设计思路
为了快速搭建jdk环境，采用docker自动化部署的方式进行，将想要安装版本JDK的安装包放在特定的目录下，执行sh脚本完成环境变量初始化及docker image构建。

为了灵活应对各个JDK版本的区别，全部采用变量的形式进行参数传递，每步参数可以通过控制终端查看。

## 0x1 目录结构

``` 
├── docker-compose.yml
├── dockerfile
├── JdkDockerBuild.sh
├── jdk_pkg
│   ├── jdk-11.0.9_linux-x64_bin.tar.gz
│   ├── jdk-8u121-linux-x64.tar.gz
│   └── jdk-8u231-linux-x64.tar.gz
└── jdk_use
    └── jdk-11.0.9_linux-x64_bin.tar.gz

```
## 0x2 基本步骤
1. 在jdk_use文件夹中放入一个jdk压缩包（这里只能放一个）
2. 执行 JdkDockerBuild.sh 脚本初始化 .env 变量
3. 执行 docker-compose up -d 创建容器

# 0x02 具体实现

## 0x1 环境变量初始化

``` bash
#!/bin/bash
jdk=`ls jdk_use|head -n 1`
tempjdkpath=`tar -tf jdk_use/$jdk | head -n 1`
jdkpath=${tempjdkpath%/*}
echo "jdk=$jdk" > .env
echo "jdkpath=$jdkpath" >> .env
docker-compose build
```

## 0x2 docker 构建
docker-compose的配置需要注意几点
1. 环境变量由JdkDockerBuild.sh设置，从.env文件中获取
2. 设置tty 参数，是的容器运行后不闪退
3. 给dockerfile的参数由args 传递


docker-compose.yml 
``` yml
version: '3'
services:
 jdk:
   build:
    context: .
    args:
      JDK: ${jdk}
      JDKPATH: ${jdkpath}
   tty: true
```


----------
前面docker-compose.yml context 设置为. images将会在当前文件夹的dockerfile的配置影响下生成。

``` dockerfile
FROM ubuntu:18.04
MAINTAINER 4ct10n
ARG JDK
ARG JDKPATH
RUN mkdir -p /opt/jdk
ADD jdk_pkg/$JDK /opt/jdk/
ENV JAVA_HOME /opt/jdk/$JDKPATH
ENV PATH $PATH:$JAVA_HOME/bin
```

# 0x3 JDK 资源

将所有的jdk资源存储在jdk_pkg，在使用单个的jdk资源时复制到jdk_use 文件夹中

![](https://graph.baidu.com/resource/2215c2f26ffd8efb7a81f01605349549.jpg)


# 0x4 使用步骤

``` 
git clone https://github.com/BabyTeam1024/Docker_JDK.git
cd Docker_JDK
./JdkDockerBuild.sh
docker-compose up -d 
```

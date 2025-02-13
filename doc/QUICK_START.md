### 1. SQLAdvisor安装

#### 1.1 拉取最新代码
```
git clone https://github.com/jiangfengbing/SQLAdvisor.git
```

#### 1.2 安装依赖项

```
sudo apt install cmake libaio-dev libffi-dev libglib2.0-dev libglib2.0-bin

wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/stretch/x86_64/percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb
wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/stretch/x86_64/libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb
wget https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/stretch/x86_64/libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb

sudo dpkg -i percona-server-common-5.6_5.6.45-86.1-1.stretch_amd64.deb
sudo dpkg -i libperconaserverclient18.1_5.6.45-86.1-1.stretch_amd64.deb
sudo dpkg -i libperconaserverclient18.1-dev_5.6.45-86.1-1.stretch_amd64.deb
sudo apt --fix-broken install
```

如果是ubuntu，将`libglib2.0-bin`替换为`libglib2.0-dev-bin`，Percona-Server的URL替换为:

```
https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/bionic/x86_64/libperconaserverclient18.1-dev_5.6.45-86.1-1.bionic_amd64.deb
https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/bionic/x86_64/percona-server-common-5.6_5.6.45-86.1-1.bionic_amd64.deb
https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.45-86.1/binary/debian/bionic/x86_64/libperconaserverclient18.1_5.6.45-86.1-1.bionic_amd64.deb
```

#### 1.3 编译依赖项sqlparser

```
0. mkdir build; cd build
1. cmake -DBUILD_CONFIG=mysql_release -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/usr/local/sqlparser ..
2. make -j8 && sudo make install
```

**注意**

1. DCMAKE_INSTALL_PREFIX为sqlparser库文件和头文件的安装目录，其中lib目录包含库文件libsqlparser.so，include目录包含所需的所有头文件。
2. DCMAKE_INSTALL_PREFIX值尽量不要修改，后面安装依赖这个目录。

#### 1.4 安装SQLAdvisor源码

```
0. cd SQLAdvisor/sqladvisor/
1. mkdir build; cd build
2. cmake -DCMAKE_BUILD_TYPE=debug ..
3. make -j8
4. 在本路径下生成一个sqladvisor可执行文件，这即是我们想要的。
```

### 2. SQLAdvisor使用
#### 2.1 --help输出
```
./sqladvisor --help
Usage:
  sqladvisor [OPTION...] sqladvisor

SQL Advisor Summary

Help Options:
  -?, --help              Show help options

Application Options:
  -f, --defaults-file     sqls file
  -u, --username          username
  -p, --password          password
  -P, --port              port
  -h, --host              host
  -d, --dbname            database name
  -q, --sqls              sqls
  -v, --verbose           1:output logs 0:output nothing
```
#### 2.2 命令行传参调用
```
./sqladvisor -h xx  -P xx  -u xx -p 'xx' -d xx -q "sql" -v 1
```
#####注意：命令行传参时，参数名与值需要用空格隔开

#### 2.3 配置文件传参调用

```
$> cat sql.cnf
[sqladvisor]
username=xx
password=xx
host=xx
port=xx
dbname=xx
sqls=sql1;sql2;sql3....

cmd: ./sqladvisor -f sql.cnf  -v 1
```

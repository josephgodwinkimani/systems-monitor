#!/usr/bin/env bash

IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
DISTRO=`cat /etc/*-release | grep "^ID=" | grep -E -o "[a-z]\w+"`
VERSION=`lsb_release --release | cut -f2 | cut -c 1`

echo "Your operating system is $DISTRO"

if [ "$DISTRO" = "almalinux" ]; then

    if [ ! "$VERSION"]; then

       yum install redhat-lsb-core
       echo "Your $DISTRO version is $VERSION"
    else
       echo "Your $DISTRO version is $VERSION"
    fi

    if [ "$VERSION" = "8" ]; then
    
      echo "Installing zabbit ... "
      rpm -Uvh https://repo.zabbix.com/zabbix/6.2/rhel/8/x86_64/zabbix-release-6.2-3.el8.noarch.rpm
      dnf clean all
      dnf module switch-to php:7.4
      dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent
      echo "What is the password to your mysql root user? (e.g password) "
      read ROOTPASSWORD
      echo "Creating your zabbit database ... "
      mysql --user="root" --password="$ROOTPASSWORD" --execute="create database zabbix character set utf8mb4 collate utf8mb4_bin;"
      echo "Create a password for your zabbit database? (e.g password) "
      read PASSWORD
      mysql --user="root" --password="$ROOTPASSWORD" --database="zabbix" --execute="create user zabbix@localhost identified by '$PASSWORD';"
      mysql --user="root" --password="$ROOTPASSWORD" --execute="grant all privileges on zabbix.* to zabbix@localhost;  set global log_bin_trust_function_creators = 1;"
      zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
      mysql --user="root" --password="$ROOTPASSWORD" --execute="set global log_bin_trust_function_creators = 0;"
      sudo tee /etc/zabbix/zabbix_server.conf <<"EOF"
      DBPassword=password
      EOF
      systemctl restart zabbix-server zabbix-agent httpd php-fpm
      systemctl enable zabbix-server zabbix-agent httpd php-fpm      
      echo "The default URL for Zabbix UI when using Apache web server is http://$IP/zabbix"
    else
       echo "Sorry you will have to install manually - https://www.zabbix.com/download"
    fi

elif [ "$DISTRO" = "rockylinux" ]; then

    if [ ! "$VERSION"]; then

       yum install redhat-lsb-core
       echo "Your $DISTRO version is $VERSION"
    else
       echo "Your $DISTRO version is $VERSION"
    fi

    if [ "$VERSION" = "8" ]; then
    
      echo "Installing zabbit ... "
      rpm -Uvh https://repo.zabbix.com/zabbix/6.2/rhel/8/x86_64/zabbix-release-6.2-3.el8.noarch.rpm
      dnf clean all
      dnf module switch-to php:7.4
      dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent
      echo "What is the password to your mysql root user? (e.g password) "
      read ROOTPASSWORD
      echo "Creating your zabbit database ... "
      mysql --user="root" --password="$ROOTPASSWORD" --execute="create database zabbix character set utf8mb4 collate utf8mb4_bin;"
      echo "Create a password for your zabbit database? (e.g password) "
      read PASSWORD
      mysql --user="root" --password="$ROOTPASSWORD" --database="zabbix" --execute="create user zabbix@localhost identified by '$PASSWORD';"
      mysql --user="root" --password="$ROOTPASSWORD" --execute="grant all privileges on zabbix.* to zabbix@localhost;  set global log_bin_trust_function_creators = 1;"
      zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
      mysql --user="root" --password="$ROOTPASSWORD" --execute="set global log_bin_trust_function_creators = 0;"
      sudo tee /etc/zabbix/zabbix_server.conf <<"EOF"
      DBPassword=password
      EOF
      systemctl restart zabbix-server zabbix-agent httpd php-fpm
      systemctl enable zabbix-server zabbix-agent httpd php-fpm      
      echo "The default URL for Zabbix UI when using Apache web server is http://$IP/zabbix"
    else
       echo "Sorry you will have to install manually - https://www.zabbix.com/download"
    fi
    
elif [ "$DISTRO" = "centos" ]; then

    if [ ! "$VERSION"]; then

       yum install redhat-lsb-core
       echo "Your $DISTRO version is $VERSION"
    else
       echo "Your $DISTRO version is $VERSION"
    fi

    if [ "$VERSION" = "8" ]; then
    
      echo "Installing zabbit ... "
      rpm -Uvh https://repo.zabbix.com/zabbix/6.2/rhel/8/x86_64/zabbix-release-6.2-3.el8.noarch.rpm
      dnf clean all
      dnf module switch-to php:7.4
      dnf install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent
      echo "What is the password to your mysql root user? (e.g password) "
      read ROOTPASSWORD
      echo "Creating your zabbit database ... "
      mysql --user="root" --password="$ROOTPASSWORD" --execute="create database zabbix character set utf8mb4 collate utf8mb4_bin;"
      echo "Create a password for your zabbit database? (e.g password) "
      read PASSWORD
      mysql --user="root" --password="$ROOTPASSWORD" --database="zabbix" --execute="create user zabbix@localhost identified by '$PASSWORD';"
      mysql --user="root" --password="$ROOTPASSWORD" --execute="grant all privileges on zabbix.* to zabbix@localhost;  set global log_bin_trust_function_creators = 1;"
      zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
      mysql --user="root" --password="$ROOTPASSWORD" --execute="set global log_bin_trust_function_creators = 0;"
      sudo tee /etc/zabbix/zabbix_server.conf <<"EOF"
      DBPassword=password
      EOF
      systemctl restart zabbix-server zabbix-agent httpd php-fpm
      systemctl enable zabbix-server zabbix-agent httpd php-fpm      
      echo "The default URL for Zabbix UI when using Apache web server is http://$IP/zabbix"
    else
       echo "Sorry you will have to install manually - https://www.zabbix.com/download"
    fi

elif [ "$DISTRO" = "ubuntu" ]; then

    if [ "$VERSION" = "22" ]; then
    
      echo "Installing zabbit ... "
      wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu22.04_all.deb
      sudo dpkg -i zabbix-release_6.2-4+ubuntu22.04_all.deb
      sudo apt update
      sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
      echo "What is the password to your mysql root user? (e.g password) "
      read ROOTPASSWORD
      echo "Creating your zabbit database ... "
      mysql --user="root" --password="$ROOTPASSWORD" --execute="create database zabbix character set utf8mb4 collate utf8mb4_bin;"
      echo "Create a password for your zabbit database? (e.g password) "
      read PASSWORD
      mysql --user="root" --password="$ROOTPASSWORD" --database="zabbix" --execute="create user zabbix@localhost identified by '$PASSWORD';"
      mysql --user="root" --password="$ROOTPASSWORD" --execute="grant all privileges on zabbix.* to zabbix@localhost;  set global log_bin_trust_function_creators = 1;"
      zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
      mysql --user="root" --password="$ROOTPASSWORD" --execute="set global log_bin_trust_function_creators = 0;"
      sudo tee /etc/zabbix/zabbix_server.conf <<"EOF"
      DBPassword=password
      EOF
      systemctl restart zabbix-server zabbix-agent apache2
      systemctl enable zabbix-server zabbix-agent apache2      
      echo "The default URL for Zabbix UI when using Apache web server is http://$IP/zabbix"
      
    elif [ "$VERSION" = "20" ]; then
    
      echo "Installing zabbit ... "
      wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu20.04_all.deb
      sudo dpkg -i zabbix-release_6.2-4+ubuntu20.04_all.deb
      sudo apt update
      sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
      echo "What is the password to your mysql root user? (e.g password) "
      read ROOTPASSWORD
      echo "Creating your zabbit database ... "
      mysql --user="root" --password="$ROOTPASSWORD" --execute="create database zabbix character set utf8mb4 collate utf8mb4_bin;"
      echo "Create a password for your zabbit database? (e.g password) "
      read PASSWORD
      mysql --user="root" --password="$ROOTPASSWORD" --database="zabbix" --execute="create user zabbix@localhost identified by '$PASSWORD';"
      mysql --user="root" --password="$ROOTPASSWORD" --execute="grant all privileges on zabbix.* to zabbix@localhost;  set global log_bin_trust_function_creators = 1;"
      zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
      mysql --user="root" --password="$ROOTPASSWORD" --execute="set global log_bin_trust_function_creators = 0;"
      sudo tee /etc/zabbix/zabbix_server.conf <<"EOF"
      DBPassword=password
      EOF
      systemctl restart zabbix-server zabbix-agent apache2
      systemctl enable zabbix-server zabbix-agent apache2      
      echo "The default URL for Zabbix UI when using Apache web server is http://$IP/zabbix"    
    
    else
       echo "Sorry you will have to install manually - https://www.zabbix.com/download"
    fi

elif [ "$DISTRO" = "debian" ]; then

    if [ "$VERSION" = "11" ]; then
    
      echo "Installing zabbit ... "
      wget https://repo.zabbix.com/zabbix/6.2/debian/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bdebian11_all.deb
      sudo dpkg -i zabbix-release_6.2-4+debian11_all.deb
      sudo apt update
      sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
      echo "What is the password to your mysql root user? (e.g password) "
      read ROOTPASSWORD
      echo "Creating your zabbit database ... "
      mysql --user="root" --password="$ROOTPASSWORD" --execute="create database zabbix character set utf8mb4 collate utf8mb4_bin;"
      echo "Create a password for your zabbit database? (e.g password) "
      read PASSWORD
      mysql --user="root" --password="$ROOTPASSWORD" --database="zabbix" --execute="create user zabbix@localhost identified by '$PASSWORD';"
      mysql --user="root" --password="$ROOTPASSWORD" --execute="grant all privileges on zabbix.* to zabbix@localhost;  set global log_bin_trust_function_creators = 1;"
      zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
      mysql --user="root" --password="$ROOTPASSWORD" --execute="set global log_bin_trust_function_creators = 0;"
      sudo tee /etc/zabbix/zabbix_server.conf <<"EOF"
      DBPassword=password
      EOF
      systemctl restart zabbix-server zabbix-agent apache2
      systemctl enable zabbix-server zabbix-agent apache2      
      echo "The default URL for Zabbix UI when using Apache web server is http://$IP/zabbix" 
     
    else
       echo "Sorry you will have to install manually - https://www.zabbix.com/download"
    fi

else
   echo "$DISTRO"
   echo "Sorry this is not for you"
fi

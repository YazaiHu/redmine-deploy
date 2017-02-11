#!/bin/bash
script_path=$(cd `dirname $0`;pwd)

# first you need to install mysql service 
# then execute this:
# CREATE DATABASE redmine CHARACTER SET utf8;
# CREATE USER 'redmine'@'localhost' IDENTIFIED BY '123456';
# GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'123456';

yum install -y ImageMagick-devel ImageMagick

# install ruby success，then set the ruby path to the environment
tar zxvf $script_path/ruby-2.1.10.tar.gz
cd ruby-2.1.10
./configure
make && make install

tar zxvf $script_path/redmine-3.3.2.tar.gz
cd redmine-3.3.2
# You need to modify the config file config/database.yml to set the correct config,such as mysql root ,mysql password 
gem install bundler
gem install mysql2 -v '0.3.21'

bundle install --without development test
bundle exec rake generate_secret_token
bundle exec rake db:migrate RAILS_ENV="production"

adduser remine
chown -R redmine:redmine files log tmp public/plugin_assets
chmod -R 755 files log tmp public/plugin_assets

# start remine service
/usr/local/bin/ruby bin/rails server --binding=0.0.0.0 --port=3000 --config=/data/redmine-3.3.2/config.ru --environment=production



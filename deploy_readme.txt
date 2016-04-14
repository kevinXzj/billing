1.rake db:reset RAILS_ENV=production #初始化production的数据库结构
2.rake db:seed RAILS_ENV=production #初始化初始化数据(/db/seeds.rb中添加对应的数据)
3.rake secret RAILS_ENV=production #生成proudction的密钥
4.export SECRET_KEY_BASE = "655307b5432e6846ddfb9e3bb433db9667d9bc14b8a9d4d9c9632775d82f97fd185ca060efe70aca28704112fc398c96e04142e49c7240fe6e6e755c6cbf77ca" #修改用户目录下.bashrc(或/etc/profile)文件,添加上述内容,重启电脑或者终端生效
5.rake assets:precompile RAILS_ENV=production #预编译资源文件
6.config.serve_static_files = true #默认为false(config/environments/production.rb),加载静态资源,有前端服务器(nginx)时设置成false
7.启动服务:在应用目录下 rails s -e production -b 192.168.0.80


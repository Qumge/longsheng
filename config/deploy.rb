require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm' #服务器上使用的是rvm
require './lib/recepies/bower'

#服务器地址,是使用ssh的方式登录服务器
set :domain, 'heyen@120.79.28.184' #在服务器~/.ssh/authorized_keys 里面写入你的id_rsa.pub就不用密码登录
#服务器中项目部署位置
set :deploy_to, '/opt/rails-app/longsheng-pm'
#git代码仓库
set :repository, 'git@github.com:Qumge/long-pm.git'
#git分支
set :branch, 'master'
#配置rvm位置
# set :rvm_path, '/usr/local/rvm/bin/rvm'
set :term_mode, :system

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
# If you're using rbenv, use this to load the rbenv environment.
# Be sure to commit your .ruby-version or .rbenv-version to your repository.
# invoke :'rbenv:load'
# For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.5.1]' #设置rvm ruby版本
end

# 中括号里的文件 会出现在服务器项目附录的shared文件夹中，这里加入了secrets.yml，环境密钥无需跟开发计算机一样
set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml']

# 这个块里面的代码表示运行 mina setup时运行的命令
task :setup => :environment do

  # 在服务器项目目录的shared中创建log文件夹
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  # 在服务器项目目录的shared中创建config文件夹 下同
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]

  # puma.rb 配置puma必须得文件夹及文件
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[touch "#{deploy_to}/shared/config/puma.rb"]
  queue  %[echo "-----> Be sure to edit 'shared/config/puma.rb'."]

  # tmp/sockets/puma.state
  queue! %[touch "#{deploy_to}/shared/tmp/sockets/puma.state"]
  queue  %[echo "-----> Be sure to edit 'shared/tmp/sockets/puma.state'."]

  # log/puma.stdout.log
  queue! %[touch "#{deploy_to}/shared/log/puma.stdout.log"]
  queue  %[echo "-----> Be sure to edit 'shared/log/puma.stdout.log'."]

  # log/puma.stdout.log
  queue! %[touch "#{deploy_to}/shared/log/puma.stderr.log"]
  queue  %[echo "-----> Be sure to edit 'shared/log/puma.stderr.log'."]

  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
end

#这个代码块表示运行 mina deploy时执行的命令
desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
  end
  deploy do
    #重新拉git服务器上的最新版本，即使没有改变
    invoke :'git:clone'
    #重新设定shared_path位置
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # invoke :'rails:db_create'
    queue 'bower install'
    invoke :'rails:db_migrate' #首次执行可能会报错 需要我们手动先创建数据库 db:create
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "chown -R www-data #{deploy_to}"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      queue "pumactl -F  #{deploy_to}/#{current_path}/config/puma.rb  restart" #touch好像没有效果 所以直接使用的命令重启， 重启命令参考：
    end
  end
end
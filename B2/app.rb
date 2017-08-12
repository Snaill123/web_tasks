require 'sinatra'
require 'mysql2'
require 'active_record'    
require 'digest/sha1'
require 'yaml'
#use Rack::Session::Pool, :expire_after =>120

configure do 
	enable :sessions
    dbconfig = YAML::load(File.open('database.yml'))     
    ActiveRecord::Base.establish_connection(dbconfig)     

    ActiveRecord::Schema.define do
        if !table_exists? :users
        #drop_table :users if table_exists? :users
            create_table :users do |table|
                table.column :username, :string
                table.column :password, :string
            end
        end
        if  !table_exists? :messages
        #drop_table :messages if table_exists? :messages
            create_table :messages do |table|
                table.column :content, :string
                table.column :user_id, :integer
            end
            add_foreign_key :messages, :user_id
        end
    end

    class User < ActiveRecord::Base
        self.table_name = "users"
        has_many :messages
    end
   
    class Message < ActiveRecord::Base
    	self.table_name = "messages"
        belongs_to :user
        validates :content, length: { minimum: 10 }
    end
end

get'/' do
	#如果已登录，转至首页
	if session[:admin] == true
		redirect '/start'
	else
	#否则转到登录页
		redirect '/login'
	end
end

get '/login' do
	erb :login
end

post '/login' do
    name = params[:username].to_s
    psd = params[:password].to_s
    user = User.where(:username=> name) 
    #若登录成功，转至首页
    if user[0]!= nil and Digest::SHA1.hexdigest(psd).eql?(user[0].password)
        session[:admin] = true 
        session[:admin_id] = user[0].id
    	redirect '/start'
    else
    #否则需重新登录
    	erb :login
    end
end

#退出登录
get '/logout' do
	session.clear
	redirect '/login'
end


#首页 展示已有的所有留言列表 ，根据查询的id或author参数展现相应的留言信息
get '/start' do
	if session[:admin]
	    id = params['pid'].to_s
	    author = params['pauthor'].to_s
	    if id.empty? and author.empty?
                @messages_show=Message.all
	        erb :index
	    #根据id进行搜索
	    elsif !id.empty? and author.empty?
               @messages_show = Message.where(:id=>id).order(created_at: :desc)
	        erb :index
	    #根据author进行搜索
	    else id.empty? and !author.empty?
	        #find user_id in user 
    	        users = User.where(:username=>author)
                users.each do |user|
                   @messages_show = user.messages
                end 
    	        erb :index
            end
	else
		redirect '/not_login'
	end
end


#链接到新增留言的页面
get '/add' do
    if session[:admin]
      erb :insert
    else
        redirect 'not_login'
    end
end


post '/add' do
    message = params['message'].to_s
    msg = Message.new
    msg.content = message
    #msg.created_at = Time.new
    msg.user_id = session[:admin_id].to_i
    #判断留言是否有效
    if msg.valid?
        msg.save
        redirect'/start'
    #留言无效，转至error页面
    else
        redirect '/add/error'
    end 
end

get '/add/error' do
   erb :error
end

#删除留言
get '/delete/:del_id' do
    if session[:admin]
        id = params['del_id'].to_s
        msg = Message.find_by(id: id)
        msg.destroy
        @messages_show = Message.all
        erb :delete
    else
        redirect '/not_login'
    end
end

#根据提交表单编辑留言
post '/edit' do
	id=params['id'].to_i
    message = params['message'].to_s
    #对新编辑的留言进行有效性判断
    if message.length > 10
        msg = Message.find(id)
        # msg.content = message
        # msg.created_at = Time.new
        # msg.save
        msg.update(content: message)
    	#重定向到首页
    	redirect '/start'
	else
		#留言无效
		redirect '/add/error'
	end
end

#此链接转到编辑页面
get '/edit/:id' do
    if session[:admin]
    	id = params['id'].to_i
        @message = Message.find(id)
        erb :edit
    else
        redirect '/not_login'
    end
end

get '/signup' do
    erb :signup
end

get '/signup_success' do
    erb :signup_success
end


post '/signup' do
    username = params[:username].to_s
    password = params[:password].to_s
    users_by_username = User.where(:username=>username)
    if username.length == 0 or password.length == 0
        redirect '/signup'
    elsif users_by_username.length == 0 
        user = User.new
        user.username = username
        user.password = Digest::SHA1.hexdigest(password)
        user.save
        redirect '/signup_success'
    else
       redirect '/signup_fail'
    end
end
        

get '/own' do
    if session[:admin]
        user = User.find(session[:admin_id].to_i)
        @username = user.username
        @password = user.password
        @messages_show = user.messages
        erb :own
    else
        redirect '/not_login'
    end
end  

get '/signup_fail' do
    erb :signup_fail
end

get '/not_login' do
    erb :not_login
end
get '/change' do
    erb :change
end

post '/change' do
    old_password = params[:old_password].to_s
    new_password = params[:new_password].to_s
    user= User.find(session[:admin_id].to_i)
    puts user.password
    if Digest::SHA1.hexdigest(old_password).eql? (user.password)
        user.update(password: Digest::SHA1.hexdigest(new_password))
       # user.save
        puts user.password
        redirect '/change_password_success'
    else
        redirect'/change_password_fail'
    end  
end

get '/change_password_success' do
    erb :change_password_success
end

get '/change_password_fail' do
    erb :change_password_fail
end

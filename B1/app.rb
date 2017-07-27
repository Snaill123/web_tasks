require 'sinatra'
require 'yaml'
#定义全局变量count，记录系统给每条信息的id，每次count被初始赋值为yml文件中所存留言条数，
$count = 0
#定义全局变量数组，存储从yml中解析出的message信息
$arr = []
#定义留言的数据类型
class Message
	attr_accessor :id, :author, :message, :created_at
    def initialize (id,author,message,created_at)
    	@id, @message, @author, @created_at = id, message, author, created_at     
    end    
end

#首页 展示已有的所有留言列表
get '/' do 
	if File.exists?("data.yml") 
		data = YAML.load(File.open("data.yml"))
        $arr = []
		data.each do |a|
			$arr << a
		end
	end
    erb :index
end

#链接到新增留言的页面
get '/add' do
    erb :insert
end

#
get '/id' do
	id = params['pid']
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        #将arr清零并从data.yml中导入数据
        $arr = []
        data.each do |a|
            $arr << a
        end
        #根据输入的id进行查找
        $arr.select!{ |item| item.id.to_s.eql?(id) }
        erb :id
    #尚无数据可查
    else
        "no messages now"
    end
end

get '/author' do
    author = params['pauthor'].to_s
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
         #将arr清零并从data.yml中导入数据
        $arr = []
        data.each do |a|
            $arr << a
        end
        #根据输入的author进行查找
        $arr.select!{ |item| item.author.eql?(author)}
        $arr.each {|v| puts v}
        erb :author
    #尚无数据可查
    else
        "no messages now"
    end
end

post '/add' do
    author = params['author']
    message = params['message']
    #判断留言是否有效
    if  !author.empty? and message.length >= 10
        $arr =[]
        if File.exists?("data.yml") 
            data = YAML.load(File.open("data.yml"))
            data.each do |a|
                $arr << a
            end
        end
        #count更新为当前留言条总数
        $count = $arr.length
        msg = Message.new($count,author,message,Time.new)
        $arr<<msg
        File.open("data.yml","wb") {|f| YAML.dump($arr, f) }
        redirect '/'
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
    id = params['del_id'].to_s
    puts id
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        $arr = []
        data.each do |a|
            $arr << a
        end
    end
    $arr.delete_if{|v| v.id.to_s.eql?(id)}
    #此处应及时将更新的数据存入yml文件
    File.open("data.yml","wb") {|f| YAML.dump($arr, f) }
 	erb :delete
end



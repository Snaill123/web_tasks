require 'sinatra'
require 'yaml'

#定义留言的数据类型
class Message
	attr_accessor :id, :author, :message, :created_at
    def initialize (id,author,message,created_at)
    	@id, @message, @author, @created_at = id, message, author, created_at     
    end    
end

#首页 展示已有的所有留言列表 ，根据查询的id或author参数展现相应的留言信息
get '/' do
    @arr = []
    id = params['pid'].to_s
    author = params['pauthor'].to_s

    if File.exists?("data.yml") 
		data = YAML.load(File.open("data.yml"))
	    data.each do |a|
		     @arr << a
		end
		#按时间排序还是有毛病
		#@arr.sort_by!{|a,b| a.created_at.to_i <=> b.created_at.to_i}
	end
	#展现全部
    if id.empty? and author.empty?
        erb :index
    #根据id进行搜索
	elsif !id.empty? and author.empty?
       @arr.select!{ |item| item.id.to_s.eql?(id)}
       erb :index
    #根据author进行搜索
    elsif id.empty? and !author.empty?
       @arr.select!{ |item| item.author.to_s.eql?(author)}
       erb :index
    #id和auhtor是否匹配，若匹配，返回值
    else
       if @arr.select!{ |item| item.id.to_s.eql?(id) and item.author.eql?(author)} != nil
         erb :index
       else 
         redirect '/add/error'
        end
    end
end


#链接到新增留言的页面
get '/add' do
    erb :insert
end


post '/add' do
    author = params['author']
    message = params['message']
    #判断留言是否有效
    max = 0
    if  !author.empty? and message.length >= 10
        @arr =[]
        if File.exists?("data.yml") 
            data = YAML.load(File.open("data.yml"))
            data.each do |a|
                @arr << a
                if a.id >max  
                	max=a.id
                end
            end
        end
        #count更新为当前留言条总数
        count = max+1
        msg = Message.new(count,author,message,Time.new)
        @arr<<msg
        File.open("data.yml","wb") {|f| YAML.dump(@arr, f) }
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
    @arr = []
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        data.each do |a|
            @arr << a
        end
    end
    i = @arr.length
    arr_t = []
    i.times do |i|
        if (@arr[i].id.to_s.eql?(id))
            arr_t << @arr[i]
        end
        break
    end
    File.open("data_to_trash.yml","wb") {|f| YAML.dump(arr_t, f)}  
    @arr.delete_if{|v| v.id.to_s.eql?(id)}
    #此处应及时将更新的数据存入yml文件
    File.open("data.yml","wb") {|f| YAML.dump(@arr,f) }
    erb :delete
end

#输入留言id，实现将删除的留言复原
get '/resume' do
	arr_n = []
	@arr = []
	max = 0
	id = params['pid'].to_s
	if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        data.each do |a|
            @arr << a
        end
    end
    #读取保存删除留言的yml文件
	if File.exists?("data_to_trash.yml") 
        data_to_trash = YAML.load(File.open("data_to_trash.yml"))
        data_to_trash.each do |a|
            arr_n << a
        end
    end
    #筛选出符合id的留言
    arr_n.select!{|v| v.id.to_s.eql?(id)}
    @arr << arr_n[0]
    #将此留言从删除数组中delete
    arr_n.delete_if{|v| v.id.to_s.eql?(id)}
    #考虑到删除数组可能为空，此时删除data_to_trash.yml, #否则将数组重新导入yml
    if arr_n.length > 0
       File.open("data_to_trash.yml","wb") {|f| YAML.dump(arr_n, f) }
    else
       File.delete("data_to_trash.yml")
    end
    #更新未删除的文件信息
    File.open("data.yml","wb") {|f| YAML.dump(@arr, f)}
    redirect '/'
end

#根据提交表单编辑留言
post '/edit' do
	id=params['id'].to_i
	author = params['author']
    message = params['message']
    author_n = author.to_s
    message_n = message.to_s
    @arr =[]
    #对新编辑的留言进行有效性判断
    if !author_n.empty? and message_n.length > 10
    	#从yml中读取数据
	    if File.exists?("data.yml") 
	        data = YAML.load(File.open("data.yml"))
	        data.each do |a|
	            @arr << a
	        end
	    end    
	    i=@arr.length
	    i.times do |i|
	    	#找到旧留言进行替换，更新留言时间属性
	        if @arr[i].id.eql?(id)
	           @arr.delete_at(i)
	       	   msg=Message.new(id,author,message,Time.new)
	       	   @arr[i] = msg
	       	   File.open("data.yml","wb") {|f| YAML.dump(@arr, f) }
	           break
	        end
	    end
	    #重定向到首页
	    redirect '/'
	else
		#留言无效
		redirect '/add/error'
	end
end

#此链接转到编辑页面
get '/edit/:id' do
	id = params['id']
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        @arr = []
        data.each do |a|
            @arr << a
        end
        @arr.select!{|v| v.id.to_s.eql?(id)}
        erb :edit
    end
end

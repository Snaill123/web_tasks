require 'sinatra'
require 'yaml'
$arr = []

$count = 0

class Message
	attr_accessor :id, :message, :author, :created_at
    def initialize (id,message,author,created_at)
    	@id, @message, @author, @created_at = id, message, author, created_at     
    end    
end

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


get '/add' do
    erb :insert
end

get '/id' do
	id = params['pid']
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        $arr = []
        data.each do |a|
            $arr << a
        end
        $arr.select{ |item| item.id == id }
        erb :id
    else
        "no messages now"
    end
end

get '/author' do
    author = params['pauthor']
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        $arr = []
        data.each do |a|
            $arr << a
        end
        $arr.select{ |item| item.author == author }
        erb :author
    else
        "no messages now"
    end
end

post '/add' do
    author = params['author']
    message = params['message']

    if  !author.empty? and message.length >= 10
        data = YAML.load(File.open("data.yml"))
        $arr =[]
        data.each do |a|
            $arr << a
        end
        $count = $arr.length
        msg = Message.new($count,author,message,Time.new)
        $arr<<msg
        File.open("data.yml","wb") {|f| YAML.dump($arr, f) }
        redirect '/'
    else
        redirect '/add/error'
    end 
end

get '/add/error' do
   erb :error
end

get '/delete' do
    id = params['del_id']
    if File.exists?("data.yml") 
        data = YAML.load(File.open("data.yml"))
        $arr = []
        data.each do |a|
            $arr << a
        end
    end
    $arr.select{|item| item.id != id}
    File.open("data.yml","wb") {|f| YAML.dump($arr, f) }
 	erb :delete
end



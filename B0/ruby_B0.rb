#!/usr/bin/ruby
# -*- coding: UTF-8

require 'yaml'

#随机生成字符串用作学生姓名，参数len决定字符串的长度
def newname( len )
  chars = ("a".."z").to_a + ("A".."Z").to_a
  newname = ""
  1.upto(len) { |i| newname << chars[rand(chars.size-1)] }
  return newname
end

#定义学生信息的hash表作为全局变量
def operate
	students = Hash.new
  #以hash形式生成100个学生信息,以学生的学号作为key，学生的姓名，年龄，性别作为value
  100.times do|i|
    students[i]={:name => newname(5), :age => rand(15..20), :gender =>(rand <0.5 ?  "male" : "female") }
  end
  #遍历输出
  students.each do |k,v|
    puts "#{k} #{v}"
  end
	return students
end

#按学生姓名进行排序后输出结果
def sort
	students = operate
    stu2 = students.sort_by{ |k, v| v[:name] }
	return stu2
end

#对学生信息进行修改, 按学号进行检索,修改姓名和年龄
def fix(nid=1,new_name="hhh",new_age=15)
  stu2 = sort
	stu2.each do |k,v|
	    if k == nid
		   v[:name] = new_name
		   v[:age] = new_age
	    end
  end
	return stu2
end

# read yml file
if File.exist?("data.yml")
   data = YAML.load_file("data.yml", "rb")
else
  #调用函数，观察结果,存入文件
  stu3 = fix 10,"hello",18
  puts "将学生信息排序并修改后，结果如下"
  stu3.each do |k,v|
    puts "#{k} #{v}"
  end
  #以YAML格式输出并保存
  puts stu3.to_yaml
  # write yml file
  File.open("data.yml", "wb") {|f| YAML.dump(stu3, f) }
end

 #!/usr/bin/ruby -w
 #随机生成字符串用作学生姓名，参数len决定字符串的长度
def newname( len )
   chars = ("a".."z").to_a + ("A".."Z").to_a
   newname = ""
   1.upto(len) { |i| newname << chars[rand(chars.size-1)] }
#   puts newname
   return newname
end
#定义student类及
class Student
     def initialize(id,name,gender,age)
         @stu_id = id
         @stu_name = name
         @stu_gender = gender
         @stu_age = age
     end
	
	def getStu_id
		@stu_id
	end
	
	def getStu_name
		@stu_name
	end
	
	def getStu_gender
		@stu_gender
	end
	
	def getStu_age
		@stu_age
	end
end
#student1 = Student.new(9, "tony", "female", 12)
#puts "haha : #{student1.getStu_id}"

#循环定义学生实例，并输出
100.times do|i|
	student = Student.new(i,newname(5),(rand <0.5 ?  "male" : "female"),rand(15..20))
	puts student.getStu_id
	puts student.getStu_name
	puts student.getStu_gender
	puts student.getStu_age
end

# Matcher.rb will develop a schedule for 6 weeks worth of code reviewing. The requirements are as follows
# 1. A list of people will be paired up by reviewer - reviewee and by project. 
# 2. Only one project can be set to have their code reviewed at any given time.



class Person
	attr_accessor :name, :project
	
	def initialize (name, project)
		@name = name
		@project = project
	end
end

class Review
	attr_accessor :author, :reviewer
	
	def initialize (author, reviewer)
		@author = author
		@reviewer = reviewer
	end
end

#def validate (schedule)
#	proj = Hash.new(0)
#	schedule.each do |check|
#		proj[check.author.project] +=1 
#	end
#	return true if proj.has_value?(2)
#	return false
#end

# Creates a schedule for the review ensuring that the 
# business rules are met. See above for the rules.
def create_schedule (schedule, staff)
	staff_temp = staff
	schedule = Array.new
	project_name = Array.new
	
	#Create an array with names for each project
	staff_temp.each do |person|
		project_name.push (person.project) if (!project_name.include?(person.project))
	end

	#Add an author for each project to the schedule
	project_name.each do |proj|
		tmp = staff_temp.select {|x| x.project.match /#{proj}/ } 
		schedule.push(Review.new(tmp[0],nil))
	end

	#Add a reviewer to the schedule ensuring that nobody reviews their own code
	schedule.each do |review|	
		tmp = staff_temp.select {|x| !x.name.include? review.author.name } 
		review.reviewer = tmp[0]
		staff_temp.delete(tmp[0])
	end
	
	schedule
end

staff = Array.new
staff.push (Person.new("Clayton", "Heartbeat"))
staff.push (Person.new("James", "Vindicia"))
staff.push (Person.new("Nat", "Heartbeat"))
staff.push (Person.new("Robbie", "AppDirect"))
staff.push (Person.new("Tate", "Liftopia"))
staff.push (Person.new("Arlene", "Aires"))
staff.push (Person.new("Katie", "Leap Motion"))
staff.shuffle!



schedule = create_schedule(Array.new, staff)
schedule.each do |review|
	if review.reviewer == nil
		puts "found an empty object"
	else
		puts "Reviewer: #{review.reviewer.name}  Author: #{review.author.name} Project: #{review.author.project}"
	end
end
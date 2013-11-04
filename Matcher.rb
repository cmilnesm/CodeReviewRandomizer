#! /usr/bin/ruby
##########################HEADER#########################
# Matcher.rb will develop a schedule for 6 weeks worth of code reviewing. This script will do the following:
# 1. Read all data from the CSV file 
# 2. Randomize the data so each run will produce a different schedule
# 3. Match people up based upon project ensuring that each project only has one author during any given run
# 2. Print out the names of any people that are not assigned as a reviewer.
#########################################################
require 'CSV'

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
	
	#print out all the people that have not been used as a reviewer. This information
	#allows for balancing of people
	staff_temp.each do |person|
		puts "#{person.name} is unused as a reviewer"
	end

	schedule
end

if ARGV[0] == nil 
	puts "Please enter a filename for the csv datafile"
else
	begin
		#Get the names and projects for everyone participating in the code review from the .csv file
		staff = Array.new
		CSV.foreach(ARGV[0]) do |row|
			staff.push(Person.new(row[0],row[1]))
		end
		staff.shuffle! #Randomize the array so we mix things up.

		#Create the schedule and output the results to the console
		schedule = create_schedule(Array.new, staff)
		schedule.each do |review|
			if review.reviewer == nil
				puts "found an empty object. Please check data and rerun script with Author=#{review.author.name}"
			else
				puts "Reviewer: #{review.reviewer.name}  Author: #{review.author.name} Project: #{review.author.project}"
			end
		end
	rescue Errno::ENOENT
		puts "#{ARGV[0]} Not found. Please check the filename and try again"	
	end
end
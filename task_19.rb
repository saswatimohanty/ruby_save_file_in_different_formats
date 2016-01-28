class ResumeBuilder
	attr_accessor :first_name, :last_name, :address, :phone_number, :email_id, :about_you, :skills, :courses_name, :date_of_birth, 
								:gender, :nationality, :languages_known, :save_file
	def self.build(options = {media:[]})
		user_info = self.new
	 	user_info.set_first_name
		user_info.set_last_name
		user_info.set_address
		user_info.set_phone_number
		user_info.set_email_id
		user_info.set_about_you
		user_info.set_skills
		user_info.set_courses_name
		user_info.set_date_of_birth
		user_info.set_gender
		user_info.set_nationality
		user_info.set_languages_known

		different_medias = options[:media]
		different_medias.each do |media|
			make_files = eval("#{media.capitalize}Media").new(user_info)
      make_files.save_file_as(user_info)
    end
	end

	# It is retreiving First Name of the User
	def set_first_name
		puts "Enter Your First Name : "
		self.first_name = gets.strip
		if /[a-zA-Z]/.match("#{first_name}") 
			puts "Correct!"
		else
			puts "*First Name should be Alphabets only*"
			set_first_name
		end
	end

	# It is retreiving Last Name of the User
	def set_last_name
		puts "Enter Your Last Name : "
		self.last_name = gets.strip
		if /[a-zA-Z]/.match("#{last_name}")
			puts "Correct!"
		else
			puts "*Last Name should be Alphabets only*"
			set_last_name
		end
	end

	# It is retreiving Address of the User
	def set_address
		puts "Enter Your Address : "
		self.address = gets.chomp
		if address.length != 0
			puts "Correct!"
		else
			puts "*Address cannot be empty*"
			set_address
		end
	end

	# It is retreiving Phone Number of the User
	def set_phone_number
		puts "Enter Your Phone Number"
		self.phone_number = "+91" + gets.chomp
		if /[0-9]{10}/.match("#{phone_number}") 
			puts "Correct!"
		else
			puts "*Phone Number should be digits only and must contain 10 digits*"
			set_phone_number
		end
	end

	# It is retreiving e-mail of the User
	def set_email_id
		puts "Enter Your email id : "
		self.email_id = gets.chomp
		if /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/.match("#{email_id}") 
			puts "Correct!"
		else
			puts"*Enter valid e-mail id*"
			set_email_id
		end
	end

	# It is retreiving Brief Summary of the User
	def set_about_you
		puts "Enter About You (Brief Summary) : "
		self.about_you = gets.chomp
	end

	# It is retreiving Skills of the User
	def set_skills
		puts "Enter Your Skills"
		self.skills = gets.chomp
		if skills.length != 0
			puts "Correct!"
		else
			puts "*Skills cannot be empty*"
			set_skills
		end
	end

	# It is retreiving Course Name of the User
	def set_courses_name
		puts "Enter name of the Courses : "
		self.courses_name = gets.chomp
		if courses_name.length != 0
			puts "Correct!"
		else
			puts "*Courses Name cannot be empty*"
			set_courses_name
		end
	end

	# It is retreiving DOB of the User
	def set_date_of_birth
		puts "Enter Your Date of Birth (dd/mm/yyyy): "
		self.date_of_birth = gets.chomp
		if /\d{2}\/\d{2}\/\d{4}/.match("#{date_of_birth}")
			puts "Correct!"
		else
			puts "*Date of Birth should be in the given Style only*"
			set_date_of_birth
		end
	end

	# It is retreiving Gender of the User
	def set_gender
		puts "Enter Your Gender : "
		self.gender = gets.chomp
		if gender.length != 0
			puts "Correct!"
		else
			puts "*Gender cannot be empty*"
			set_gender
		end
	end

	# It is retreiving Nationality of the User
	def set_nationality
		puts "Enter Your Nationality : "
		self.nationality = gets.chomp
	end

	# It is retreiving Languages known by the User
	def set_languages_known
		puts "Languages known : "
		self.languages_known = gets.chomp
	end
end

class Media
	attr_accessor:resume
	def initialize(resumebuilder_object)
		self.resume = resumebuilder_object
	end

	# It is saving the data to a file
	def save_file_as(resume)
		" ADDRESS SECTION\n First Name : #{resume.first_name}\n Last Name : #{resume.last_name}\n Address : #{resume.address}" + 
		"\n Contact Number : #{resume.phone_number}\n e-mail id : #{resume.email_id}\n\n SUMMARY SECTION\n" +
		"\n About You (Brief Summary) : #{resume.about_you}\n\n EDUCATION DETAILS\n Skills : #{resume.skills}" + 
		"\n Courses Completed : #{resume.courses_name}\n\n PERSONAL DETAILS\n Date of Birth : #{resume.date_of_birth}" +
		"\n Gender : #{resume.gender}\n Nationality : #{resume.nationality}\n Languages Known : #{resume.languages_known}\n"
	end
end

class TextMedia < Media
	def save_file_as(resume)
		aFile = File.new("#{resume.first_name}.txt","w") 
			save_file = File.open(aFile, "a") do |file|
			file.puts super
			end
	end
end

class CsvMedia < Media
	def save_file_as(resume)
		#Install : gem install spreadsheet
		require 'spreadsheet'
		book = Spreadsheet::Workbook.new
		sheet1 = book.create_worksheet
		sheet1.row(0).concat %w{FirstName Lastname Address PhoneNumber email AboutYou Skills CoursesName DOB Gender Nationality Languages}
		sheet1.row(1).push "#{resume.first_name}", "#{resume.last_name}", "#{resume.address}", "#{resume.phone_number}", "#{resume.email_id}", "#{resume.about_you}", "#{resume.skills}", "#{resume.courses_name}", "{resume.date_of_birth}", "#{resume.gender}", "#{resume.nationality}", "#{resume.languages_known}"
		book.write "#{resume.first_name}.xls"	
	end
end

class PdfMedia < Media
	def save_file_as(resume)
		#Install : gem install prawn
		require 'prawn'
		Prawn::Document.generate("#{resume.first_name}.pdf") do |pdf|
			pdf.text super
		end
	end
end
ResumeBuilder.build({media: ["text", "csv", "pdf"]})




require 'csv'

class RunDatabase
  def initialize
    @people = []

    CSV.foreach("employees.csv", headers:true) do |person|
      name = person["name"]
      phone_number = person["phone"]
      address = person["address"]
      position = person["position"]
      salary = person["salary"]
      slack_account = person["slack"]
      github_account = person["github"]

      add_to_database(name, phone_number, address, position,salary, slack_account, github_account)
    end
  end

  # Saving updates to CSV file
  def save_inventory
    csv = CSV.open("employees.csv", "w")
    csv.add_row %w{name phone address position salary slack github}
    @people.each do |person|
      csv.add_row [person.name, person.phone_number, person.address, person.position, person.salary, person.slack_account, person.github_account]
    end

    csv.close
  end

  # add data into CSV file
  def add_to_database(name, phone_number, address, position, salary, slack_account, github_account)
    person = Person.new
    person.name = name
    person.phone_number = phone_number
    person.address = address
    person.position = position
    person.salary = salary
    person.slack_account = slack_account
    person.github_account = github_account

    @people << person
  end

  # print report of inventory
  def print_invetory
    @people.each do |person|
      banner_three "#{person.name} | #{person.phone_number} | #{person.address} | #{person.address} | #{person.position} | #{person.salary} | #{person.slack_account} | #{person.github_account} "
    end
  end

  # Banner styling
  def banner(message)
    1.times do
      puts
    end

    puts "*" * (8 + message.length)
    puts "!😱  #{message} 😱 !"
    puts "*" * (8 + message.length)

    1.times do
      puts
    end
  end

  def banner_two(message)
    1.times do
      puts
    end

    puts "-" * (4 + message.length)
    puts "| #{message} |"
    puts "_" * (4 + message.length)

    1.times do
      puts
    end
  end

  def banner_three(message)
    puts " #{message} "
    puts "-" * (4 + message.length)
  end

  # Initial app question
  def prompt_for_answer
    puts "There are #{@people.length} people in my amazing database"
    banner_two "Would you like to add (A), search (S), delete (D)? or print Report (R)? "
    gets.chomp.upcase
  end

  # Search behavior
  def search
    puts "What name, github, or slack are you searching for? "
    search_text = gets.chomp

    search_result = @people.find_all { |person| person.name.include?(search_text) || person.slack_account.include?(search_text) || person.github_account.include?(search_text) }

    if search_result.empty?
      banner "#{name} NOT FOUND!"
    end

    search_result.each do |person|
      puts person.name
      puts person.address
      puts person.phone_number
      puts person.position
      puts person.github_account
      puts person.salary
      puts person.slack_account
    end
  end

  # Deleting behavior
  def delete
    puts "What name would you like to delete? "
    name = gets.chomp
    search_result = @people.delete_if {|person| person.name.eql?(name)}
    banner "#{name} has been DELETED."
  end

  # Running the app
  def run
    loop do
      answer = prompt_for_answer
      case answer

        # When user wants to Add
        when "A"
          person = Person.new
          print "First Name: "
          person.name = gets.chomp
          print "Phone Number: "
          person.phone_number = gets.chomp
          print "Address: "
          person.address = gets.chomp
          print "Position (e.g. Instructor, Student, TA, Campus Director): "
          person.position = gets.chomp
          print "Salary: "
          person.salary = gets.chomp.to_i
          print "Slack Account: "
          person.slack_account = gets.chomp
          print "Github Account: "
          person.github_account = gets.chomp
          @people << person
          save_inventory

          # Looping to search for the indexes withing the @people array and comparing it with the users input. Printing out object and its methods
        when "S"
          search

        when "D"
          delete
          save_inventory

        when "R"
          print_invetory
        # When entry is not valid
        else
          banner "Not a valid entry. Please try again and press Enter Key."
      end
    end
  end
end

class Person
  attr_accessor :name, :phone_number, :address, :position, :salary, :slack_account, :github_account
end

run_database = RunDatabase.new
run_database.run

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
      banner_three "Name: #{person.name} | Phone Number:#{person.phone_number} | Address: #{person.address}| Position: #{person.position} | Salary: #{person.salary} | Slack Account: #{person.slack_account} | Github Account: #{person.github_account}"
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
      banner "#{search_text} NOT FOUND!"
    end
    search_result.each do |person|
      banner_three "Name: #{person.name} | Phone Number:#{person.phone_number} | Address: #{person.address}| Position: #{person.position} | Salary: #{person.salary} | Slack Account: #{person.slack_account} | Github Account: #{person.github_account}"
    end
  end

  # Deleting behavior
  def delete
    puts "What name would you like to delete? "
    name = gets.chomp
    if @people.any? {|person| person.name == name}
      @people.delete_if {|person| person.name == name}
      banner_two "#{name} has been deleted"
    else
      banner "#{name} not found"
    end
  end

  # Reject duplicate behavior
  def search_and_add
    person = Person.new
    print "First name: "
    new_name = gets.chomp
    if @people.any? {|person| person.name == new_name}
      banner "#{new_name} is alredy in database"
    else
      person.name = new_name
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
    end
  end

  # Running the app
  def run
    loop do
      answer = prompt_for_answer
      case answer

        # When user wants to Add
        when "A"
          search_and_add
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

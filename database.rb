require 'csv'
require_relative "person"


# Database manages a collection (array) of `Peson`s
# Methods are provided to add/delete/search people.
#
# The Database class stores it's collection of people
# to a file employee.csv so that it retains it's collection
# between runs of the program
class Database
  CSV_FILE_NAME = "employee.csv"

  # NOTE: We are not providing any `attr_accessor` or otherwise since we don't
  #       want any *outside* access to the array of people. All interaction
  #       should happen through the methods found here

  def initialize
    @people = []
    read_from_csv
  end

  def add(name, phone_number, address, position, salary, slack_account, github_account)
    person = Person.new
    person.name = name
    person.phone_number = phone_number
    person.address = address
    person.position = position
    person.salary = salary
    person.slack_account = slack_account
    person.github_account = github_account

    @people << person

    save_to_csv

    return person
  end

  def delete(name)
    person = @people.find { |person| person.name == name }

    @people.delete(person)

    save_to_csv

    return person
  end

  def search(name)
    @people.find { |person| person.name == name }
  end

  def read_from_csv
    CSV.foreach(CSV_FILE_NAME, headers: true, header_converters: :symbol) do |row|
      person = Person.new

      person.name           = row[:name]
      person.phone_number   = row[:phone_number]
      person.address        = row[:address]
      person.position       = row[:position]
      person.salary         = row[:salary]
      person.slack_account  = row[:slack_account]
      person.github_account = row[:github_account]

      @people << person
    end
  end

  def save_to_csv
    CSV.open(CSV_FILE_NAME, 'w') do |csv|
      csv << %w{name phone address position salary slack_account github_account}
      @people.each do |person|
        csv << [person.name, person.phone_number, person.address, person.position,
                person.salary, person.slack_account, person.github_account]
      end
    end
  end
end

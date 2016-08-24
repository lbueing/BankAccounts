require 'csv'

class Owner
  attr_accessor :name, :address, :phone
  def initialize(hash_parameter)
    @name = hash_parameter[:name]
    @address = hash_parameter[:address]
    @phone = hash_parameter[:phone]
  end
  def to_s
    return "Name: #{@name}, Address: #{@address}, Phone: #{@phone}"
  end
end

customer1 = Owner.new(name: "joey", address: "5th ave", phone: 555345567)

module Bank
  class Account
    attr_accessor :id, :balance, :open_date#, :owner_info
    @@account_info = []
    def initialize(hash_parameter)
      @id = hash_parameter[:id]
      @balance = hash_parameter[:balance]
      @open_date = hash_parameter[:open_date]
      # @owner_info = hash_parameter[:owner_info]
      # if initial_deposit < 0
      #   raise ArgumentError.new("You cannot have negative money.")
      # end
      #@balance = initial_deposit
    end
    def withdraw(take)
      if take > @balance
        puts "You do not have enough money to withdraw that amount."
      else
        @balance -= take
      end
      return @balance
    end
    def deposit(give)
      if give <= 0
        puts "Looks like you are actually trying to withdraw."
      else
        @balance += give
      end
    end
    def balance
     return @balance
    end
    def self.store_info
      CSV.open("support/accounts.csv", "r").each do |line|
        @@account_info << Bank::Account.new(id: line[0], balance: line[1], open_date: line[2])
      end
    end
    #This method prints all account information. store_info needs to be called before this method will work b/c otherwise @@account_info is empty. Otherwise the currently commented out self.all will work on it's own.
    def self.all
      @@account_info.each do |i|
        puts i
      end
    end
    # def self.all
    #   CSV.open("support/accounts.csv", "r").each do |line|
    #     puts Bank::Account.new(id: line[0], balance: line[1], open_date: line[2])
    #   end
    # end

    #This method prints only the information from the selceted id number. Similar notes to self.all above.
    def self.find(id)
      @@account_info.each do |i|
        if i.id.to_i == id
          puts i
        end
      end
    end
    # def self.find(id)
    #   CSV.open("support/accounts.csv", "r").each do |line|
    #     Bank::Account.new(id: line[0], balance: line[1], open_date: line[2])
    #     if line[0].to_i == id
    #       puts  Bank::Account.new(id: line[0], balance: line[1], open_date: line[2])
    #     end
    #   end
    # end
    def to_s
      return "id = #{@id}, balance = $#{@balance.to_i/100.00}, open date = #{open_date}"
    end
  end
end

Bank::Account.store_info
Bank::Account.all
puts ""
Bank::Account.find(1215)
puts ""


# puts account_info

# account1 = Bank::Account.new(rand(100000..999999), 50, customer1)
# account1.withdraw(60)
# account1.deposit(40)
#
# puts account1.balance
# puts account1.id
# puts account1.owner_info

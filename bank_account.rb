require 'csv'

class Owner
  attr_accessor :personal_id, :last_name, :first_name, :address, :city, :state
  @@owner_info = []
  def initialize(hash_parameter)
    @personal_id = hash_parameter[:personal_id]
    @last_name = hash_parameter[:last_name]
    @first_name = hash_parameter[:first_name]
    @address = hash_parameter[:address]
    @city = hash_parameter[:city]
    @state = hash_parameter[:state]
  end
  def self.store_info
    CSV.open("support/owners.csv", "r").each do |line|
      @@owner_info << Owner.new(personal_id: line[0], last_name: line[1], first_name: line[2], address: line[3], city: line[4], state: line[5])
    end
  end
  def self.all
    @@owner_info.each do |i|
      puts i
    end
  end
  def self.call
    @@owner_info
  end
  def self.find(id)
    @@owner_info.each do |i|
      if i.personal_id.to_i == id
        puts i
      end
    end
  end
  def to_s
    return "ID: #{personal_id}, Name: #{first_name} #{last_name}, Address: #{@address}, City: #{city}, State: #{state}"
  end
end


module Bank
  class Account
    attr_accessor :id, :balance, :open_date, :owner_info
    @@account_info = []
    def initialize(hash_parameter)
      @id = hash_parameter[:id]
      @balance = hash_parameter[:balance].to_f/100.00
      @open_date = hash_parameter[:open_date]
      @owner_info = hash_parameter[:owner_info]
      if balance < 0
        raise ArgumentError.new("You cannot have negative money.")
      end
    end
    def withdraw(take)
      if take > balance
        puts "You do not have enough money to withdraw that amount."
      else
        @balance -= take
      end
      return sprintf('%.2f', balance)
    end
    def deposit(give)
      if give <= 0
        puts "Looks like you are actually trying to withdraw."
      else
        @balance += give
      end
    end
    # def balance
    #  return @balance
    # end
    def self.store_info
      i = 0
      CSV.open("support/accounts.csv", "r").each do |line|
          @@account_info << Bank::Account.new(id: line[0], balance: line[1], open_date: line[2], owner_info: Owner.call[i])
          i +=1
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
      return "id = #{@id}, balance = $#{@balance}, open date = #{open_date}, owner_info = #{owner_info}"
    end
  end

  class SavingsAccount < Account
    def initialize(hash_parameter)
      super
      if balance < 10
        raise ArgumentError.new("You must deposit a minimum of $10.")
      end
    end
    def withdraw(take)
      if take > (balance - 10)
        puts "You would be left with less than $10 if you withdraw that amount. Bank will not let you do that."
      else
        @balance -= (take + 2)
      end
      return sprintf('%.2f', balance)
    end
    def add_interest(rate)
      returned_interest = balance*rate/100.00
      @balance += returned_interest
      return sprintf('%.2f', returned_interest)
    end
  end

  class CheckingAccount < Account
    attr_accessor :counter
    def initialize(hash_parameter)
      super
      @counter = 0
    end
    def withdraw(take)
      if take > balance
        puts "You do not have enough money to withdraw that amount."
      else
        @balance -= (take + 1)
      end
      return sprintf('%.2f', balance)
    end
    def withdraw_using_check(amount)
      if (balance - amount) < -10
        return "You are only allowed an overdraft maximum of $10. Please withdraw a different amount."
      else
        while counter < 3
          @balance -= amount
          @counter += 1
          return sprintf('%.2f', balance)
        end
        while counter >= 3
          @balance -= (amount + 2)
          @counter += 1
          return sprintf('%.2f', balance)
        end
      end
    end
    def reset_checks
      @counter = 0
      return "Your checks have been reset to 0."
    end
  end
  class MoneyMarketAccount < SavingsAccount
    attr_accessor :count
    def initialize(hash_parameter)
      super
      if balance < 10000
        raise ArgumentError.new("You must deposit a minimum of $10,000.")
      end
      @count = 0
    end
    def withdraw(take)
      while count < 6
        if balance < 10000
          puts "Your balance must be above $10,000 in order to withdraw."
        elsif (balance - take) < 10000
          @balance -= (take + 100)
          puts "Overdraw fee: $100."
        else
          @balance -= take
        end
        @count += 1
        return sprintf('%.2f', balance)
      end
      while count >= 6
        puts "You have used your 6 transactions and have no more to use."
      end
    end
    def deposit(give)
      while count < 6
        if balance < 10000
          if (balance + give) < 10000
            @balance += give
          elsif (balance + give) >= 10000
            @balance += give
            @count -=1
          end
        else
          @balance += give
        end
        @count += 1
        return sprintf('%.2f', balance)
      end
      while count >= 6
        return "You have used your 6 transactions and have no more to use."
      end
    end
    def reset_transactions
      @count = 0
      return "Your transaction count has been reset."
    end
  end
end


# account4 = Bank::MoneyMarketAccount.new(id: rand(100000..999999), balance: 1100000)
# puts account4.balance
# puts account4.withdraw(500)
# puts account4.withdraw(600)
# puts account4.withdraw(1)
# puts account4.deposit(100)
# puts account4.deposit(1000)
# puts account4.deposit(200)
# puts account4.deposit(1000)
# puts account4.deposit(200)
# puts account4.deposit(200)
# puts account4.reset_transactions
# puts account4.deposit(1000)
# puts account4.deposit(200)
# puts account4.add_interest(5)
# puts account4.deposit(100)
#
# account3 = Bank::CheckingAccount.new(id: rand(100000..999999), balance: 1400)
# puts account3.withdraw_using_check(10)
# puts account3.withdraw_using_check(10)
# puts account3.withdraw_using_check(10)
# puts account3.reset_checks
# puts account3.withdraw_using_check(10)
#
#
# account2 = Bank::SavingsAccount.new(id: rand(100000..999999), balance: 140000)
# puts account2.withdraw(50)
# puts account2.add_interest(1.5)
#
#
# Owner.store_info
# Bank::Account.store_info
# Bank::Account.all
# puts ""
# Bank::Account.find(1215)
# puts ""
# Owner.find(16)
#
#
# account1 = Bank::Account.new(id: rand(100000..999999), balance: 5000)
# puts account1.withdraw(40)
# account1.deposit(40)
#
# puts account1.balance
# puts account1.id



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
    attr_accessor :customer_info, :id, :balance, :owner_info
    def initialize(id, initial_deposit, owner_info)
      @owner_info = owner_info
      @id = id
      if initial_deposit < 0
        raise ArgumentError.new("You cannot have negative money.")
      end
      @balance = initial_deposit
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
  end
end

account1 = Bank::Account.new(rand(100000..999999), 50, customer1)
account1.withdraw(60)
account1.deposit(40)

puts account1.balance
puts account1.id
puts account1.owner_info

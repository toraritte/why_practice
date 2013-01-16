class Creature # reimplementing in module?
               # trying it with method_missin?
  def self.mc
    class << self; self; end
  end
  
  # creates the class methods for storing the traits and attributes
  def self.traits( *attrib )
    return @traits if attrib.empty?

    # storing the traits and values in a hash (@traits)
    # defines only setter methods but set attributes can 
    # be checked with "traits"
    # eg. Dragon.traits => {:life=>1000, :strength=>500, :charisma=>120, :weapon=>900}
    attrib.each do |a|
      mc.class_eval do 
        define_method( a ) do |value|
          @traits ||={}
          @traits[a] = value
        end
      end
    end
    
    # trait getters and setters for the instances of new creatures
    # eg. Dragon.new.life   #=> 1000
    attr_accessor( *attrib )
  
  end
  
  # originally in the poignant guide it looked like below but 
  # it is unnecessary because: 
  # class_eval do                     ---> evaluates the code in the context of the class        
  #   define_method( :initialize ) do ---> therefore creating an instance method which is
  #     ( the rest is the same)            the same as "def initialize" and nothing justifies
  #                                        its use.
  def initialize
    self.class.traits.each do |k,v|       # passing the values to each new instance of 
      instance_variable_set "@#{k}",v     # Creature and its subclasses
    end
  end

  traits :life,:strength,:charisma,:weapon
end

class Dragon < Creature
  # these need to be class methods in creature -> self.traits 
  life    1000
  strength 500
  charisma 120
  weapon  900
end


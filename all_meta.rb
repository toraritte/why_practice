class Playground
  
   def self.metaclass                      # class method
    class << self; self; end
  end

  instance_eval do 
    define_method(:a) {}                  # instance method
    def b; end                            # class method
  end

  class_eval do 
    define_method(:c) {}                  # instance method
    def d; end                            # instance method
  end

  metaclass.instance_eval do              # class method
    define_method(:e) {}
    def f; end
  end

  metaclass.class_eval do
    define_method(:g) {}                  # class method
    def h; end                            # class method
  end

  send( :define_method,:i) {}             # instance method
  metaclass.send( :define_method, :j) {}  # class method
end

class Attcrib
  
  def initialize
    puts "self.class: #{self.class}"
  end

  def self.mc                             # class method
    class << self; self; end
  end

  def inst_meth( *things )
    return @inst_meth if things.empty?
    attr_accessor( *things )
  end

  def self.class_meth( *another )
    return @class_meth if another.empty?
    
    attr_accessor( *another )

    another.each do |e|
      mc.instance_eval do
        define_method( e ) do |var|
          @class_meth ||= {}
          @class_meth[e] = var  
        end
      end
    end
  end

  def self.some_meth
    instance_eval { define_method(:a) {}}     # instance method
    class_eval    { define_method(:b) {}}     # instance method
    mc.instance_eval { define_method(:c) {}}  # class method
    mc.class_eval    { define_method(:d) {}}  # class method
  end
end


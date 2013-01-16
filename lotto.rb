class LottoTicket

  VALID_RANGE = (1..25)
  attr_reader :picks, :purchase

  def initialize( *picks )
    if not picks.uniq.size == 3 && picks.size == 3
      raise ArgumentError, "Arguments should be unique and should be only 3 of them"
    elsif picks.detect { |x| not VALID_RANGE === x }
      raise ArgumentError, "numbers should be between 1 and 25"
    end
    @picks,@purchase = picks, Time.now
    @oid = self.object_id
  end
  
  def self.random_new
    new( rand(25)+1, rand(25)+1, rand(25)+1 )
  rescue ArgumentError
    retry
  end

  def score( other_ticket )
    score = 0
    other_ticket.picks.each do |number|
      score += 1 if picks.include? number
    end
    score
  end
end

class LottoDraw
  @@tickets = {}
  def self.buy( buyer, *tickets )
    unless @@tickets.has_key? buyer
      @@tickets[ buyer ] = []
    end
    @@tickets[ buyer ] += tickets
  end

  def self.play
    final = LottoTicket.random_new
    winners = Hash.new { |h,k| h[k] = []} 
    @@tickets.each_pair do |buyer,tickets|
      tickets.each do |t|
        score = t.score final
        next if score.zero?
        winners[buyer] << [t,score]
      end
    end
    @@tickets.clear
    winners
  end
end


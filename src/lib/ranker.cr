# A class that implements the actual ranking done by the Exuberant Ranker.
class Ranker
  def initialize(items : Array(String), settings : RankerSettings)
    @items = items
    @settings = settings
  end

  def start_ranking_dialogue
    case @settings.get_setting "ranking_mode"
    when RankingMode::GUESS
      rank_guess
    when RankingMode::ASK_ALL
      rank_ask_all
    end
  end

  def rank_guess
    while true
      fav = @items[rand(@items.size)]

      if RankerLib.ask "is #{fav} your favorite?"
        puts "Great! Then your ranking is: "

        puts "\t 1.#{fav}"

        @items.each do |line|
          if line != fav
            puts "\t 2.#{line}"
          end
        end
        return
      else
        puts "Oh, too bad. Let me try again!"
      end
    end
  end

  def rank_ask_all
    ranks = Hash.zip(@items, Array.new(@items.size, 0))
    left = (0...@items.size).to_a
    right = (0...@items.size).to_a
    left.shuffle
    left.each do |i|
      right.shuffle
      right.each do |j|
        if i != j
          # TODO change to <=>, ask each pair just once and shuffle up the order a bit more
          # => constuct a set of all the pairs to ask first, then iterate over it with questions
          if RankerLib.ask "Do you prefer #{@items[i]} over #{@items[j]} ?"
            ranks[@items[i]] += 1
          else
            ranks[@items[j]] += 1
          end
        end
      end
    end
    puts "I belive the ranking is complete! Here are the results:"
    @items.sort! { |a, b| ranks[b] <=> ranks[a] }
    @items.each_with_index do |value, i|
      puts "\t #{i + 1}. #{value}"
    end
  end
end

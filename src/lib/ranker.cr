# A class that implements the actual ranking done by the Exuberant Ranker.
class Ranker
  def initialize(items : Array(String), settings : RankerSettings)
    @items = items
    @settings = settings
  end

  def start_ranking_dialogue
    case @settings.ranking_mode
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
    # TODO: implement
    puts "Asking all still under construction!"
    i = 1
    @items.each do |line|
      puts "\t #{i}.#{line}"
      i += 1
    end
  end
end

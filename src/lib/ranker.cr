# A class that implements the actual ranking done by the Exuberant Ranker.
class Ranker
  def initialize(items : Array(String))
    @items = items
    @age = 0
  end

  def start_ranking_dialogue
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
end

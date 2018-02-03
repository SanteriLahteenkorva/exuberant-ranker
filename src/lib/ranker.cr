# A class that implements the actual ranking done by the Exuberant Ranker.
class Ranker
  def initialize(items : Array(String), settings : RankerSettings)
    @items = items
    @settings = settings
  end

  # TODO make return the ranking list in the end regardless of the mode (store as a field)
  # Also add method for printing it in lib
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
    k = @items.size

    # Maps each item pair to their corresponding comparison result
    # That is ranks[{a, b}] = a <=> b
    keys = (@items.permutations 2).map { |(a, b)| {a, b} }
    ranks = Hash.zip keys, Array.new keys.size, 0

    # Iterate through all unique item pairs
    indices = @items.combinations 2

    # Randomize the order (might turn this to an option later)
    RankerLib.shuffle_pairs indices

    indices.each do |(a, b)|
      if a != b
        # Tiebreaker will be head to head, so store the result for later checking
        res = RankerLib.ask_comparison a, b
        ranks[{a, b}] = res
        ranks[{b, a}] = -res
      end
    end

    puts "I believe the ranking is complete! Here are the results:"

    # Sort in descending order by ranks
    @items.sort! { |a, b| RankerLib.compare_with_tiebreaker ranks, b, a }

    @items.each_with_index do |value, i|
      puts "\t #{i + 1}. #{value}, (#{RankerLib.score ranks, value})"
    end
  end
end

# A class that implements the actual ranking done by the Exuberant Ranker.
class Ranker
  def initialize(items : Array(String), settings : RankerSettings)
    @items = items
    @settings = settings
  end

  def start_ranking_dialogue
    res = [] of {String, Int32}
    case @settings.get_setting "ranking_mode"
    when RankingMode::GUESS
      res = rank_guess
    when RankingMode::ASK_ALL
      res = rank_ask_all
    when RankingMode::SORT
      res = rank_sort
    when RankingMode::SMART_ASK
      res = rank_smart_ask
    end
    return res
  end

  def rank_guess
    while true
      fav = @items[rand(@items.size)]

      if RankerLib.ask "is #{fav} your favorite?"
        puts "Great! Then your ranking is: "
        result = [] of {String, Int32}
        result << {fav, 1}
        @items.each do |line|
          if line != fav
            result << {line, 2}
          end
        end
        return result
      else
        puts "Oh, too bad. Let me try again!"
      end
    end
  end

  def rank_ask_all
    # Maps each item pair to their corresponding comparison result
    # That is ranks[{a, b}] = a <=> b.
    # The value Int32.MIN signifies unset value. These are skipped when counting score.
    keys = (@items.permutations 2).map { |(a, b)| {a, b} }
    ranks = Hash.zip keys, Array.new keys.size, Int32::MIN

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
    result = [] of {String, Int32}
    @items.each_with_index do |value, i|
      result << {value, i + 1}
    end
    return result
  end

  def rank_sort
    @items.sort! { |a, b| RankerLib.ask_comparison b, a }
    puts "The results are in!"
    result = [] of {String, Int32}
    @items.each_with_index do |value, i|
      result << {value, i + 1}
    end
    return result
  end

  def rank_smart_ask
    # Like rank_ask_all, but attempts to avoid questions where the result should be clear.
    # Still asks more questions than rank_sort which assumes total transitivity in opinions.
    keys = (@items.permutations 2).map { |(a, b)| {a, b} }
    ranks = Hash.zip keys, Array.new keys.size, Int32::MIN
    indices = @items.combinations 2
    RankerLib.shuffle_pairs indices
    indices.each do |(a, b)|
      if a != b
        res = RankerLib.smart_comparison ranks, a, b
        # Ask only if not able to conclude the result without asking
        if !res.is_a? Int32
          res = RankerLib.ask_comparison a, b
        end
        ranks[{a, b}] = res
        ranks[{b, a}] = -res
      end
    end
    puts "I believe the ranking is complete! Here are the results:"
    @items.sort! { |a, b| RankerLib.compare_with_tiebreaker ranks, b, a }
    result = [] of {String, Int32}
    @items.each_with_index do |value, i|
      result << {value, i + 1}
    end
    return result
  end
end

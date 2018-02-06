# Module for storing utilities and miscallenous functionality
module RankerLib
  # Used for printing the title for the program.
  # TODO make title prettier and add info.
  def self.print_title : Nil
    title = "* Exuberant Ranker *"

    print "\n"*4
    puts "\t" * 2 + " " + "*" * title.size
    # puts "\t" * 2 + "*#{" " * title.size}*"
    puts "\t" * 2 + "*#{title}*"
    # puts "\t" * 2 + "*#{" " * title.size}*"
    puts "\t" * 2 + " " + "*" * title.size + "\n"*4
  end

  # Asks the user the given y/n question and returns the result
  def self.ask(question : String) : Bool
    puts "#{question} (y/n)"
    # Read characters until y or n is given
    while true
      char = STDIN.raw &.read_char
      c = char
      if c == 'y'
        return true
      elsif c == 'n'
        return false
      end
    end
  end

  # Asks the user which one of the given items they prefer and return the usual comparison result.
  def self.ask_comparison(item1 : String, item2 : String) : Int32
    puts "#{item1} or #{item2}? Press 1 for #{item1}, 2 for a tie or 3 for #{item2}."
    while true
      char = STDIN.raw &.read_char
      c = char
      if c == '1'
        puts "#{item1} > #{item2}"
        return 1
      elsif c == '2'
        puts "#{item1} = #{item2}"
        return 0
      elsif c == '3'
        puts "#{item1} < #{item2}"
        return -1
      end
    end
  end

  # Compares the scores of a and b in ranks and returns the comparison result, resovling ties using head-to-head result according to ranks.
  def self.compare_with_tiebreaker(ranks, a : String, b : String) : Int32
    res = (score ranks, a) <=> (score ranks, b)
    if res != 0
      return res
      # Tiebreaker - head to head result
    else
      return ranks[{a, b}]
    end
  end

  # Count the total for the given item a.
  def self.score(ranks, a : String) : Int32
    acc = 0
    ranks.each do |key, value|
      if key[0] == a && value != Int32::MIN
        acc += value
      end
    end
    return acc
  end

  # Determines how many comparison are yet to do regarding the given item.
  def self.remaining(ranks, a : String) : Int32
    acc = 0
    ranks.each do |key, value|
      if key[0] == a && value == Int32::MIN
        acc += 1
      end
    end
    return acc
  end

  # Randomizes the order in a given collection of pairs including the order of the elements in each pair.
  def self.shuffle_pairs(pairs)
    pairs.shuffle!
    r = Random.new
    pairs.each do |pair|
      if r.next_bool
        tmp = pair[0]
        pair[0] = pair[1]
        pair[1] = tmp
      end
    end
  end

  def RankerLib.smart_comparison(ranks, a, b)
    a_score = score ranks, a
    b_score = score ranks, b
    a_remaining = remaining ranks, a
    b_remaining = remaining ranks, b

    # If one of the items in question cannot pass the rank of the other,
    # the user probably prefers it. No need to ask further questions.
    if a_score >= b_score + b_remaining
      return 1
    elsif b_score >= a_score + a_remaining
      return -1
    end

    # TODO if one or the other has significant enough lead (compared to the max_score).
    # For example 40% of the maximum score more than the other item, then the user probably prefers it.
    # Note that score belongs to range -max_score..max_score and as such to compare percentages one should normalize the scores by adding max_score
    # and then comparing the result of that sum to 2*max_score OR ignore negative values when determining score and compare the max_score.

    # If we reach this point, return nil as we probably need to ask the user to determine their preference. Unable to figure it out without asking.
    return nil
  end
end

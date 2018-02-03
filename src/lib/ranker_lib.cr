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

  def self.ask_comparison(item1 : String, item2 : String) : Int32
    puts "#{item1} or #{item2}? Press 1 for #{item1}, 2 for a tie or 3 for #{item2}."
    while true
      char = STDIN.raw &.read_char
      c = char
      if c == '1'
        puts "#{item1} > #{item2}"
        return 1
      elsif c == "2"
        puts "#{item1} = #{item2}"
        return 0
      elsif c == '3'
        puts "#{item1} < #{item2}"
        return -1
      end
    end
  end

  def self.compare_with_tiebreaker(ranks, a : String, b : String) : Int32
    res = (score ranks, a) <=> (score ranks, b)
    if res != 0
      return res
      # Tiebreaker - head to head result
    else
      return ranks[{a, b}]
    end
  end

  def self.score(ranks, a : String) : Int32
    acc = 0
    ranks.each do |key, value|
      if key[0] == a
        acc += value
      end
    end
    return acc
  end

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
end

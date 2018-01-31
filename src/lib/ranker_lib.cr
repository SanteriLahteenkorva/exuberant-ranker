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
end

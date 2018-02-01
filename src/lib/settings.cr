enum RankingMode
  GUESS
  ASK_ALL
end

class RankerSettings
  DEFAULT_RANKING_MODE  = RankingMode::GUESS
  DEFAULT_RANKABLE_FILE = ""

  def initialize
    @ranking_mode = DEFAULT_RANKING_MODE
    @rankable_file = DEFAULT_RANKABLE_FILE
  end

  def initialize(lines : Array(String))
    initialize
    @ranking_mode = DEFAULT_RANKING_MODE
    @rankable_file = DEFAULT_RANKABLE_FILE
    lines.each do |line|
      parts = line.split(" = ")
      # TODO: Generalise the reading of settings when more are added
      # (map possible values in file to possible values in program for enums etc. in a hash)
      case parts[0]
      # Setting the ranking mode
      when "ranking_mode"
        case parts[1]
        when "guess"
          @ranking_mode = RankingMode::GUESS
        when "ask_all"
          @ranking_mode = RankingMode::ASK_ALL
        else
        end
      when "rankable_file"
        # If the parameter given is indeed a file, use it.
        if File.file? parts[1]
          @rankable_file = parts[1]
        end
      end
    end
  end

  getter rankable_file : String
  getter ranking_mode : RankingMode
end

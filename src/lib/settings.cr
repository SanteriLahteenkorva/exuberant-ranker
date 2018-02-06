# TODO Something fun, not necessarily efficient. Swiss + playoff, double elim. with placing and smart ask all.
enum RankingMode
  GUESS
  ASK_ALL
  SORT
  SMART_ASK
end

class RankerSettings
  # TODO settings to add, ask_all randomized order
  DEFAULT_SETTINGS  = {"ranking_mode" => RankingMode::SORT, "rankable_file" => ""}
  RANKING_MODE_KEYS = {"guess" => RankingMode::GUESS, "ask_all" => RankingMode::ASK_ALL, "sort" => RankingMode::SORT, "smart_ask" => RankingMode::SMART_ASK}

  def initialize
    @settings = DEFAULT_SETTINGS
  end

  def initialize(lines : Array(String))
    initialize
    lines.each do |line|
      parts = line.split(" = ")
      # Check if the line is of correct format and if it starts with a proper setting name
      if parts.size == 2 && DEFAULT_SETTINGS.keys.includes? parts[0]
        set_setting parts[0], parts[1]
      end
    end
  end

  def set_setting(setting : String, value)
    case setting
    # Ranking mode is a special case
    when "ranking_mode"
      if RANKING_MODE_KEYS.keys.includes? value
        @settings[setting] = RANKING_MODE_KEYS[value]
      end
      # Settings where the value is a file
    when "rankable_file"
      if File.file? value
        @settings[setting] = value
      end
    end
  end

  def get_setting(setting : String)
    @settings[setting]
  end
end

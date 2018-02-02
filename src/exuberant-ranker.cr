require "./exuberant-ranker/*"
require "./lib/*"
require "option_parser"

# TODO: Write better documentation for `ExuberantRanker`
# The main module of the ranker.
module ExuberantRanker
  RankerLib.print_title

  rankable_file_path = ""
  settings_path = ""

  # Read the command line parameters
  OptionParser.parse! do |parser|
    parser.banner = "Usage: rank [arguments]"
    parser.on("-f FILEPATH", "--file=FILEPATH", "Specifies the file to read rankable items from") { |file_path| rankable_file_path = file_path }
    parser.on("-s FILEPATH", "--settings=FILEPATH", "Specifies the settings file with ranking settings to use") { |file_path| settings_path = file_path }
    parser.on("-h", "--help", "Show this help") { puts parser }
  end

  # Get ranking settings from a file if available
  settings = nil
  # Check if the path is valid.
  if settings_path.empty?
    # No file was given, use default settings.
    settings = RankerSettings.new
    puts "No settings file specified, using default settings."
  elsif !File.file? settings_path
    # if no file was found, use default settings.
    settings = RankerSettings.new
    puts "Unable to load settings file, using default settings instead."
  else
    puts "Was given settings file #{settings_path}."
    # get settings from the file
    settings = RankerSettings.new (File.read_lines settings_path)
    puts "Successfully loaded settings file."
  end

  # If the rankable file has not been given, but one is specified by the settings file, use that. If no file has been given either way, abort.
  srf = settings.get_setting "rankable_file"
  if rankable_file_path.empty? && srf.is_a? String && !srf.empty?
    rankable_file_path = srf
  end
  abort "No input file set.", 1 if rankable_file_path.empty?

  # If we reach this point, we have a file
  puts "Was given file #{rankable_file_path}."
  # Check if the path is valid.
  abort "File not found.", 1 if !File.file? rankable_file_path
  puts "Trying to open it."
  # Fetch the contents
  items = File.read_lines rankable_file_path
  # Only proceed if some items were received
  abort "Given file was empty.", 1 if items.empty?

  # Show the contents.
  if RankerLib.ask "Successfully opened the file. Do you want to see it's contents?"
    # If the answer is yes, print out the contents of the file.
    items.each do |line|
      puts "\t -#{line}"
    end
  end

  # Start ranking
  ranker = Ranker.new items, settings

  ranker.start_ranking_dialogue
end

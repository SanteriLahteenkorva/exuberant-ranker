require "./exuberant-ranker/*"
require "./lib/*"
require "option_parser"

# TODO: Write better documentation for `ExuberantRanker`
# The main module of the ranker.
module ExuberantRanker
  RankerLib.print_title

  rankable_file_path = ""

  # Read the command line parameters
  OptionParser.parse! do |parser|
    parser.banner = "Usage: rank [arguments]"
    parser.on("-f FILEPATH", "--file=FILEPATH", "Specifies the file to read rankable items from") { |file_path| rankable_file_path = file_path }
    parser.on("-h", "--help", "Show this help") { puts parser }
  end

  # Stop the program if no path has been received.
  abort "No input file set", 1 if rankable_file_path.empty?

  puts "Was given file #{rankable_file_path}"
  # Check if the path is valid.
  abort "File not found", 1 if !File.file? rankable_file_path
  puts "Trying to open it"
  # Fetch the contents
  items = File.read_lines rankable_file_path
  # Only proceed if some items were received
  abort "Given file was empty", 1 if items.empty?

  # Show the contents.
  if RankerLib.ask "Successfully opened the file. Do you want to see it's contents?"
    # If the answer is yes, print out the contents of the file.
    items.each do |line|
      puts "\t -#{line}"
    end
  end

  # TODO: Start ranking (create a separate ranker class to handle this)
  ranker = Ranker.new items

  ranker.start_ranking_dialogue

  # TODO: Implement reading settings from an ini file if such exists.
end

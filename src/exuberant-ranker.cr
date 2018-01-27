require "./exuberant-ranker/*"
require "option_parser"
require "file"

# TODO: Write documentation for `Exuberant::Ranker`
module Exuberant::Ranker
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
  items = File.read_lines rankable_file_path

  # Show the contents.
  puts "Successfully opened the file. It contains the following items:"
  items.each do |line|
    puts "\t -#{line}"
  end
end

require "./exuberant-ranker/*"
require "option_parser"

# TODO: Write documentation for `Exuberant::Ranker`
module Exuberant::Ranker
  rankable_file = nil

  # Read the command line parameters
  OptionParser.parse! do |parser|
    parser.banner = "Usage: rank [arguments]"
    parser.on("-f FILEPATH", "--file=FILEPATH", "Specifies the file to read rankable items from") { |file| rankable_file = file }
    parser.on("-h", "--help", "Show this help") { puts parser }
  end

  if rankable_file
    puts "Was given file #{rankable_file}"
  else
    puts "No file was given!"
  end
end

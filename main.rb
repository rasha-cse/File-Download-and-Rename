#require_relative 'includes'
require_relative 'methods'
require 'watir'
require_relative 'inputs/inputs'
require 'clipboard'
require 'roo'
require 'spreadsheet'
require 'fileutils'

start = Time.now
excel_file = Roo::Spreadsheet.open('inputs/Letter_Search.xlsx')

preferences = {
    download: {
        "prompt_for_download" => false,
        "directory_upgrade"   => true,
        "default_directory"   => File.dirname(__FILE__).gsub('/', '\\') + @download_directory
    }
}

context = getContext
@browser = Watir::Browser.new :chrome, headless: @headless_option,  options: {prefs: preferences} #, detach: true;

@browser.goto context
@browser.window.maximize
proceed_to_context
login_using @username, @password, @provider_code
(getLimit..excel_file.last_row).each do |row|
  puts "Row Number:" + row
  search_letter excel_file.cell(row,1).to_s.chomp
  puts excel_file.cell(row,1).to_s.chomp
  download
  rename excel_file.cell(row,2).to_s.chomp, excel_file.cell(row,1).to_s.chomp
end
#xrebel_remove

puts "It took " + ((Time.now - start)/60).to_s + " minutes"
puts "DONE!!!"

require 'roo'
require 'spreadsheet'

s1 = Roo::Spreadsheet.open('inputs/Letter_Search.xlsx')
(s1.first_row..s1.last_row).each do |row|
  puts s1.cell(row,1).to_s.chomp + " " + s1.cell(row,2).to_s.chomp
end
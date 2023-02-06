require_relative 'inputs/inputs'

def gotoDashboard
  @browser.link(text: 'Dashboard').click
end

def proceed_to_context
  if(@browser.button(text: 'Advanced').exists?)
    @browser.button(text: 'Advanced').click
    @browser.link(id: 'proceed-link').click
  end
end

def login_using(username, password, prov_code)
  @browser.text_field(id: 'loginName').set username
  @browser.text_field(id: 'password').set password
  @browser.text_field(id: 'providerCode').set prov_code
  @browser.button(id: 'submitButton').click

  while @browser.img(title: "Go to Dashboard").exists?
    @browser.img(title: "Go to Dashboard").click
  end

  while @browser.button(value: "I Agree").exists?
    @browser.button(value: "I Agree").click
  end
end

def xrebel_remove
  sleep 5
  @browser.iframe(index: 3).button(class: %w(top-edge__close close-button)).click if @browser.iframe(index: 3).button(class: %w(top-edge__close close-button)).exists?
end

def getContext
  puts "Please, Select the Context:"
  puts "1. https://secure.services.net"
  puts "2. https://192.168.0.48"
  puts "3. Any Other Context"
  n=gets.chomp
  case n.to_i
    when 1
      return	"https://secure.services.net"
    when 2
      return	"https://192.168.0.48"
    when 3
      puts "Enter local Context address."
      return gets.chomp
  end
end

def getLimit
  puts "From which row number do you want to process?"
  return gets.chomp.to_i
end

def search_letter(formid)
  @browser.goto @context + '/ma/letter/unifiedSearch'
  @browser.link(text: 'Clear Selection').click
  @browser.text_field(id: 'formId').set formid
  @browser.button(name: '_action_search').click
  @browser.table(id: 'dataList').tds[0].click if @browser.table(id: 'dataList').exists?
end

def download
  @browser.link(text: 'Download Word').click
  sleep 5
end

def rename(old_name, new_name)
  puts "Renaming files..."
  File.rename(File.dirname(__FILE__) + @rename_path + "/" + old_name + ".docx", File.dirname(__FILE__) + @rename_path + "/" + new_name + ".docx")
  puts "Renaming complete."
end

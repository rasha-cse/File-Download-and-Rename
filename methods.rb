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

  while @browser.button(value: "Agree").exists?
    @browser.button(value: "Agree").click
    sleep 1
    @browser.element(xpath: '/html/body/div[3]/div/div/div[2]/button[2]').click if @browser.element(xpath: '/html/body/div[3]/div/div/div[2]/button[2]').exists?
  end

end

def logout_n_login
  @browser.link(text: 'Logout').click
  @browser.link(text: 'Login Again').click
end

def xrebel_remove
  sleep 5
  @browser.iframe(index: 3).button(class: %w(top-edge__close close-button)).click if @browser.iframe(index: 3).button(class: %w(top-edge__close close-button)).exists?
end

def getContext
  puts "Please, Select the Context:"
  puts "1. https://secure.services.net"
  puts "2. https://192.168.0.48"
  puts "3. Alpha03 Context"
  puts "4. Any Other Context"
  n = gets.chomp
  case n.to_i
    when 1
      return	"https://secure.services.net"
    when 2
      return	"https://192.168.0.48"
    when 3
      return  "https://alpha03.services.net"
    when 4
      puts "Enter local Context address."
      return gets.chomp
  end
end

def getStaringRowToProcess(lines, excel_file)
  puts "After Login into #{excel_file.cell((lines.last.split(' ')[1].to_i + 1),5)}, Enter 'y' to continue:"
  #gets.chomp
  #return gets.chomp.to_i
  return (lines.last.split(' ')[1].to_i + 1)
end

def search_letter(formid)
  @browser.goto @context + '/ma/letter/unifiedSearch'
  sleep 3 #3
  while not @browser.link(text: 'Clear Selection').exists?
    p "--------------------------Clear Selection Refinding--------------------"
    sleep 2
  end
  @browser.link(text: 'Clear Selection').wait_until(&:enabled?).click
  @browser.text_field(id: 'formId').wait_until(&:enabled?).set formid
  @browser.button(name: '_action_search').wait_until(&:enabled?).click
  @browser.table(id: 'dataList').tds[0].wait_until(&:enabled?).click
end

def escape_error
  if @browser.div(class:"alert alert-danger").exists?
    gotoDashboard
  end
end

def download(old_filename)
  @browser.link(text: 'Download Word').wait_until(&:enabled?).click
  sleep 4 #12
  while File.exist?(File.dirname(__FILE__) + @rename_path + "/" + old_filename + ".crdownload")
    p "-----------------Waiting for download completion!---------------------"
    sleep 5
  end

  if File.zero?(File.dirname(__FILE__) + @rename_path + "/" + old_filename)
    p "------------------------ZERO FILE SIZE--------------------------"
    File.delete(File.dirname(__FILE__) + @rename_path + "/" + old_filename)
    download old_filename
  end
end

def rename(old_name, new_name)
  puts "Renaming files..."
  File.rename(File.dirname(__FILE__) + @rename_path + "/" + old_name, File.dirname(__FILE__) + @rename_path + "/" + new_name + ".docx") #old_name + ".docx" (for alpha03)
  puts "Renaming complete."
end

def log_entry(msg)
  File.open('output/'+ @log_file,'a+') do |f|
    f.puts "#{msg}"
  end
end

def doc_storage_upload(filename) #row_num,
  @browser.select_list(name: 'type').select 'Legacy'
  @browser.text_field(id: 'receivedDate').set '01/01/1970'
  @browser.button(value: 'Add File').wait_until(&:enabled?).click
  sleep 3

  @browser.execute_script("$('.input-group-addon')[3].click()", @browser.file_field) #file-input/input-group-addon[3]
  @browser.file_field.set (File.expand_path(@upload_file_path + filename))

  @browser.execute_script("$('.btn.btn-primary.upload')[1].click()")
  sleep 3 

  win = RAutomation::Window.new :title => /Open/
  win.close

  #@browser.button(value: 'Save').focus
  @browser.button(value: 'Save').wait_until(&:enabled?).click
  sleep 2 
  while @browser.button(value: 'Save').exists?
    p "--------------------------Save Button Refinding--------------------"
    sleep 2
    @browser.button(value: 'Save').focus
    @browser.button(value: 'Save').wait_until(&:enabled?).click
  end

  p form_id_msg = @browser.div(class: "alert alert-success text-center").text.split(' ')[2]
  log_doc_storage_formids filename, form_id_msg  #row_num,
end

def log_doc_storage_formids(filename, msg) #row_num,
  letter_form_id = filename.split('.')[0]
  File.open('output/'+ @doc_storage_log,'a+') do |f|
    f.puts "#{letter_form_id}" + ", " + "#{msg}"    #{row_num} +
  end
end

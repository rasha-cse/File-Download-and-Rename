@alpha03 = 'https://alpha03.services.net'
@secure = 'https://secure.services.net'

@context = @secure
@headless_option = false

@username = 'admin'
@password = 'abc123' 
@provider_code = 'HDD-BV'

@download_directory = '\downloadedLetters\\'
@rename_path = "/downloadedLetters"

@input_path = '/inputs/'
@input_filename = 'PRODUCTION.xlsx'
@log_file =  'log_file_' + @input_filename.split('.')[0] + '.log'
@doc_storage_log = 'doc_storage_form_id_' + @input_filename.split('.')[0] + '.log'
@doc_storage_link = '/ma/doc/agency' 
@upload_file_path = 'downloadedLetters/'

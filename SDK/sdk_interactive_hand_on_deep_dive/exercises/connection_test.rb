begin
  # load the Kinetic SDK
  require "kinetic_sdk"
rescue LoadError
  # SDK not found. Show a helpful error message and pass = false.
  puts"The Kinetic SDK is not installed, please install it first run: `gem install kinetic_sdk`\nRun this script again when the SDK is installed"
  pass = false
end

# find the directory of this script
PWD = File.expand_path(File.dirname(__FILE__))

# load the connection configuration file
begin
  config = YAML.load_file( File.join(PWD, "config.yaml") )
rescue
  raise StandardError.new "There was a problem loading the config.yaml file"
end

# Create space connection
conn = KineticSdk::Core.new({
  space_server_url: config["SERVER_URL"],
  space_slug: config["SPACE_SLUG"],
  username: config["SPACE_USERNAME"],
  password: config["SPACE_PASSWORD"],
  options: {
  }
})

#Defnine the forms that are expected to be found in the SDK Course Kapp. 
forms_expected = [
  "general-facilities-request",
  "general-finance-request",
  "general-hr-request",
  "general-it-request",
  "general-legal-request",
  "general-marketing-request"
]

# Set inital value of pass = true
pass = true

# Test the connection using a simple SDK method
response = conn.me()
puts "Response Code: #{response.status}"

# Check the connection status and handle errors accordingly
if response.status == 200
  puts "Connection successful"
elsif response.status == 401
  puts "Unable to authenticate, check the credentials."
  pass = false
elsif response.status == 404
  puts "Unable to connect to server, check the Server URL."
  pass = false
elsif response.status == 0
  puts response.message
  pass = false
else
  puts "unknown error"
  pass = false
end

# Check for the SDK Course Kapp
if conn.find_kapp("sdk-course").status == 200
  #Kapp found
  puts "SDK Course Kapp found"
  
  #Check for the Owning Team Attribute 
  if conn.find_form_attribute_definition("sdk-course","Owning Team").status == 200 
    puts "Owning Team Form Attriibute Found"
  else
    puts "Owning Team Form Attribute Not Found"
    pass = false
  end

  #Check if all expected forms are found in the SDK Course Kapp
  #Create an Array of forms found
  forms_found = (conn.find_forms('sdk-course').content['forms'] || []).map{|form| form['slug']}

  forms_expected.each{|form| 
    if !forms_found.include?(form)
      puts "The form '#{form}' was not found in the SDK Course Kapp"
      pass = false
    end
  }
  puts "All expected forms found in the SDK Course Kapp" if pass == true

else
  #Kapp not found
  puts "SDK Course Kapp not found"
  pass = false
end


if pass == true
  puts "Success! You have successfully connected to the server and ready to start."
else
  puts "Some tests failed! Please check the output above and the setup instructions."
end
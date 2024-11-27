begin
  require "kinetic_sdk"
rescue LoadError
  puts"The Kinetic SDK is not installed, please install it first run: `gem install kinetic_sdk`\nRun this script again when the SDK is installed"
  exit
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


response = conn.me()
puts "Response Code: #{response.status}"

if response.status == 200
  puts "Success! You have successfully connected to the server and ready to start."
elsif response.status == 401
  puts "Unable to authenticate, check credentials"
elsif response.status == 0
  puts response.message
else
  puts "unknown error"
end


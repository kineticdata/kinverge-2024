require "kinetic_sdk"

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
    log_level: config["LOG_LEVEL"],
  }
})

params = {
  "include"=>"details, attributesMap",
}
response = conn.find_form(config["KAPP"],"general-it-request",params)
puts response.content['form'].pretty_inspect

##### Add a form Attributes #####
#Set variable to the form object
form = response.content['form']

#Add value to the 'Owning Team' Attribute
form['attributesMap']['Owning Team']  = ["Default"]

puts form.pretty_inspect

#Update the form
conn.update_form(config["KAPP"],"general-it-request",form)
require "kinetic_sdk"

# find the directory of this script
PWD = File.expand_path(File.dirname(__FILE__))

# load the connection configuration file
begin
  config = YAML.load_file( File.join(PWD, "config.yaml") )
rescue
  raise StandardError.new "There was a problem loading the config.yaml file"
end

# configure the logger
logger = Logger.new(STDERR)
logger = Logger.new File.open(File.join("#{PWD}/output.log"), 'w')
logger.level = Logger::INFO
logger.formatter = proc do |severity, datetime, progname, msg|
  date_format = datetime.utc.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
  "[#{date_format}] #{severity}: #{msg}\n"
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
  "include"=>config["INCLUDE"],
  "q"=> config["QUERY"]
}


response = conn.find_forms(config["KAPP"], params)
puts response.content.pretty_inspect
puts response.content.keys
puts response.content['forms'].class

#Iterate through each form
response.content['forms'].each do |form|
  #Add an entry to the log
  logger.info "Updating the #{form['slug']} request"

  # Update the type of the form
  form['type'] = "Utility"
 
  #Set variables for form and owning_team
  owning_team = form['attributesMap']['Owning Team']

  # Update the Owning team
  if !owning_team || owning_team.empty?
    # No Owning Team attribute or value found. Add Attribute
    logger.info "Owning Team Attribute not found, add Attribute and Default"
    form['attributesMap']['Owning Team'] = ["Default"]
  elsif !owning_team.include?("Default")
    # Owning Team attribute found but does not contain Default. Add Default to it.
    logger.info "Owning Team Attribute found without Default, adding Default"
    owning_team.push("Default")
  else
    # Owning Team attribute found and contains Default. Do nothing
    logger.info "Owning Team Attribute found, no changes"
  end
 
  #Update the form
  conn.update_form(config["KAPP"],form['slug'],form)

end

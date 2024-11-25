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
      log_level: "INFO",
      max_redirects: 3
  }
})

# Define Teams to Add
teams = [
  "Engineering Services - HVAC",
  "Engineering Services - Other",
  "Engineering Services - General Facilities",
  "Engineering Services - Fire Protection",
  "Engineering Services - Safeguards and Security",
  "Engineering Services - Water Systems",
  "Engineering Services - Electrical"
]

# Find Users
response = conn.find_users()

# Get the users from the response
users = response.content['users'] 

# Iterate through the users
users.each do |user|
  # Get the username
  username = user['username'] 
  # Add Organization and Site to the User
  conn.add_user_attribute(username, "Organization", "IT")
  conn.add_user_attribute(username, "Site", "St. Paul")
  # Iterate through each team
  teams.each do |team|
    # Add each team to the User
    conn.add_team_membership(team, username)
  end
end



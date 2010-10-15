desc 'After_deploy callback'

task :before_deploy => :environment do |t, args|
  username = `git config codebase.username`.chomp.strip
  api_key  = `git config codebase.apikey`.chomp.strip
  
  if username == '' || api_key == ''
    puts "  * Codebase is not configured on your computer. Bundle the codebase gem and run 'codebase setup' to auto configure it."
    puts "  * Deployments will not be tracked."
    next
  end
end

task :after_deploy => :environment do |t, args|
  username = `git config codebase.username`.chomp.strip
  api_key  = `git config codebase.apikey`.chomp.strip
  branch = `git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'`.chomp.strip
  log_entry = `git log -n 1 --no-color --no-decorate`
  commit_match = log_entry.match(/commit (.*)/)
  real_revision = commit_match[1]
  
  if username == '' || api_key == ''
    puts "  * Codebase is not configured on your computer. Bundle the codebase gem and run 'codebase setup' to auto configure it."
    puts "  * Deployments will not be tracked."
    next
  end
  
  origin_name = (git_config_variable(:remote) || 'origin')
  remote_url  = git_config_variable("remote.#{origin_name}.url")
  if remote_url =~ /git\@(gitbase|codebasehq|cbhqdev)\.com:(.*)\/(.*)\/(.*)\.git/
    domain = $1
    account = $2
    project = $3
    repository = $4
  else
    raise Codebase::Error, "Invalid Codebase repository (#{remote_url})"
  end
  
  regex = /git\@(gitbase|codebasehq)\.com:(.*)\/(.*)\/(.*)\.git/
  unless m = remote_url.match(regex)
    puts "  * \e[31mYour repository URL does not a match a valid CodebaseHQ Clone URL (#{remote_url})\e[0m"
  else
    url = "#{m[2]}.codebasehq.com"
    project = m[3]
    repository = m[4]
  
    xml = []
    xml << "<deployment>"
    xml << "<servers>Heroku</servers>"
    xml << "<revision>#{real_revision}</revision>"
    xml << "<environment>#{@heroku_apps}</environment>"
    xml << "<branch>#{branch}</branch>"
    xml << "</deployment>"
  
    require 'net/http'
    require 'uri'
  
    real_url = "http://#{url}/#{project}/#{repository}/deployments"
    # puts "      -  URL..........: #{real_url}"
  
    url = URI.parse(real_url)
  
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth(username, api_key)
    req.add_field('Content-type', 'application/xml')
    req.add_field('Accept', 'application/xml')
    res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req, xml.join) }
    case res
    when Net::HTTPCreated then puts "  * \e[32mAdded deployment to Codebase\e[0m"
    else 
      puts "  * \e[31mSorry, your deployment was not logged in Codebase - please check your config above.\e[0m"
      puts "  * \e[31m#{res.to_yaml}\e[0m"
    end
  end
end

def git_config_variable(name)
  if name.is_a?(Symbol)
    r = `git config codebase.#{name.to_s}`.chomp
  else
    r = `git config #{name.to_s}`.chomp
  end
  r.empty? ? nil : r
end

HEROKU_CONFIG_FILE = Rails.root.join('config', 'heroku.yml')

def heroku_settings
  if File.exists?(HEROKU_CONFIG_FILE)
    YAML.load_file(HEROKU_CONFIG_FILE) 
  else
    {} 
  end
end
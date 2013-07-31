#
# DNA Shipistrano
#
# Htaccess - Provides ways of adjusting the .htaccess file
#
# Copyright (c) 2013, DNA Designed Communications Limited
# All rights reserved.

namespace :htaccess do
  namespace :auth do

    desc "Protect a given folder. Use set :auth_folder to protect"
    task :protect do
      run "#{try_sudo} htpasswd -nb #{auth_user} '#{auth_pass}' > #{auth_folder}/.htpasswd"
      backup_file("#{auth_folder}/.htaccess")
      prepend_to_file(
        "#{auth_folder}/.htaccess",
        "AuthType Basic\\nAuthName #{app}\\nAuthUserFile #{auth_folder}/.htpasswd\\nRequire User #{auth_user}\\n"
      )
    end
    
    desc "Unprotect latest version."
    task :unprotect_release do
      run "if [ -f #{auth_folder}/.htaccess.backup ]; then #{try_sudo} rm -rf #{auth_folder}/.htaccess && cp #{auth_folder}/.htaccess.backup #{auth_folder}/.htaccess; fi"
    end
  end

  desc "Rewrite base in htaccess file to /"
  task :rewritebase do
    append_to_file("#{latest_release}/.htaccess", "RewriteBase /")
  end

  def prepend_to_file(filename, str)
    run "echo -e \"#{str}\"|cat - #{filename} > /tmp/out && mv /tmp/out #{filename}"
  end

  def append_to_file(filename, str)
    run "echo -e \"#{str}\" >> #{filename}"
  end

  def backup_file(filename)
    run "#{try_sudo} cp #{filename} #{filename}.backup"
  end

end
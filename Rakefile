# frozen_string_literal: true

require 'erb'
require 'rake'
require 'rbconfig'

# List out the files to symlink and where they go to so that we can add helper
# scripts and such to this repo
SYMLINK_WHITELIST = {
  # Files
  'bash_aliases': nil,
  'bash_completion': nil,
  'bash_profile': nil,
  'bashrc': nil,
  'golangci.yml': nil,
  'gitconfig.erb': nil,
  'inputrc': nil,
  'irbrc': nil,
  'railsrc': nil,
  'screenrc': nil,
  'vimrc': nil,

  # dir
  'bash_completion.d': nil,
  'bin': 'bin', # dir, no name change
  'vim': nil,

  # NOTE: don't use stringify_keys but convert keys to strings with collect
}.collect { |k, v| [k.to_s, v] }.to_h.freeze

task default: :install

namespace :install do
  desc "install the dot files into user's home directory"
  task :files do
    puts 'installing dot files ...'
    replace_all = false
    Dir['*'].each do |file|
      # Continute unless we're symlinking this file
      next unless SYMLINK_WHITELIST.key?(file)

      target = SYMLINK_WHITELIST[file] || ".#{file}"

      # If we have a template suffix then we'll generate the file instead of
      # symlink
      case File.extname(file).downcase
      when '.erb'
        # Get target without template extension
        target = File.join(ENV['HOME'], File.basename(target, '.*'))

        # If the file doesn't exist write it
        if !File.exist?(target) || replace_all
          generate_file(target, file)
        else
          # Existing file, prompt to replace
          print "  overwrite #{target}? [ynaq] "
          case $stdin.gets.chomp
          when 'a'
            replace_all = true
            generate_file(target, file)
          when 'y'
            generate_file(target, file)
          when 'q'
            exit
          else
            puts "  skipping #{target}"
          end
        end

      else # no interplation, symlink
        # Get the target in home directory
        target = File.join(ENV['HOME'], target)
        link_file(target, file)
      end
    end
  end

  desc 'installs iterm2 preferences'
  task :iterm2 do
    puts 'installing iterm2 preferences ...'
    folder = '~/dotfiles/iterm2'
    ret = iterm_defaults_read('PrefsCustomFolder').strip
    if ret != folder
      puts "  changing preferences folder to #{folder}"
      iterm_defaults_write('PrefsCustomFolder', "-string \"#{folder}\"")
    end
    ret = iterm_defaults_read('LoadPrefsFromCustomFolder').strip
    if ret != '1'
      puts '  enabling custom folder'
      iterm_defaults_write('LoadPrefsFromCustomFolder', '-bool true')
    end
  end
end

desc 'install all the tooling for this OS'
task :install do
  Rake::Task['install:files'].invoke
  if RbConfig::CONFIG['host_os'].start_with?('darwin')
    Rake::Task['install:iterm2'].invoke
  end
end

def iterm_defaults_read(key)
  `defaults read com.googlecode.iterm2.plist #{key}`
end

def iterm_defaults_write(key, args)
  `defaults write com.googlecode.iterm2.plist #{key} #{args}`
end

def generate_file(target, file)
  puts "  generating #{target} from #{file}"
  content = ERB.new(File.read(file), nil, '-').result(binding)
  File.open(target, 'w') { |f| f.write content }
end

def link_file(target, file)
  puts "  linking #{target} to #{file}"
  if RbConfig::CONFIG['host_os'].start_with?('darwin')
    system %(ln -fhs "$PWD/#{file}" "#{target}")
  else
    system %(ln --force --no-target-directory --symbolic "$PWD/#{file}" "#{target}")
  end
end

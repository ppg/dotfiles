# frozen_string_literal: true

require 'rake'
require 'erb'

# List out the files to symlink and where they go to so that we can add helper
# scripts and such to this repo
SYMLINK_WHITELIST = {
  # Files
  'bash_aliases': nil,
  'bash_completion': nil,
  'bash_profile': nil,
  'bashrc': nil,
  'gitconfig.erb': nil,
  'inputrc': nil,
  'irbrc': nil,
  'railsrc': nil,
  'screenrc': nil,
  'vimrc.after': nil,

  # dir
  'bash_completion.d': nil,
  'bin': 'bin', # dir, no name change
  'janus': nil,

  # NOTE: don't use stringify_keys but convert keys to strings with collect
}.collect { |k, v| [k.to_s, v] }.to_h.freeze

task default: :install

desc "install the dot files into user's home directory"
task :install do
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
        print "overwrite #{target}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          generate_file(target, file)
        when 'y'
          generate_file(target, file)
        when 'q'
          exit
        else
          puts "skipping #{target}"
        end
      end

    else # no interplation, symlink
      # Get the target in home directory
      target = File.join(ENV['HOME'], target)
      link_file(target, file)
    end
  end
end

def generate_file(target, file)
  puts "generating #{target} from #{file}"
  content = ERB.new(File.read(file), nil, '-').result(binding)
  File.open(target, 'w') { |f| f.write content }
end

def link_file(target, file)
  puts "linking #{target} to #{file}"
  system %(ln -fhs "$PWD/#{file}" "#{target}")
end

require 'rake'
require 'erb'

NODOT = %w[bin].freeze

task default: :install

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE].include? file
    # Allow some files to symlink without dots
    target = NODOT.include?(file) ? file : ".#{file}"

    if File.exist?(File.join(ENV['HOME'], "#{target.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], "#{target.sub('.erb', '')}")
        puts "identical ~/#{target.sub('.erb', '')}"
      elsif replace_all
        replace_file(file, target)
      else
        print "overwrite ~/#{target.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file, target)
        when 'y'
          replace_file(file, target)
        when 'q'
          exit
        else
          puts "skipping ~/#{target.sub('.erb', '')}"
        end
      end
    else
      link_file(file, target)
    end
  end
end

def replace_file(file, target)
  system %(rm -rf "$HOME/#{target.sub('.erb', '')}")
  link_file(file, target)
end

def link_file(file, target)
  if file =~ /.erb$/
    puts "generating ~/#{target.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], "#{target.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file), nil, '-').result(binding)
    end
  else
    puts "linking ~/#{target}"
    system %(ln -s "$PWD/#{file}" "$HOME/#{target}")
  end
end

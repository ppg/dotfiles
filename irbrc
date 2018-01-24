if ENV['RAILS_ENV']
  load File.dirname(__FILE__) + '/.railsrc'
end

# IRB tab completion
require 'irb/completion'

# Use awesome_print gem for output
require 'rubygems'
require 'ap'
IRB::Irb.class_eval do
  def output_value
    ap @context.last_value
  end
end

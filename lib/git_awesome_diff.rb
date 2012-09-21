require 'grit'
require 'yard'
require 'active_support/all'
require 'colorize'

module GitAwesomeDiff
  autoload :VERSION, 'git_awesome_diff/version'
  autoload :Diff, 'git_awesome_diff/diff'
  autoload :Formatter, 'git_awesome_diff/formatter'
end

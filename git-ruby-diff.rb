require 'rubygems'
require 'bundler/setup'

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'git_awesome_diff'

PATH = '/Users/timurv/Develop/projects/capture_proof/absinthe.tmp'
REV1 = 'HEAD~10'
REV2 = 'master'

diff = GitAwesomeDiff.new(PATH).diff!(REV1, REV2)

puts "Diff between #{REV1}..#{REV2}\n\n"
puts "Added objects:\n\t#{diff.added_objects.join("\n\t")}\n\n" if diff.added_objects.present?
puts "Removed objects:\n\t#{diff.removed_objects.join("\n\t")}\n\n" if diff.removed_objects.present?

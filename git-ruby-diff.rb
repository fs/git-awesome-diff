require 'rubygems'
require 'bundler/setup'
require 'grit'
require 'yard'
require 'pp'
require 'active_support/all'

PATH = '/Users/timurv/Develop/projects/capture_proof/absinthe.tmp'

def repo
  Dir.chdir(PATH)
  @repo ||= Grit::Repo.new(PATH)
end

def repo_clean?
  repo.status.changed.merge(repo.status.added).merge(repo.status.deleted).blank?
end

def head_present?
 repo.head.present?
end

def save_head
  @saved_head = repo.head.name
end

def saved_head
  @saved_head
end

def parse_rev(rev)
  (repo.git.native 'rev-parse', {verify: true}, rev).chop
end

def checkout(rev)
  repo.git.native :checkout, {}, rev
end

def generate_yardoc
  YARD::Registry.clear
  YARD::CLI::Yardoc.run('--no-output', '--no-stats', '--no-save', '--quiet', '--exclude vendor', PATH)
  YARD::Registry.all.map {|o| o.path}
end

def puts_diff
  added_objects = (@registry[1] - @registry[0]).sort
  removed_objects = (@registry[0] - @registry[1]).sort

  puts "Added objects:\n\t#{added_objects.join("\n\t")}\n\n" if added_objects.present?
  puts "Removed objects:\n\t#{removed_objects.join("\n\t")}\n\n" if removed_objects.present?
end

save_head

raise "Repositiry should be clean" unless repo_clean?
raise "HEAD is unknow" unless head_present?

REV1 = parse_rev('HEAD~10')
REV2 = parse_rev('master')

begin
  @registry = []

  checkout(REV1)
  @registry << generate_yardoc

  checkout(REV2)
  @registry << generate_yardoc

  puts_diff
ensure
  checkout(saved_head)
end





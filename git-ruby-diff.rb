require 'rubygems'
require 'bundler/setup'
require 'grit'
require 'yard'
require 'pp'
require 'active_support/all'

PATH = '/Users/timurv/Develop/projects/flatsoft/test-git'

def checkout(ref)
  repo.git.native :checkout, {}, ref
end

def generate_yardoc
  Dir.chdir(PATH)
  # YARD::CLI::Yardoc.run('--no-output', '--no-stats', '--no-save', '--quiet')
  YARD::CLI::Yardoc.run('--no-save')
  YARD::Registry.all.map {|o| o.path}
end

def repo_clean?
  # repo.status.changed.merge(repo.status.added).merge(repo.status.deleted).blank?
  true
end

def head_present?
 repo.head.present?
end

def repo
  @repo ||= Grit::Repo.new(PATH)
end

def save_head
  @saved_head = repo.head.name
end

def saved_head
  @saved_head
end

raise "Repositiry should be clean" unless repo_clean?
raise "HEAD is unknow" unless head_present?

save_head

REF1 = '08b29befe24e7b4c7bd1706b1ab12f0242c9d733'
REF2 = 'HEAD'

begin
  @registry = []

  checkout(REF1)
  # @registry << generate_yardoc
  #
  # checkout(REF2)
  # @registry << generate_yardoc
  #
  pp @registry
ensure
  # checkout(head)
end





require 'grit'
require 'yard'
require 'active_support/all'

class GitAwesomeDiff
  attr_reader :path, :repo, :head, :errors, :added_objects, :removed_objects

  def initialize(path)
    @path = path

    load_repo

    validate!
    return false unless valid?

    save_head
  end

  def load_repo
    Dir.chdir(path)
    @repo = Grit::Repo.new(path)
  end

  def validate!
    @errors = []
    @errors << 'Repositiry should be clean' unless repo_clean?
    @errors << 'HEAD is unknow' unless head_present?
  end

  def valid?
    errors.blank?
  end

  def repo_clean?
    repo.status.changed.merge(repo.status.added).merge(repo.status.deleted).blank?
  end

  def head_present?
   repo.head.present?
  end

  def save_head
    @head = repo.head.name
  end

  def diff!(*refs)
    ref1 = parse_rev(refs.shift)
    ref2 = parse_rev(refs.shift || 'master')
    registry = []

    @added_objects, @removed_objects = [], []

    begin
      checkout(ref1)
      registry << generate_yardoc

      checkout(ref2)
      registry << generate_yardoc

      @added_objects = (registry[1] - registry[0]).sort
      @removed_objects = (registry[0] - registry[1]).sort
    ensure
      checkout(head)
    end

    self
  end

  def parse_rev(rev)
    (repo.git.native 'rev-parse', {verify: true}, rev).chop
  end

  def checkout(rev)
    repo.git.native :checkout, {}, rev
  end

  def generate_yardoc
    YARD::Registry.clear
    YARD::CLI::Yardoc.run('--no-output', '--no-stats', '--no-save', '--quiet', '--exclude vendor', path)
    YARD::Registry.all.map {|o| o.path}
  end
end
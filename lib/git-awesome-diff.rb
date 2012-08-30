require "git-awesome-diff/version"
require 'grit'
require 'yard'
require 'active_support/all'

module GitAwesomeDiff

  class AwesomeDiff
    attr_reader :path, :exclude_paths, :repo, :head, :errors, :added_objects, :removed_objects

    def initialize(path, exclude_paths = '')
      @path, @exclude_paths = path, exclude_paths

      load_repo

      validate!
      return false unless valid?

      save_head
    end

    def valid?
      errors.blank?
    end

    def diff!(*refs)
      ref1 = parse_rev(refs.shift || 'HEAD~1')
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

    private

    def load_repo
      Dir.chdir(path)
      @repo = Grit::Repo.new(path)
    end

    def validate!
      @errors = []
      @errors << 'Repository should be clean' unless repo_clean?
      @errors << 'HEAD is unknown' unless head_present?
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

    def parse_rev(rev)
      (repo.git.native 'rev-parse', {verify: true}, rev).chop
    end

    def checkout(rev)
      repo.git.native :checkout, {}, rev
    end

    def generate_yardoc
      options = ['--no-output', '--no-stats', '--no-save', '--quiet']
      options << "--exclude=#{exclude_paths}" if exclude_paths.present?
      options << path

      YARD::Registry.clear
      YARD::CLI::Yardoc.run(*options)
      YARD::Registry.all.map {|o| o.path}
    end
  end
end

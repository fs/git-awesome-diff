require 'tmpdir'

def create_test_repo
  repo_dir = Dir.mktmpdir
  repo_full_path = "#{repo_dir}/.git"
  `git --git-dir=#{repo_full_path} init`
  @repo = Grit::Repo.new(repo_full_path)

  fixtures = Dir[File.expand_path(File.dirname(__FILE__) + '/../fixtures/*.rb')]
  Dir.chdir(repo_dir)
  fixtures.each_with_index do |file, index|
    FileUtils.cp(file, 'test.rb')
    @repo.add 'test.rb'
    @repo.commit_all "commit #{index}"
  end

  repo_dir
end

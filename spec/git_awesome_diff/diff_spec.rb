require 'spec_helper.rb'

describe GitAwesomeDiff::Diff do

  before :all do
    @repo_path = create_test_repo
  end

  let(:awesome_diff) { GitAwesomeDiff::Diff.new(@repo_path) }
  subject { awesome_diff }

  its(:head) { should match 'master' }
  its(:repo) { should be_kind_of Grit::Repo }

  describe '#valid' do
    context 'when there is no errors' do
      it { should be_valid }
    end

    context 'when repo is not clean' do
      before do
        File.rename('test.rb', '1.rb')
      end

      after do
        File.rename('1.rb', 'test.rb')
      end

      it { should_not be_valid }

      describe 'errors' do
        subject { awesome_diff.errors }

        it { should_not be_empty }
        its(:first) { should match 'Repository should be clean' }
      end
    end

    context 'when there is no HEAD' do
      before do
        File.rename('.git/HEAD', '.git/HEAD_')
        `touch .git/HEAD`
      end

      after do
        File.rename('.git/HEAD_', '.git/HEAD')
      end

      it { should_not be_valid }

      describe 'errors' do
        subject { awesome_diff.errors }

        it { should_not be_empty }
        its(:first) { should match 'HEAD is unknown' }
      end
    end
  end

  describe '#diff!' do
    context 'when there are only added objects' do
      let(:diff) { awesome_diff.diff!('HEAD~3', 'HEAD~2') }

      describe 'added object' do
        subject { diff.added_objects }

        it { should_not be_empty }
        its(:first) { should match 'TestClass#first_method' }
      end

      describe 'removed objects' do
        subject { diff.removed_objects }

        it { should be_empty }
      end
    end

    context 'when there are both added and removed objects' do
      let(:diff) { awesome_diff.diff!('HEAD~1', 'master') }

      describe 'added objects' do
        subject { diff.added_objects }

        it { should_not be_empty }
        it { should == ['SecondClass', 'SecondClass#another_method', 'SecondClass#second_method', 'SecondClass#test_method'] }
      end

      describe 'removed objects' do
        subject { diff.removed_objects }

        it { should_not be_empty }
        it { should == ["TestClass", "TestClass#first_method", "TestClass#second_method"] }
      end
    end
  end
end

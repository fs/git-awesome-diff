require File.expand_path('../../lib/git-awesome-diff.rb', __FILE__)
include GitAwesomeDiff

REPO_PATH = File.expand_path('./spec/git-slog')

describe AwesomeDiff do
  let(:awesome_diff) { AwesomeDiff.new(REPO_PATH) }
  subject { awesome_diff }

  its(:head) { should match 'master' }
  its(:repo) { should be_kind_of Grit::Repo }

  describe '#valid' do
    context 'when there is no errors' do
      it { should be_valid }
    end

    context 'when repo is not clean' do
      before do
        File.rename('1.rb', '2.rb')
      end

      after do
        File.rename('2.rb', '1.rb')
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
        system('git checkout 12f6375 -q')
      end

      after do
        system('git checkout master -q')
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
      let(:diff) { awesome_diff.diff!('HEAD~2', 'HEAD~3') }

      describe 'added object' do
        subject { diff.added_objects }

        it { should_not be_empty }
        its(:first) { should match 'Test#second_method' }
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
        it { should == ['SecondClass', 'SecondClass#another', 'SecondClass#first_method', 'SecondClass#second'] }
      end

      describe 'removed objects' do
        subject { diff.removed_objects }

        it { should_not be_empty }
        it { should == ['AnotherClass', 'AnotherClass#another_method'] }
      end
    end
  end
end

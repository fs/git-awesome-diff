require File.expand_path('../../lib/git-awesome-diff.rb', __FILE__)
include GitAwesomeDiff

describe AwesomeDiff do

  REPO_PATH = File.expand_path('./spec/git-slog')

  subject { AwesomeDiff.new(REPO_PATH) }

  describe '#new' do
    it "should save current head" do
      subject.head.should match 'master'
    end

    it "should load repo" do
      subject.repo.should be_kind_of Grit::Repo
    end
  end

  describe '#valid' do
    context "when there is no errors" do
      it { should be_valid }
    end

    context "when repo is not clean" do
      before do
        File.rename('1.rb', '2.rb')
      end

      after do
        File.rename('2.rb', '1.rb')
      end

      it { should_not be_valid }

      it "should have one error" do
        subject.errors.count.should be_equal 1
        subject.errors.first.should match 'Repository should be clean'
      end
    end

    context "when there is no HEAD" do
      before do
        system('git checkout 12f6375 -q')
      end

      after do
        system('git checkout master -q')
      end

      it { should_not be_valid }

      it "should have one error" do
        subject.errors.first.should match 'HEAD is unknown'
      end
    end
  end

  describe '#diff!' do
    context "when there are only added objects" do
      before do
        @diff = subject.diff!('HEAD~2', 'HEAD~3')
      end

      it "should have added objects" do
        @diff.added_objects.count.should be_equal 1
        @diff.added_objects.first.should match 'Test#second_method'
      end

      it "should not have removed objects" do
        @diff.removed_objects.should be_empty
      end
    end

    context "when there are both added and removed objects" do
      before do
        @diff = subject.diff!('HEAD~1', 'master')
      end

      it "should have added objects" do
        @diff.added_objects.should == ["SecondClass", "SecondClass#another", "SecondClass#first_method", "SecondClass#second"]
      end

      it "should have removed objects" do
        @diff.removed_objects.should == ["AnotherClass", "AnotherClass#another_method"]
      end
    end
  end

end

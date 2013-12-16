require File.expand_path("../../spec_helper", __FILE__)

describe Gitcycle do
  describe "#feature" do

    let(:gitcycle) do
      Gitcycle::Config.config_path = config_path
      Gitcycle.new
    end

    let(:webmock_put) do
      {}
    end

    let(:webmock_post) do
      {
        :request => {
          :repo  => {
            :name => "git_repo",
            :user => { :login => "git_login" }
          }
        }
      }
    end

    before(:each) do
      gitcycle
      
      stub_const("Gitcycle::Git", GitMock)
      
      GitMock.load
      Gitcycle::Git.stub(:branches).and_return("source")

      gitcycle.stub(:sync)
    end

    def common_expectations(source="source", branch="name")
      Gitcycle::Git.should_receive(:branches).ordered.
        with(:current => true)
      
      Gitcycle::Git.should_receive(:checkout_remote_branch).ordered.
        with("repo:owner:login", "repo:name", source, :branch => branch)

      gitcycle.should_receive(:sync).ordered
    end

    context "with a lighthouse ticket" do

      let(:lighthouse_url) do
        "https://test.lighthouseapp.com/projects/0000/tickets/0000-ticket"
      end

      let(:webmock_post_with_lighthouse_url) do
        Gitcycle::Util.deep_merge(webmock_post,
          :request  => { :lighthouse_url => lighthouse_url },
          :response => {
            :lighthouse_url => lighthouse_url
          }
        )
      end

      before :each do
        webmock(:branch, :post, webmock_post_with_lighthouse_url)
        webmock(:branch, :put,  webmock_put)
      end

      context "when the user accepts the default branch" do

        before :each do
          $stdin.stub(:gets).and_return("y")
        end

        it "runs without assertions", :capture do
          gitcycle.feature(lighthouse_url)
        end

        it "calls Git with proper parameters", :capture do
          common_expectations
          gitcycle.feature(lighthouse_url)
        end

        it "displays proper dialog", :capture do
          gitcycle.feature(lighthouse_url)
          expect_output(
            "Your work will eventually merge into \"source\"",
            "Would you like to name your branch \"name\""
          )
        end
      end

      context "when the user changes the name of the branch" do

        before :each do
          $stdin.stub(:gets).and_return("y", "n", "new name")
        end

        it "runs without assertions", :capture do
          gitcycle.feature(lighthouse_url)
        end

        it "calls Git with proper parameters", :capture do
          common_expectations "source", "new-name"
          gitcycle.feature(lighthouse_url)
        end

        it "displays proper dialog", :capture do
          gitcycle.feature(lighthouse_url)
          expect_output(
            "Your work will eventually merge into \"source\"",
            "Would you like to name your branch \"name\"",
            "What would you like to name your branch?"
          )
        end
      end

      context "when the user changes the target branch" do

        let(:webmock_put_with_source) do
          Gitcycle::Util.deep_merge(webmock_put,
            :request  => { :source => 'new-source' },
            :response => { :source => 'new-source' }
          )
        end

        before :each do
          $stdin.stub(:gets).and_return("n", "new-source", "y")
          webmock(:branch, :put, webmock_put_with_source)
        end

        it "runs without assertions", :capture do
          gitcycle.feature(lighthouse_url)
        end

        it "calls Git with proper parameters", :capture do
          common_expectations "new-source"
          gitcycle.feature(lighthouse_url)
        end

        it "displays proper dialog", :capture do
          gitcycle.feature(lighthouse_url)
          expect_output(
            "Your work will eventually merge into \"source\"",
            "What branch would you like to eventually merge into?",
            "Would you like to name your branch \"name\""
          )
        end
      end
    end

    context "with a title" do

      let(:webmock_post_with_title) do
        Gitcycle::Util.deep_merge(webmock_post,
          :request  => { :title => 'new title' },
          :response => { :title => 'new title' }
        )
      end

      before :each do
        $stdin.stub(:gets).and_return("y")
        
        webmock(:branch, :post, webmock_post_with_title)
        webmock(:branch, :put,  webmock_put)
      end

      it "runs without assertions", :capture do
        gitcycle.feature("new title")
      end

      it "calls Git with proper parameters", :capture do
        common_expectations
        gitcycle.feature("new title")
      end

      it "displays proper dialog", :capture do
        gitcycle.feature("new title")
        expect_output(
          "Your work will eventually merge into \"source\"",
          "Would you like to name your branch \"name\""
        )
      end
    end

    context "with a github issue" do
      let(:github_url) { 'https://github.com/login/repo/pull/0000' }

      let(:webmock_post_with_github_url) do
        Gitcycle::Util.deep_merge(webmock_post,
          :request  => { :github_url => github_url },
          :response => { :github_url => github_url }
        )
      end

      before :each do
        $stdin.stub(:gets).and_return("y")
        
        webmock(:branch, :post, webmock_post_with_github_url)
        webmock(:branch, :put,  webmock_put)
      end

      it "runs without assertions", :capture do
        gitcycle.feature(github_url)
      end

      it "calls Git with proper parameters", :capture do
        common_expectations
        gitcycle.feature(github_url)
      end

      it "displays proper dialog", :capture do
        gitcycle.feature(github_url)
        expect_output(
          "Your work will eventually merge into \"source\"",
          "Would you like to name your branch \"name\""
        )
      end
    end

    context "when offline" do
      # TODO: develop offline mode
    end
  end
end
class Gitcycle < Thor

  desc "develop URL|TITLE", "Create or switch to a feature branch"
  def branch(url_or_title)
    require_git and require_config
    
    params = generate_params(url_or_title)
    branch = Api.branch(:create, params)

    change_target(branch, params)
    checkout_branch(branch)
    update_branch(branch)
  end

  no_commands do

    def change_name(name)
      unless yes?("Would you like to name your branch '#{name}'?")
        name = q("\nWhat would you like to name your branch?")
        name = name.gsub(/[\s\W]/, '-')
      end

      name
    end

    def change_target(branch, params)
      question = <<-STR
        Your work will eventually merge into "#{branch['source']}".
        Is this correct?
      STR

      unless yes?(question)
        params[:source] = q("What branch would you like to eventually merge into?")
      end
    end

    def checkout_branch(branch)
      owner = branch[:repo][:owner][:login]
      repo  = branch[:repo][:name]
      name  = change_name(branch[:name])

      branch[:home] ||= Config.git_login

      Git.checkout_remote_branch(owner, repo, branch[:source], :branch => name)
    end

    def generate_params(url_or_title)
      url, title = parse_url_or_title(url_or_title)
      params     = { :source => Git.branches(:current => true) }

      if url
        params.merge!(ticket_provider_params(url))
      elsif title
        params.merge!(:title => title)
      end

      params
    end
    
    def parse_url_or_title(url_or_title)
      if url_or_title =~ /^https?:\/\//
        [ url_or_title, nil ]
      else
        [ nil, url_or_title ]
      end
    end

    def ticket_provider_params(url)
      if url.include?('lighthouseapp.com/')
        { :lighthouse_url => url }
      elsif url.include?('github.com/')
        { :issue_url => url }
      else
        puts "Gitcycle only supports Lighthouse or Github Issue URLs.".space.red
        exit ERROR[:unrecognized_url]
      end
    end

    def update_branch(branch)
      Api.branch(:update,
        :home   => branch[:home],
        :name   => branch[:name],
        :source => branch[:source]
      )
    end
  end
end
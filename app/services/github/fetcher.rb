module Github
  class Fetcher

    attr_reader :client, :commit, :working_branch

    # @param [Github::Client] octokit client
    # @param [String, nil] commit sha key
    # @param [String, nil] working_branch branch name containing changes, not a base branch!
    def initialize(client, commit = nil, working_branch = nil)
      @client = client
      @commit = commit
      @working_branch = working_branch
    end

    # Fetches commit data.
    # @abstract
    def fetch
      raise NotImplementedError
    end
  end
end

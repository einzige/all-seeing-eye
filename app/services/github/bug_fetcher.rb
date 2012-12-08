module Github
  class BugFetcher < Fetcher

    # @param [Github::Client] octokit client
    # @param [String, nil] commit sha key
    # @param [String, nil] working_branch branch name containing changes, not a base branch!
    def initialize(client, commit = nil, working_branch = nil)
      super(client, commit, working_branch)
      @commit or raise ArgumentError, 'Commit must be provided'
    end

    # @overload
    # @return [Hashie::Mash] a hash representing the commit data
    def fetch
      client.commit(commit)
    end
  end
end

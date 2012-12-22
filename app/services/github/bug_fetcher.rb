module Github
  class BugFetcher < Fetcher

    # @param [Hash] options
    # @option options [String] :repo Repository name - required
    # @option options [String] :base_branch Your development branch
    # @option options [String] :working_branch The branch to take diff from
    # @option options [String] :commit
    def initialize(options)
      super(options)
      @commit or raise ArgumentError, 'Commit must be provided'
    end

    # @overload
    # @return [Hashie::Mash] a hash representing the commit data
    def fetch
      commit(@commit)
    end
  end
end

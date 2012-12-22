module Github
  class Fetcher < Octokit::Client

    attr_reader :base_branch, :repo, :working_branch

    # @param [Hash] options
    # @option options [String] :repo Repository name - required
    # @option options [String] :base_branch Your development branch
    # @option options [String] :working_branch The branch to take diff from
    # @option options [String] :commit Sha key of the commit
    def initialize(options)
      @repo           = options.delete(:repo) or raise ArgumentError, ':repo option must be provided'
      @base_branch    = options.delete(:base_branch)
      @working_branch = options.delete(:working_branch)
      @commit         = options.delete(:commit)

      super(options)
    end

    # Fetches commit data
    #
    # @overload
    # @param sha [String] the sha of the commit
    # @param options [Hash]
    # @return [Hashie::Mash] a hash representing the commit
    # @see http://developer.github.com/v3/repos/commits/
    def commit(sha, options = {})
      super(@repo, sha, options)
    end

    # Compare two commits
    #
    # @overload
    # @param start [String] the sha of the starting commit
    # @param endd [String] the sha of the ending commit
    # @return [Hashie::Mash] a hash representing the comparison
    # @see http://developer.github.com/v3/repos/commits/
    def compare(start, endd)
      super(@repo, start, endd)
    end

    # Fetches commit data.
    # @abstract
    def fetch
      raise NotImplementedError
    end

    # Returns last commit sha key.
    # @param [String] branch
    # @return [String] sha key of last commit
    def last_commit_sha(branch = @base_branch)
      if branch
        commits(@repo, branch, page: 1, per_page: 1)[0]['sha']
      else
        raise ArgumentError, 'Branch must be specified'
      end
    end

    # Strategy: fetches review request info
    # @param [Symbol] request_type
    # @param [Hash] options
    # @return [Hashie::Mash]
    def self.fetch(request_type, options)
      case request_type
        when :bug
          Github::BugFetcher.new(options)
        when :feature
          Github::FeatureFetcher.new(options)
        when :minor_change
          Github::MinorChangeFetcher.new(options)
        else
          raise ArgumentError, "Invalid request type: #{request_type}"
      end.fetch
    end
  end
end

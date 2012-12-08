module Github
  class Client < Octokit::Client

    attr_accessor :repo, :base_branch

    # @param [Hash] options
    # @option options [String] :base_branch The development branch name
    # @option options [String] :repo Repository name - required
    def initialize(options)
      @repo        = options.delete(:repo) or raise ArgumentError, ':repo option must be provided'
      @base_branch = options.delete(:base_branch)

      super(options)
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
  end
end

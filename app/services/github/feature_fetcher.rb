module Github
  class FeatureFetcher < Fetcher

    # Fetches last commit from base branch - Bc.
    # Fetches last commit form feature branch - Fc.
    # @overload
    # @return [Hashie::Mash] A hash representing the comparison with base branch
    def fetch
      last_base_commit    = client.last_commit_sha
      last_feature_commit = client.last_commit_sha(working_branch)

      client.compare(last_base_commit, last_feature_commit)
    end
  end
end


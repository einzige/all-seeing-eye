class User
  include Mongoid::Document

  field :login, type: String
  field :email, type: String

  has_many :review_requests do

    #def factory(request_type, application, commit = nil, working_branch = nil)

    def factory(request_type, commit = nil, working_branch = nil)
      case request_type
        when :bug
          fetcher = Github::BugFetcher.new(, commit, working_branch)
          request_data = fetcher.fetch

          request = ReviewRequest.new(request_data: request_data, branch_name: working_branch)
      end
    end
  end
end
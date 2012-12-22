class User
  include Mongoid::Document

  field :login,    type: String
  field :email,    type: String
  field :password, type: String

  has_many :review_requests, inverse_of: :requester do

    # Creates review request
    # @return [ReviewRequest]
    def factory(request_type, application, working_branch = application.base_branch, commit = nil)
      request = self.build(request_type: request_type,
                           application:  application,
                           branch:       working_branch)

      request.request_data = Github::Fetcher::fetch(request_type, { login:          request.requester.login,
                                                                    password:       request.requester.password,
                                                                    repo:           application.repo,
                                                                    base_branch:    application.base_branch,
                                                                    working_branch: working_branch,
                                                                    commit:         commit })
      request.save!
      request
    end
  end
end
class Application
  include Mongoid::Document

  DEFAULT_BASE_BRANCH = 'development'

  field :repo,        type: String
  field :name,        type: String
  field :base_branch, type: String

  has_many :review_requests

  before_save :set_branch

  private

  # Before save callback
  # Sets default branch as base branch if base branch is not set
  # @return [true]
  def set_branch
    self.base_branch ||= DEFAULT_BASE_BRANCH
    true
  end
end
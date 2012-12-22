class ReviewRequest
  include Mongoid::Document

  field :title,        type: String
  field :description,  type: String
  field :branch_name,  type: String
  field :files,        type: Hash
  field :author,       type: Hash
  field :request_type, type: Symbol

  belongs_to :requester, class_name: 'User'

  attr_accessor :request_data

  validates :request_type, inclusion: { in: [:bug, :feature, :minor_change] }

  before_save :parse_request_data

  private

  # Before save callback
  # Stores information in fields
  #
  # @return [true]
  def parse_request_data
    if request_data
      self.title, self.description = request_data['commit']['message'].split("\n\n")
      self.files = request_data['files']
      self.author = request_data['author']
    end

    true
  end
end
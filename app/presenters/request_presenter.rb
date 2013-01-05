class RequestPresenter

  # @param [ReviewRequest] request
  def initialize(request)
    @object = request
  end

  # @return [Array<Requests::FilePresenter>]
  def files
    @files ||= @object.files.map { |file| Requests::FilePresenter.new(file) }
  end
end
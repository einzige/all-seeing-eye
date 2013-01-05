module Requests
  class FilePresenter

    attr_reader :patch, :file

    # Returns GitHub file fields
    def [] (key)
      file[key.to_s]
    end

    # @param [Hash] file Github representation of file
    def initialize(file)
      @file = file
      @patch = file['patch']
    end

    def diffs
      @diffs ||= patch.split("\n@").map do |diff|
        Requests::DiffPresenter.new(diff)
      end
    end

    # Returns an array of line and line number for the future diff content
    # @return [Array<Array>]
    # @example [[0, 'zero'], [1, 'one'], [2, 'three'], [3, 'four']]
    def future
      @future ||= split_diff and @right
    end

    # Returns map representing line numbers for each line of changed file
    # @example [[1,'line one'], [1, nil], [2, 'line two']]
    # @return [Array<Integer, String|nil>]
    def future_map
      @future_map ||= begin
        i = 0
        future.map do |l|
          r = [i, l]
          i+=1 if l
          r
        end
      end
    end

    # Returns a list of lines
    # @return [Array<String>]
    def lines
      @lines ||= patch.split("\n")
    end

    # Returns an array of line and line numbers for the past content
    # @return [Array<Array>]
    # @example [[0, 'zero'], [1, 'one'], [2, 'three'], [3, 'four']]
    def past
      @past ||= split_diff and @left
    end

    # Returns map representing line numbers for each line of a file in the past
    # @example [[1,'line one'], [1, nil], [2, 'line two']]
    # @return [Array<Integer, String|nil>]
    def past_map
      @past_map ||= begin
        i = 0
        past.map do |l|
          r = [i, l]
          i+=1 if l
          r
        end
      end
    end

    def added
      @added ||= (split_diff and @added)
    end

    def removed
      @removed ||= (split_diff and @removed)
    end

    def changed
      @changed ||= (split_diff and @changed)
    end

    def mime_icon
      case self['filename'].match(/\.(\w+)$/)[1]
        when 'rb'
          'mimes/rb.png'
        else
          nil
      end
    end

    # Returns diff statistics including number of changes
    # @return [String]
    def stats
      "<b>#{self[:status]}</b>: <span class='green'>#{self[:additions]}</span> additions, <span class='red'>#{self[:deletions]}</span> deletions, <span class='yellow'>#{self[:changes]}</span> changes".html_safe
    end

    def line_class(l)
      if changed.include?(l)
        'changed'
      elsif added.include?(l)
        'new'
      elsif removed.include?(l)
        'removed'
      elsif future[l].starts_with?('@@')
        'heap'
      end
    end

    private

    # Splits diff into 2 columns
    # @see FilePresenter#future
    # @see FilePresenter#past
    # @return [true]
    def split_diff
      @left = []
      @right = []
      @changed = []
      @added = []
      @removed = []

      i = 0
      l = []
      r = []
      j = 0

      merge = Proc.new do
        max = [l.count, r.count].max
        min = [l.count, r.count].min

        if l.count > r.count
          @removed.concat (j+min...j+max).to_a
        elsif l.count < r.count
          @added.concat (j+min...j+max).to_a
        end

        if l.any? && r.any?
          @changed.concat (j...j+min).to_a
        end

        @left.concat(l.fill(nil, l.count...max))
        @right.concat(r.fill(nil, r.count...max))

        j += max

        l = []
        r = []
      end

      while i <= lines.size

        if i == lines.size
          merge.call
          break
        end

        line = lines[i]

        unless line.starts_with?('+') && l.any?
          merge.call
        end

        if line.starts_with?('-')
          while i < lines.size && lines[i].starts_with?('-')
            l << lines[i]
            i+=1
          end
        elsif line.starts_with?('+')
          while i < lines.size && lines[i].starts_with?('+')
            r << lines[i]
            i+=1
          end
        else
          @left << line
          @right << line
          l = []
          r = []
          i+=1
          j+=1
        end
      end
      true
    end
  end
end
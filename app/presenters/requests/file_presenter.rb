module Requests
  class FilePresenter

    attr_reader :diff, :file

    # Returns GitHub file fields
    def [] (key)
      file[key.to_s]
    end

    # @param [Hash] file Github representation of file
    def initialize(file)
      @file = file
      @diff = file['patch']
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
      @lines ||= diff.split("\n")
    end

    # Returns a list of changed line numbers
    # @return [Array<Integer>]
    def new_lines
      @new_lines ||= future_line_numbers - past_line_numbers
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

    # Returns diff statistics including number of changes
    # @return [String]
    def stats
      "#{self[:status]}: #{self[:additions]} additions, #{self[:deletions]} deletions, #{self[:changes]} changes"
    end

    private

    # Splits diff into 2 columns
    # @see FilePresenter#future
    # @see FilePresenter#past
    # @return [true]
    def split_diff
      @left = []
      @right = []

      i = 0
      l = []
      r = []

      merge = Proc.new do
        max = [l.count, r.count].max - 1

        @left.concat(l.fill(nil, l.count..max))
        @right.concat(r.fill(nil, r.count..max))

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
          l << line
          r << line
          i+=1
        end
      end
      true
    end
  end
end
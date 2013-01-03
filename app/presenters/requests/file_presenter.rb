module Requests
  class FilePresenter

    attr_reader :diff, :file

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

    def [] key
      file[key.to_s]
    end

    def stats
      "#{self[:status]}: #{self[:additions]} additions, #{self[:deletions]} deletions, #{self[:changes]} changes"
    end

    # @param [Hash] file Github representation of file
    def initialize(file)
      @file = file
      @diff = file['patch']
    end

    # Returns a list of changed line numbers
    # @return [Array<Integer>]
    def changed_line_numbers
      @changed_lines ||= future_line_numbers & past_line_numbers
    end

    # Returns diff format of lines without removed
    # @return [Array<String>]
    def diff_future_lines
      @diff_future_lines ||= diff.gsub(/^-.*\n/, '').split("\n")
    end

    # Returns diff format of lines without changes
    # @return [Array<String>]
    def diff_past_lines
      @diff_past_lines ||= diff.gsub(/^\+.*\n/, '').split("\n")
    end

    # Returns a number of uniq lines in the diff
    # @return [Integer]
    def diff_size
      @diff_size ||= lines.size - changed_line_numbers.size
    end

    # Returns an array of line and line number for the future diff content
    # @return [Array<Array>]
    # @example [[0, 'zero'], [1, 'one'], [2, 'three'], [3, 'four']]
    def future
      @future ||= split_diff and @right
    end

    # Returns lines without removed
    # @return [Array<String>]
    def future_lines
      @future_lines ||= diff.gsub(/^-.*\n/, '').gsub(/^\+/, '').split("\n")
    end

    # Returns a list of new and changed line numbers
    # @return [Array<Integer>]
    def future_line_numbers
      @future_line_numbers ||= diff_future_lines.size.times.map.find_all { |line_number| diff_future_lines[line_number].match(/^\+/) }
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

    #
    #def static_map
    #  @static_map ||= lines.size.times.map.to_a - future_map - past_map
    #end
    #
    #def clean_lines
    #  @clean_lines ||= diff.gsub(/^\+/, '').gsub(/^-/, '').split("\n")
    #end

    # Returns an array of line and line numbers for the past content
    # @return [Array<Array>]
    # @example [[0, 'zero'], [1, 'one'], [2, 'three'], [3, 'four']]
    def past
      @past ||= split_diff and @left
    end

    # Returns a list of changed and removed line numbers
    # @return [Array<Integer>]
    def past_line_numbers
      @past_line_numbers ||= diff_past_lines.size.times.map.find_all { |line_number| diff_past_lines[line_number].match(/^-/) }
    end

    def past_lines
      @past_lines ||= diff.gsub(/^\+.*\n/, '').gsub(/^-/, '').split("\n")
    end

    # Returns a list of removed line numbers
    # @return [Array<Integer>]
    def removed_lines
      @removed_lines ||= past_line_numbers - future_line_numbers
    end
  end
end
module Requests
  class FilePresenter < Struct.new(:diff)

    # Returns a list of changed line numbers
    # @return [Array<Integer>]
    def changed_line_numbers
      @changed_lines ||= future_line_numbers & past_line_numbers
    end

    # Returns diff format of lines without removed
    # @return [Array<String>]
    def diff_future_lines
      @diff_future_lines ||= diff.gsub(/^\-.*\n/, '').split("\n")
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
      res              = []
      diff_line_number = 0
      line_number      = 0

      while diff_line_number < diff_size do
        if new_lines.include?(line_number)
          res.insert(line_number, nil)
          res[line_number] = [line_number, future_lines[line_number]]
          line_number+=1
        elsif changed_line_numbers.include?(line_number)
          res << [line_number, future_lines[line_number]]
          line_number+=1
        elsif removed_lines.include?(diff_line_number)
          res << [line_number-1, nil]
        else
          res << [line_number, future_lines[line_number]]
          line_number+=1
        end

        diff_line_number+=1
      end
      res
    end

    # Returns lines without removed
    # @return [Array<String>]
    def future_lines
      @future_lines ||= diff.gsub(/^\-.*\n/, '').gsub(/^\+/, '').split("\n")
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

    # Returns an array of line and line numbers for the past content
    # @return [Array<Array>]
    # @example [[0, 'zero'], [1, 'one'], [2, 'three'], [3, 'four']]
    def past
      res              = []
      diff_line_number = 0
      line_number      = 0

      while diff_line_number < diff_size do
        if new_lines.include?(line_number)
          res << [line_number-1, nil]
        elsif changed_line_numbers.include?(line_number)
          res << [line_number, past_lines[line_number]]
          line_number+=1
        elsif removed_lines.include?(diff_line_number)
          res.insert(line_number, nil)
          res[line_number] = [line_number, past_lines[line_number]]
          line_number+=1
        else
          res << [line_number, past_lines[line_number]]
          line_number+=1
        end

        diff_line_number+=1
      end
      res
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
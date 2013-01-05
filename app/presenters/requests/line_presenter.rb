module Requests
  class LinePresenter < Struct.new(:diff, :l)

    def first?
      l == 0
    end

    def heap?
      klass == :heap
    end

    def change?
      [:new, :removed].include?(klass)
    end

    def new?
      klass == :new
    end

    def removed?
      klass == :removed
    end

    def source
      @source ||= diff.past[l]
    end

    def past
      @p ||= source.to_s.gsub(/\s/, '&nbsp;').gsub(/^-/, '').html_safe
    end

    def future
      @f ||= diff.future[l].to_s.gsub(/\s/, '&nbsp;').gsub(/^\+/, '').html_safe
    end

    def past_number
      @past_number ||= heap? ? '...' : diff.past_map[l].first + diff.offset - 1
    end

    def future_number
      @future_number ||= heap? ? '...' : diff.future_map[l].first + diff.offset - 1
    end

    def opts
      {class: klass, id: "p#{past_number}f#{future_number}"}
    end

    def klass
      @klass ||= if diff.changed.include?(l)
        :changed
      elsif diff.added.include?(l)
        :new
      elsif diff.removed.include?(l)
        :removed
      elsif diff.future[l].starts_with?('@')
        :heap
      end
    end
  end
end
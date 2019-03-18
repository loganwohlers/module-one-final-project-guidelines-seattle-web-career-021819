class Park < ActiveRecord::Base
    has_many :favorites
    has_many :users, through: :favorites
    has_many :state_parks
    has_many :states, through: :state_parks

    def to_s
      <<~PARK_INFO

        #{shorten_lines("DESIGNATION: #{self.designation}")}

        #{shorten_lines("DESCRIPTION: #{self.description}")}

        #{shorten_lines("WEATHER: #{self.weather}")}

        URL: #{self.url}
      PARK_INFO
    end

    # break up the long string into lines that are at most 70 characters long
    def shorten_lines(string)
      # \s* means ignore spaces at the beginning of a line
      # .{1,70} means get 1-70 characters
      # \b means that we won't break up the middle of a word
      lines = string.scan(/\s*(.{1,70}\b)/)
      # return all the lines as a single multi-line string
      lines.join("\n")
    end
end

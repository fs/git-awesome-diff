require 'active_support/all'
require 'colorize'

module GitAwesomeDiff
  class Formatter

    def initialize(added_objects, removed_objects)
      @added = added_objects
      @removed = removed_objects
    end

    def print(format, *args)
      puts "Showing diff between #{args[0]} and #{args[1]}\n".colorize(:black)
      case format
      when /pretty/ then pretty_print
      when /simple/ then simple_print
      end
    end

    private

    def pretty_print
      if @added.present?
        puts "Added objects:"
        puts "\t" + @added.join("\n\t").colorize(:green)
      end
      puts
      if @removed.present?
        puts "Removed objects:"
        puts "\t" + @removed.join("\n\t").colorize(:red)
      end
    end

    def simple_print
      puts "+#{@added.join("\n+")}\n\n" if @added.present?
      puts "-#{@removed.join("\n-")}\n\n" if @removed.present?
    end
  end
end

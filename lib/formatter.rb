require 'active_support/all'

class Formatter

  def initialize(added_objects, removed_objects)
    @added = added_objects
    @removed = removed_objects
  end

  def print(format = 'pretty')
    case format
    when /pretty/ then pretty_print
    when /simple/ then simple_print
    end
  end

  private

  def pretty_print
    puts "Added objects:\n\t#{@added.join("\n\t")}\n\n" if @added.present?
    puts "Removed objects:\n\t#{@removed.join("\n\t")}\n\n" if @removed.present?
  end

  def simple_print
    puts "+#{@added.join("\n+")}\n\n" if @added.present?
    puts "-#{@removed.join("\n-")}\n\n" if @removed.present?
  end
end

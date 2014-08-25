# ------- Roman Numerals ----------
  # For section titles, etc.
  # based on http://www.dreamincode.net/code/snippet4627.htm by EdwinNameless (thank you!)
  # We add the to_roman method to Integer to make it as easy as possible
  
module Romanizable

  def to_roman
    result = ""
    # Hash holding the roman values
    # Values above 3999 are not accepted, as numerals with bars are required.
    roman_map = Hash[ 1000 => "M", 900 => "CM", 500 => "D", 400 => "CD", 100 => "C", 90 => "XC", 50 => "L", 40 => "XL", 10 => "X", 9 => "IX", 5 => "V", 4 => "IV", 1 => "I"]
    
    arabic = self
    if arabic < 4000
      # Sort the keys, highest value (1000) first, then descending,
      # and parse values
      roman_map.keys.sort{ |a,b| b <=> a }.each do
        |n|
        # get roman numeral until the arabic number is too small,
        # in which case we'll try the smaller roman values
        while arabic >= n
          arabic = arabic-n
          result << roman_map[n]
        end
      end
    else
      raise ArgumentError, "number must be less than 4000!"
    end
    return result
  end

end

module MinutesAndSecondsConvertable
  
  def to_minutes_and_seconds
    total_minutes = self / 1.minutes
    seconds_in_last_minute = self - total_minutes.minutes.seconds

    # prepend a zero to seconds place if needed
    if seconds_in_last_minute.to_s.length == 1
      seconds_in_last_minute = "0#{seconds_in_last_minute}"
    end

    return "#{total_minutes}:#{seconds_in_last_minute}"
  end

end

Integer.send(:include, Romanizable)
Integer.send(:include, MinutesAndSecondsConvertable)
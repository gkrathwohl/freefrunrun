class Result < ApplicationRecord
  belongs_to :race
  belongs_to :athlete, optional: true

  def time_as_string
    seconds = padded_int((time / 1000) % 60)
    minutes = padded_int(time / (1000 * 60) % 60)

    puts seconds

    return minutes + ":" + seconds
  end
  
  def padded_int(i)
    if(i < 10)
      return "0" + i.to_s();
    else
      return i.to_s();
    end
  end

end

class Array
  def average(as_float=true)
    if as_float
      float_average
    else
      integer_average
    end 
  end

  def integer_average
    (sum / count) unless empty?
  end
  
  def float_average
    (sum / count.to_f) unless empty?
  end
end
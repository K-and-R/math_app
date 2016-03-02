class Fixnum
  # Ruby factorial function
  def factorial
    result = 1
    num = self
    self.times do
      result *= num
      num -= 1
    end
    result
  end

  def to_!
    factorial
  end

  # Ruby termial function
  def termial
    result = 0
    num = self
    self.times do
      result += num
      num -= 1
    end
    result
  end

  def to_?
    termial
  end
end

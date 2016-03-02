class String
  def titleize(options = {})
    exclusions = options[:exclude]
    return ActiveSupport::Inflector.titleize(self) unless exclusions.present?
    self.underscore.humanize.gsub(/\b(['’`]?(?!(#{exclusions.join('|')})\b)[a-z])/) { $&.capitalize }
  end

  def slugify
    # strip the string
    ret = self.strip
    # blow away apostrophes
    ret.gsub!(/['`]/, "")
    # @ --> at, and & --> and
    ret.gsub!(/\s*@\s*/, " at ")
    ret.gsub!(/\s*&\s*/, " and ")
    # replace all non alphanumeric, underscore or periods with underscore
    ret.gsub!(/\s*[^A-Za-z0-9\.\-]\s*/, '_')
    # convert double underscores to single
    ret.gsub!(/_+/, "_")
    # strip off leading/trailing underscore
    ret.gsub!(/\A[_\.]+|[_\.]+\z/, "")
    # lowercase
    ret.downcase
  end

  def trim_leading(n,count=nil)
    if count
      self.gsub!(/^#{n}{,#{count}}/,'') || self
    else
      self.gsub!(/^#{n}+/,'') || self
    end
  end

  def trim_trailing(n,count=nil)
    if count
      self.gsub!(/#{n}{,#{count}}$/,'') || self
    else
      self.gsub!(/#{n}+$/,'') || self
    end
  end
end

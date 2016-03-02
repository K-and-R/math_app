class OpenStruct
  def to_json
    recurse(to_h).to_json
  end

  def delete(key)
    delete_field(key) if respond_to?(key)
  end

  def key?(key)
    !!respond_to?(key)
  end
  alias_method :has_key?, :key?

private

  def recurse(val)
    case val
    when OpenStruct
      recurse(val.to_h)
    when Hash
      Hash[val.map {|k,v| [k, recurse(v)] }]
    when Array
      val.map do |v|
        recurse(v)
      end
    else 
      val
    end
  end
end

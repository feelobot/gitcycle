class Gitcycle < Thor
  class Util
    class <<self

      def deep_merge(hash, other_hash)
        other_hash.each_pair do |k,v|
          tv = hash[k]
          hash[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? deep_merge(tv, v) : v
        end
        hash
      end
      
      def symbolize_keys(hash)
        hash.inject({}) do |memo, (key, value)|
          key       = (key.to_sym rescue key) || key
          value     = symbolize_keys(value)   if value.is_a?(Hash)
          memo[key] = value
          memo
        end
      end
    end
  end
end
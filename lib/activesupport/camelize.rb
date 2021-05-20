# frozen_string_literal: true
# rubocop:disable all

class String
  # Converts strings to UpperCamelCase.
  #
  # Also converts '/' to '::' which is useful for converting
  # paths to namespaces.
  #
  #   camelize('active_model')                # => "ActiveModel"
  #   camelize('active_model/errors')         # => "ActiveModel::Errors"
  #
  # Modified copy of +ActiveSupport::Inflector.camelize+.
  # Since I did not need those features, I removed the handling of the +:lower+ parameter and the
  # handling of acronyms.
  # https://github.com/rails/rails/blob/v6.1.3.1/activesupport/lib/active_support/inflector/methods.rb
  def camelize
    string = to_s
    string = string.sub(/^[a-z\d]*/) { |match| match.capitalize! || match }
    string.gsub!(%r{(?:_|(/))([a-z\d]*)}i) do
      word        = Regexp.last_match(2)
      substituted = word.capitalize! || word
      Regexp.last_match(1) ? "::#{substituted}" : substituted
    end
    string
  end

  def constantize
    Object.const_get(self)
  end
end
# rubocop:enable all

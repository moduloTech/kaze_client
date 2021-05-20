# frozen_string_literal: true

# I only need some very specific parts of activesupport.
require "activesupport/blank"
require "activesupport/camelize"

# Require HTTParty
require "httparty"

# Require the version number
require_relative "lastbill_client/version"

# Require the different parts of the gem
require_relative "lastbill_client/errors"
require_relative "lastbill_client/requests"
require_relative "lastbill_client/response"
require_relative "lastbill_client/client"

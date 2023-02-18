# frozen_string_literal: true

# I only need some very specific parts of activesupport.
require 'activesupport/blank'
require 'activesupport/camelize'

# Require third-party libraries
require 'pathname'
require 'httparty'
require 'jsonpath'

# Require the version number
require_relative 'kaze_client/version'

# Require the different parts of the gem
require_relative 'kaze_client/json_utils'
require_relative 'kaze_client/data_utils'
require_relative 'kaze_client/errors'
require_relative 'kaze_client/requests'
require_relative 'kaze_client/response'
require_relative 'kaze_client/client'

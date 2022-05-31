# frozen_string_literal: true

# The base request object - for custom/newest APIs
require_relative "request/request"

# Modules included in requests
require_relative "request/requests/utils/authentified_request"
require_relative "request/requests/utils/list_request"

# The base object for pre-crafted requests
require_relative "request/requests/utils/final_request"

# The pre-crafted requests
require_relative "request/requests/assign_performer_request"
require_relative "request/requests/partners_request"
require_relative "request/requests/create_job_request"
require_relative "request/requests/job_request"
require_relative "request/requests/job_workflow_request"
require_relative "request/requests/job_workflows_request"
require_relative "request/requests/jobs_request"
require_relative "request/requests/login_request"
require_relative "request/requests/profile_request"
require_relative "request/requests/update_template_request"

# frozen_string_literal: true

# The base request object - for custom/newest APIs
require_relative 'request/request'

# Modules included in requests
require_relative 'request/requests/utils/authentified_request'
require_relative 'request/requests/utils/list_request'

# The base object for pre-crafted requests
require_relative 'request/requests/utils/final_request'

# The pre-crafted requests

# => Jobs
require_relative 'request/requests/jobs/assign_performer_request'
require_relative 'request/requests/jobs/create_job_request'
require_relative 'request/requests/jobs/job_request'
require_relative 'request/requests/jobs/job_workflow_request'
require_relative 'request/requests/jobs/job_workflows_request'
require_relative 'request/requests/jobs/jobs_request'
require_relative 'request/requests/jobs/update_template_request'

# => Collections
require_relative 'request/requests/collections/collection_request'
require_relative 'request/requests/collections/collections_request'
# => => Items
require_relative 'request/requests/collections/items/item_request'
require_relative 'request/requests/collections/items/items_request'

# => General
require_relative 'request/requests/login_request'
require_relative 'request/requests/partners_request'
require_relative 'request/requests/profile_request'
require_relative 'request/requests/upload_image_request'
require_relative 'request/requests/users_request'

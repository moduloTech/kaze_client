# CHANGELOG

## [Unreleased]

- Add new request: list items linked to a collection.
- Add new request: Create a job from it's workflow.
- Add new request: Update a collection's item.
- Add new request: Update a job's cell.
- Add new request: Delete a collection's item.
- Fetch the details for the given user.

## [0.4.0] - 2023-09-12

- Require `AddTagRequest`
- Add new requests:
  - List all tags
  - Get details about one tag
  - Complete step
- Update bundler and dependencies

## [0.3.2.2] - 2023-05-31

- Add new requests:
  - Upload activestorage attachment
  - List the collections for the company of the current user
  - Fetch the details for the given collection id
  - List the items assigned to the collection id
  - Fetch the details for the given item id from the given collection id
  - Add tags to a job
  - Create a collection item
  - Create a link between 2 collection items
- Fix handling of 404 HTTP status.

## [0.3.1] - 2022-11-30

- Update error handling for more clarity.

## [0.3.0] - 2022-09-28

- Add new requests:
  - Cancel job
  - Get job document
  - List users
  - Upload image

## [0.2.1] - 2022-06-17

- Add methods and utilities to get and set data in the response.

## [0.2.0] - 2022-06-01

- Allow to set the authentication token on the client skipping login step.

## [0.1.1p0] - 2022-05-31

- Replace KazeClient::CompaniesRequest (/api/companies) with KazeClient::PartnersRequest (/api/partners).
- Upgrade rubocop.

## [0.1.1] - 2022-05-31

- Rename the gem to KazeClient to follow the rebranding of LastBill to Kaze.

## [0.1.0] - 2021-05-20

- Initial release.
- Requests to:
  - login,
  - fetch data about logged in user,
  - fetch and close jobs.

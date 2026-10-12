--- Creates transformer role, gives the role to the user and grants permissions on the account.
CREATE ROLE transformer;;
GRANT ROLE transformer TO USER gmont;
GRANT ALL ON ACCOUNT TO transformer;

--- Creates the OAUTH object on the account and authorizes the new role.
CREATE OR REPLACE SECURITY INTEGRATION oauth_dbt
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = CUSTOM
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'
  OAUTH_REDIRECT_URI = 'https://rm338.us1.dbt.com/complete/snowflake'
  OAUTH_ISSUE_REFRESH_TOKENS = TRUE
  OAUTH_REFRESH_TOKEN_VALIDITY = 7776000
  OAUTH_USE_SECONDARY_ROLES = 'NONE'
  ALLOWED_ROLES_LIST = ('TRANSFORMER');

--- Gets the oauth client id and secret for configuration in dbt platform.
--- (Snippet comes from dbt documentation)
--- https://docs.getdbt.com/docs/platform/manage-access/set-up-snowflake-oauth?version=2
with
integration_secrets as (
  select parse_json(system$show_oauth_client_secrets('OAUTH_DBT')) as secrets
)
select
  secrets:"OAUTH_CLIENT_ID"::string     as client_id,
  secrets:"OAUTH_CLIENT_SECRET"::string as client_secret
from
  integration_secrets;
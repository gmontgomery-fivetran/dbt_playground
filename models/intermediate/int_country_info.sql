select 
    country_name,
    language_name as native_language
from {{ ref('stg_dbt_graham__country_langs') }}
join {{ ref('stg_dbt_graham__country') }} using (country_code)
join {{ ref('stg_dbt_graham__lang') }} where native_lang = language_abbr
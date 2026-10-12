{%- set language_filters = config.get('meta', {}).get('language_filters', 'country_name') -%}

with source as (

    {{ playground.language_streams_filters('pct_of_country_streams', language_filters) }}

)

select
    source.*,
    exists (
        select 1
        from {{ ref('int_country_info') }} as ci
        where ci.country_name = source.country_name
          and ci.native_language = source.language_name
    ) as is_native_language
from source

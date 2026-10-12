{%- set language_filters = config.get('meta', {}).get('language_filters', 'country_name, chart_year') -%}

{{ playground.language_streams_filters('pct_of_yearly_streams_by_country', language_filters) }}

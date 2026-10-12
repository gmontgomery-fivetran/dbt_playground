{% test assert_valid_language_filter(model) %}

{#-
    Validates the `language_filters` value (from config.meta) that a model passes
    to the language_streams_filters macro. A valid filter is either empty, or a
    comma-separated list where every column is one of the "extra" dimension
    columns of int_track_streams_by_language_year_country -- that is, any of its
    columns except language_name (always grouped by the macro) and total_streams
    (the aggregated measure). The test returns one row per invalid column, so it
    passes only when every filter column is allowed.
-#}

{%- set reserved = ['language_name', 'total_streams'] -%}
{%- set allowed = [] -%}
{%- set filter_columns = [] -%}
{%- set invalid_columns = [] -%}

{#- ref() must be resolved unconditionally so dbt can infer the dependency -#}
{%- set source_relation = ref('int_track_streams_by_language_year_country') -%}

{%- if execute -%}

    {#- allowed = intermediate model columns, minus the reserved ones -#}
    {%- for col in adapter.get_columns_in_relation(source_relation) -%}

        {%- if (col.name | lower) not in reserved -%}
            {%- do allowed.append(col.name | lower) -%}
        {%- endif -%}
    {%- endfor -%}

    {#- read the filters this model passes to the macro, from config.meta -#}
    {%- set filters = '' -%}
    {%- for node in graph.nodes.values()
            if node.resource_type == 'model'
            and (node.name | lower) == (model.identifier | lower) -%}
        {%- set filters = (node.config.get('meta', {}) or {}).get('language_filters', '') -%}
    {%- endfor -%}

    {#- split the filter string into individual columns -#}
    {%- if filters and (filters | trim | length) > 0 -%}
        {%- for col in filters.split(',') -%}
            {%- do filter_columns.append(col | trim | lower) -%}
        {%- endfor -%}
    {%- endif -%}

    {#- collect any filter column that is not an allowed extra column -#}
    {%- for col in filter_columns if col not in allowed -%}
        {%- do invalid_columns.append(col) -%}
    {%- endfor -%}

{%- endif -%}

select invalid_filter_column
from (
    {% if invalid_columns | length > 0 %}
        {% for col in invalid_columns %}
        select '{{ col }}' as invalid_filter_column
        {%- if not loop.last %}
        union all
        {%- endif %}
        {% endfor %}
    {% else %}
        select cast(null as {{ dbt.type_string() }}) as invalid_filter_column
    {% endif %}
) validation
where invalid_filter_column is not null

{% endtest %}


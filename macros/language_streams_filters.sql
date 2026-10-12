{% macro language_streams_filters(pct_col_name, filters) %}

with streams as (

    select
        language_name,
        {% if filters %}
            {{ filters }},   
        {% endif %}
        SUM(total_streams) as total_streams
    from {{ ref('int_track_streams_by_language_year_country') }}
    group by language_name
    {% if filters %}
        ,{{ filters }}
    {% endif %}

)

select
    *,
    round(
        total_streams / sum(total_streams) over
        {% if filters %}
            (partition by {{ filters }}) * 100,
        {% else %}
            (),
        {% endif %}               
        2
    ) as {{ pct_col_name }}
from streams
order by 
{% if filters %}
    {{ filters }},
{% endif %} 
    total_streams desc
    
{% endmacro %}
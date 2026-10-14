{% macro get_total_streams_by_year(year) %}

select 
    track_name,
    artist_name,
    SUM(total_streams) as total_streams,
from {{ ref('int_track_streams_by_language_year_country') }}
{% if year and year != '*' %}
    where chart_year = {{ year }}
{% endif %}
group by track_name, artist_name

{% endmacro %}
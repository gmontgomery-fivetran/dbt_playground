select
    language_name,
    SUM(total_streams) as total_streams
from {{ ref('dim_total_track__streams') }}
group by language_name
order by total_streams desc
select
    track_id,
    track_name,
    artist_name,
    language_name
from {{ ref('stg_dbt_graham__track') }}
join {{ ref('stg_dbt_graham__artist_tracks') }} using (track_id)
join {{ ref('stg_dbt_graham__track_language') }} using (track_id)
join {{ ref('stg_dbt_graham__lang') }} using (language_abbr)
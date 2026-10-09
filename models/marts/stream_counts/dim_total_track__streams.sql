with 

totals as (

    select
        track_id,
        SUM(total_streams_this_week) as total_streams
    from {{ ref('stg_dbt_graham__weeklychart') }}
    group by track_id

),

tracks as (

    select * from {{ ref('int_tracks') }}

),

final as (

    select
        track_name,
        artist_name,
        language_name,
        total_streams
    from totals
    join tracks using (track_id)


)

select * from final order by total_streams desc
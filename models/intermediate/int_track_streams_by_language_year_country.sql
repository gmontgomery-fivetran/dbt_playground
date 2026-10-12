with 

totals as (

    select
        track_id,
        year(chart_week) as chart_year,
        country_code,
        SUM(total_streams_this_week) as total_streams
    from {{ ref('stg_dbt_graham__weeklychart') }}
    group by track_id, chart_year, country_code

),

tracks as (

    select * from {{ ref('int_tracks') }}

),

countries as (

    select * from {{ ref('stg_dbt_graham__country') }}

),

final as (

    select
        track_name,
        artist_name,
        language_name,
        country_name,
        chart_year,
        total_streams
    from totals
    join tracks using (track_id)
    join countries using (country_code)

)

select * from final order by total_streams desc
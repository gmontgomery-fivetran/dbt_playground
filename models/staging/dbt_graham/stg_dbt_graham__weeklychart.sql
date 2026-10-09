with 

source as (

    select * from {{ source('dbt_graham', 'weeklychart') }}
    
),

renamed as (

    select
        week_chart_id as weeklychart_id,
        country_code,
        chart_week,
        rank,
        track_id,
        peak_rank,
        previous_rank,
        weeks_on_chart,
        streams as total_streams_this_week

    from source

)

select * from renamed

{% if is_incremental() %}
    where chart_week >= (select max(chart_week) from {{ this }}) 
{% endif %}
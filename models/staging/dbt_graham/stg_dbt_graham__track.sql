with 

source as (
    select * from {{ source('dbt_graham', 'track') }}
),

renamed as (

    select
        uri as track_id,
        track_name,
        source

    from source

)

select * from renamed
with 

source as (

    select * from {{ source('dbt_graham', 'track_language') }}

),

renamed as (

    select
        track_id,
        language_abbr,
        confidence

    from source

)

select * from renamed
with 

source as (

    select * from {{ source('dbt_graham', 'artist') }}

),

renamed as (

    select
        artist_name,
        default_lang

    from source

)

select * from renamed
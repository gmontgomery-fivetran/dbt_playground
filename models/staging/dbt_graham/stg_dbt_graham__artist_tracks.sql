with 

source as (

    select * from {{ source('dbt_graham', 'artist_tracks') }}

),

renamed as (

    select
        track_id,
        artist_id as artist_name

    from source

)

select * from renamed
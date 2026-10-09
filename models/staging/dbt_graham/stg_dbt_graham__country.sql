with 

source as (

    select * from {{ source('dbt_graham', 'country') }}

),

renamed as (

    select
        country_code,
        country_name

    from source

)

select * from renamed
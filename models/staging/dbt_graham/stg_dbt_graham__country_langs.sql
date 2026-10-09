with 

source as (

    select * from {{ source('dbt_graham', 'country_langs') }}

),

renamed as (

    select
        country_code,
        native_lang

    from source

)

select * from renamed
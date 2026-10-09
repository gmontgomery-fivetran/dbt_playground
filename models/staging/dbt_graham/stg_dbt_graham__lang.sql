with 

source as (

    select * from {{ source('dbt_graham', 'lang') }}

),

renamed as (

    select
        language_abbr,
        language_name

    from source

)

select * from renamed
with source as (

    select * from {{ source('raw_ecommerce', 'customers') }}

),

renamed as (

    select
        cast(id as integer)                 as customer_id,
        trim(first_name)                    as first_name,
        trim(last_name)                     as last_name,
        lower(nullif(trim(email), ''))      as email,
        cast(trim(signup_date) as date)     as signup_date
    from source

)

select * from renamed
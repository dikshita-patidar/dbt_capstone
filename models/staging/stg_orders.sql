with source as (

    select * from {{ source('raw_ecommerce', 'orders') }}

),

typed as (

    select
        cast(order_id as integer)                        as order_id,
        cast(nullif(trim(user_id), '') as integer)       as customer_id,
        cast(
            try_to_timestamp(
                regexp_replace(trim(order_timestamp), '(\\d+)(st|nd|rd|th) ', '\\1 '),
                'DD MMMM YYYY HH24:MI:SS'
            ) as date
        )                                                as order_date,
        trim(status)                                     as order_status,
        cast(amount as number(12, 2))                    as order_amount
    from source

),

deduplicated as (

    select * from typed
    qualify row_number() over (
        partition by order_id
        order by customer_id nulls last
    ) = 1

)

select * from deduplicated
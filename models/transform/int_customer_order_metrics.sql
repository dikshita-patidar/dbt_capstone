with orders as (

    select * from {{ ref('stg_orders') }}

),

metrics as (

    select
        customer_id,
        min(order_date)    as first_order_date,
        max(order_date)    as most_recent_order_date,
        count(order_id)    as total_orders,
        sum(order_amount)  as customer_lifetime_value
    from orders
    group by customer_id

)

select * from metrics
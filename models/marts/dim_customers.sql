with customers as (

    select * from {{ ref('stg_customers') }}

),

metrics as (

    select * from {{ ref('int_customer_order_metrics') }}

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.first_name || ' ' || customers.last_name as full_name,
        customers.email,
        customers.signup_date,
        metrics.first_order_date,
        metrics.most_recent_order_date,
        coalesce(metrics.total_orders, 0)            as total_orders,
        coalesce(metrics.customer_lifetime_value, 0) as customer_lifetime_value
    from customers
    left join metrics
        on customers.customer_id = metrics.customer_id

)

select * from final
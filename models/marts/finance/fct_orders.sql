with orders as  (
    select * from {{ ref ('stg_jaffle_shop__orders' )}}
),

payments as (
    select * from {{ ref ('stg_stripe__payments') }}
),

order_payments as (
    select
        p.order_id,
        sum(case when p.status = 'success' then p.amount end) as amount
    from payments p
    group by p.order_id
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount
    from orders
    left join order_payments ON orders.order_id = order_payments.order_id
)

select * from final

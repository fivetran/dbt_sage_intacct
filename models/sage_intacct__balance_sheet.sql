with general_ledger_by_period as (
    select *
    from {{ ref('sage_intacct__general_ledger_by_period') }}
    where account_type = 'balancesheet'
), 

retained_earnings as (
    select *
    from {{ ref('int_sage_intacct__retained_earnings') }}
),

combine_retained_earnings as (
    select 
        period_first_day, 
        account_no,
        account_title,
        account_type,
        book_id,
        category,
        classification,
        currency,
        entry_state,
        period_ending_amount as amount
    from general_ledger_by_period

    union all 

    select *
    from retained_earnings
),

final as (
    select 
        cast ({{ dbt.date_trunc("month", "period_first_day") }} as date) as period_date, 
        account_no,
        account_title,
        account_type,
        book_id,
        category,
        classification,
        currency,
        entry_state,
        round(cast(amount as {{ dbt.type_numeric() }}),2) as amount
    from combine_retained_earnings
)

select *
from final

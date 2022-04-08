with general_ledger_by_period as (
    select 
        period_first_day,
        account_no,
        account_title,
        account_type,
        book_id,
        category,
        classification,
        entry_state,
        period_ending_amount
    from {{ ref('sage_intacct__general_ledger_by_period') }}
    where account_type = 'balancesheet'
),
general_ledger_by_period_retained_earnings_tmp as (
    select
        period_first_day,
        'Adj. Net Income' as account_no,
        'Retained Earnings' as account_title,
        'balancesheet' as account_type,
        'ACCRUAL' as book_id,
        'Retained Earnings' as category,
        'Equity' as classification,
        'P' as entry_state,
        sum(period_net_amount) as period_net_amount
    from {{ ref('sage_intacct__general_ledger_by_period') }}
    where account_type = 'incomestatement'
    group by 1
    
),
general_ledger_by_period_retained_earnings as (
    select
        period_first_day,
        'Adj. Net Income' as account_no,
        'Retained Earnings' as account_title,
        'balancesheet' as account_type,
        'ACCRUAL' as book_id,
        'Retained Earnings' as category,
        'Equity' as classification,
        'P' as entry_state,
        sum(period_net_amount) over (
            order by period_first_day
        ) as amount
    from general_ledger_by_period_retained_earnings_tmp
    order by period_first_day
),


final as (
    select 
        cast ({{ dbt_utils.date_trunc("month", "period_first_day") }} as date) as period_date, 
        account_no,
        account_title,
        account_type,
        book_id,
        category,
        classification,
        currency,
        entry_state,
        round(cast(period_ending_amount as {{ dbt_utils.type_numeric() }}),2) as amount
    from general_ledger_by_period
    union all
    select *
    from general_ledger_by_period_retained_earnings
)


select *
from final


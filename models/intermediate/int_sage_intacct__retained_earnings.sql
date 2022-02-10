-- prep for income statement

with general_ledger_balances as (
    select *
    from {{ref('int_sage_intacct__general_ledger_balances')}}
),

revenue_starter as (
    select
        period_first_day,
        sum(period_net_amount) as revenue_net_amount
    from general_ledger_balances
    
    where classification = 'Revenue'

    group by 1
),

expense_starter as (
    select 
        period_first_day,
        sum(period_net_amount) as expense_net_amount
    from general_ledger_balances
    
    where classification = 'Expense'

    group by 1
),

net_income_loss as (
    select *
    from revenue_starter

    join expense_starter 
        using (period_first_day)
),

retained_earnings_starter as (
    select
        9999 as account_no,
        '9999-00' as account_title,
        'Net Income / Retained Earnings Adjustment' as category, -- change what we're calling it?
        'Equity' as classification,
        'balance_sheet' as financial_statement_helper,
        cast({{ dbt_utils.date_trunc("year", "period_first_day") }} as date) as date_year,
        cast(period_first_day as date) as period_first_day,
        {{ dbt_utils.last_day("period_first_day", "month") }} as period_last_day,
        (revenue_net_amount - expense_net_amount) as period_net_amount
    from net_income_loss
),


retained_earnings_beginning as (
    select
        *,
        sum(coalesce(period_net_amount,0)) over (order by period_first_day, period_first_day rows unbounded preceding) as period_ending_amount
    from retained_earnings_starter
)
,

final as (
    select
        account_no,
        account_title,
        category,
        classification,
        account_type,
        date_year,
        period_first_day,
        period_last_day,
        period_net_amount,
        lag(coalesce(period_ending_amount,0)) over (order by period_first_day) as period_beginning_balance,
        period_ending_amount
    from retained_earnings_beginning
)

select *
from final
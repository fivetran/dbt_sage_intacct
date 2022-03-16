with general_ledger_by_period as (

    select *
    from {{ ref('sage_intacct__general_ledger_by_period') }}
    where account_type = 'balancesheet'

), final as (

    select 

    cast ({{ dbt_utils.date_trunc("month", "period_first_day") }} as date) as period_date, 
    account_no,
    account_title,
    account_type,
    book_id,
    category,
    classification,
    entry_state,
    round(cast(period_ending_amount as {{ dbt_utils.type_numeric() }}),2) as amount

    from general_ledger_by_period
)

select *
from final


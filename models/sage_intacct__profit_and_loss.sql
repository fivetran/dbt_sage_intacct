with general_ledger_by_period as (
    select *
    from {{ref('sage_intacct__general_ledger_by_period')}}
    where account_type = 'incomestatement'

), 

final as (
    select
        date_trunc(period_first_day,month) as date,
        account_no,
        account_title,
        account_type,
        book_id,
        category,
        classification,
        entry_state,
        round(period_net_amount,2) as amount 
    from general_ledger_by_period
)

select *
from final
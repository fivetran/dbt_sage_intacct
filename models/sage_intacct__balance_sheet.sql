with general_ledger_by_period as (
    select *
    from {{ ref('sage_intacct__general_ledger_by_period') }}
    where financial_statement_helper = 'balance_sheet'
),

final as (
    select 
        period_first_day as date,
        account_no,
        account_title,
        category,
        classification,
        period_ending_amount as amounts
    from general_ledger_by_period
)

select 
*
from final

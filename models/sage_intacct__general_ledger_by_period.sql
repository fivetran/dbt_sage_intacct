with general_ledger_balances as (
    select *
    from {{ref('int_sage_intacct__general_ledger_balances')}}
)

    select 
        account_no,
        account_title,
        category,
        classification,
        account_type,
        date_year, 
        period_first_day,
        period_last_day,
        round(period_net_amount,2) as period_net_amount,
        round(period_beg_amount,2) as period_beg_amount,
        round(period_ending_amount,2) as period_ending_amount


from general_ledger_balances
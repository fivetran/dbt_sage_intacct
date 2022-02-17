with general_ledger as (
    select *
    from {{ref('sage_intacct__general_ledger')}}
),

    select
    
	transaction,
	entry_date,
    when_created ,
    when_due,
    when_modified,
    when_paid,
	customer,
	customer id,
	vendor ,
	vendor id,
	location,
	location id


    from general_ledger
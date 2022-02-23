with gl_detail as (
    select * 
    from {{ ref('stg_sage_intacct__gl_detail') }} 
),

gl_account as (
    select * 
    from {{ ref('int_sage_intacct__account_classifications') }} 
),

enhanced as (

    select

	gld.transaction,
	gld.entry_date,
    gld.when_created,
    gld.when_due,
    gld.when_modified,
    gld.when_paid,
	gld.customer,
	gld.customer_id,
	gld.vendor,
	gld.vendor_id,
	gld.location,
	gld.location_id,
    gld.when_paid,
    gla.category,
    gla.classification,
    gla.account_type 

    from gl_detail gld
    left join gl_account gla
    on gld.account_no = gla.account_no 
)

select 
*
from enhanced
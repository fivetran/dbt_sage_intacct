with gl_detail as (
    select * 
    from {{ ref('int_sage_intacct__active_gl_detail') }} 
),

gl_account as (
    select * 
    from {{ ref('int_sage_intacct__account_classifications') }} 
),

general_ledger as (

    select 

    gld.gl_detail_id,
    gld.account_no,
    gld.account_title,
    round(cast(gld.amount as {{ dbt.type_numeric() }}),2) as amount,
    gld.book_id,
    gld.credit_amount,
    gld.debit_amount,
    gld.currency,
    gld.description,
    gld.doc_number,
    gld.customer_id,
    gld.customer_name,
    gld.entry_date_at,
    gld.entry_state,
    gld.entry_description,
    gld.line_no,
    gld.record_id,
    gld.record_type,
    gld.total_due,
    gld.total_entered,
    gld.total_paid,
    gld.tr_type,
    gld.trx_amount,
    gld.trx_credit_amount,
    gld.trx_debit_amount,
    gld.vendor_id,
    gld.vendor_name,
    gld.created_at,
    gld.due_at,
    gld.modified_at,
    gld.paid_at,
    gla.category,
    gla.classification,
    gla.account_type 

    --The below script allows for pass through columns.
    {% if var('sage_account_pass_through_columns') %} 
    ,
    gla.{{ var('sage_account_pass_through_columns') | join (", ")}}

    {% endif %}

    {% if var('sage_gl_pass_through_columns') %}
    ,     
    gld.{{ var('sage_gl_pass_through_columns') | join (", ")}} 

    {% endif %}

    from gl_detail gld
    left join gl_account gla
        on gld.account_no = gla.account_no 
)

select * 
from general_ledger


with base as (

    select * 
    from {{ ref('stg_sage_intacct__gl_detail_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_sage_intacct__gl_detail_tmp')),
                staging_columns=get_gl_detail_columns()
            )
        }}
        --The below script allows for pass through columns.
        {% if var('sage_gl_pass_through_columns') %} 
        ,
        {{ var('sage_gl_pass_through_columns') | join (", ")}}

        {% endif %}
        
    from base
),

final as (
    
    select 
        recordno as gl_detail_id,
        cast(accountno as {{ dbt.type_string() }}) as account_no,
        accounttitle as account_title,
        amount,
        batch_date,
        batch_no,
        batch_title,
        batchkey as batch_key,
        bookid as book_id,
        classid as class_id,
        classname as class_name,
        creditamount as credit_amount,
        debitamount as debit_amount,
        currency,
        customerid as customer_id,
        customername as customer_name,
        departmentid as department_id,
        departmenttitle as department_title,
        description,
        docnumber as doc_number,
        entry_date as entry_date_at,
        entry_state,
        entrydescription as entry_description,
        line_no,
        locationid as location_id,
        locationname as location_name,
        prdescription as pr_description,
        recordid as record_id,
        recordtype as record_type,
        totaldue as total_due,
        totalentered as total_entered,
        totalpaid as total_paid,
        tr_type,
        trx_amount,
        trx_creditamount as trx_credit_amount,
        trx_debitamount as trx_debit_amount,
        vendorid as vendor_id,
        vendorname as vendor_name,
        whencreated as created_at,
        whendue as due_at,
        whenmodified as modified_at,
        whenpaid as paid_at,
        _fivetran_deleted as is_detail_deleted


        --The below script allows for pass through columns.
        {% if var('sage_gl_pass_through_columns') %} 
        ,
        {{ var('sage_gl_pass_through_columns') | join (", ")}}

        {% endif %}

    from fields
)

select * 
from final
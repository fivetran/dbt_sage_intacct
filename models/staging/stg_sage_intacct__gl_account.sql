
with base as (

    select * 
    from {{ ref('stg_sage_intacct__gl_account_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_sage_intacct__gl_account_tmp')),
                staging_columns=get_gl_account_columns()
            )
        }}
        --The below script allows for pass through columns.
        {% if var('sage_account_pass_through_columns') %} 
        ,
        {{ var('sage_account_pass_through_columns') | join (", ")}}

        {% endif %}

    from base
),

final as (
    
    select 
        cast(accountno as {{ dbt.type_string() }}) as account_no,
        _fivetran_deleted,	
        _fivetran_synced,	
        accounttype as account_type,	
        alternativeaccount as alternative_account,	
        category,	
        categorykey as category_key,	
        closetoacctkey as close_to_acct_key,	
        closingaccountno as closing_account_no,	
        closingaccounttitle as closing_account_title,	
        closingtype as closing_type,	
        createdby as created_by,	
        modifiedby as modified_by,	
        normalbalance as normal_balance,	
        recordno as gl_account_id,	
        status,	
        taxable,	
        title,	
        whencreated as created_at,	
        whenmodified as modified_at	

        --The below script allows for pass through columns.
        {% if var('sage_account_pass_through_columns') %} 
        ,
        {{ var('sage_account_pass_through_columns') | join (", ")}}

        {% endif %}

    from fields
)

select * 
from final
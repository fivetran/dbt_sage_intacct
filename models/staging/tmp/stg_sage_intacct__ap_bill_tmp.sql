{{ config(enabled=var('sage_intacct__using_bills', True)) }}

{{
    fivetran_utils.union_connections(
        connection_dictionary='sage_intacct_sources',
        single_source_name='sage_intacct',
        single_table_name='ap_bill'
    )
}}

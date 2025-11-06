{{ config(enabled=var('sage_intacct__using_invoices', True)) }}

{{
    sage_intacct.sage_intacct_union_connections(
        connection_dictionary='sage_intacct_sources',
        single_source_name='sage_intacct',
        single_table_name='ar_invoice_item'
    )
}}

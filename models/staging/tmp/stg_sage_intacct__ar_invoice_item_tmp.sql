{{ config(enabled=var('sage_intacct__using_invoices', True)) }}

select * from {{ var('ar_invoice_item') }}

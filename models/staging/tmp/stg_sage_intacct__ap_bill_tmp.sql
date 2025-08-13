{{ config(enabled=var('sage_intacct__using_bills', True)) }}

select * from {{ var('ap_bill') }}

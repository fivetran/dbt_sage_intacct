# dbt_sage_intacct v0.2.0
## 🚨 Breaking Changes 🚨
- Allow for more pass-through columns and add enabled/disabled configs for the AP Bill and AR Invoice tables which may not be present in the customer schema. Finally, introduce a new account field called Retained Earnings to ensure Balance Sheets round out.

([#6](https://github.com/fivetran/dbt_sage_intacct/issues/6))
([#7](https://github.com/fivetran/dbt_sage_intacct/issues/7))
([#8](https://github.com/fivetran/dbt_sage_intacct/issues/8))
## Contributors
Thank you @santi95 for raising these to our attention! ([#9](https://github.com/fivetran/dbt_sage_intacct/pull/9))


# dbt_sage_intacct v0.1.0

## 🎉 Initial Release of the Fivetran Sage Intacct Ads dbt package 🎉
- This is the initial release of this package. For more information refer to the [README](/README.md).

### Under the Hood

The main focus of this package is to provide users with insights into their Sage Intacct data that can be used for financial reporting and analysis. This is achieved by the following:
- Creating the general ledger, balance sheet, and profile & loss statement on a month by month grain
- Creating an enhanced AR and AP model 

Currently the package supports Postgres, Redshift, BigQuery, Databricks and Snowflake. Additionally, this package is designed to work with dbt versions [">=1.0.0", "<2.0.0"].


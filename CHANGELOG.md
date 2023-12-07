# dbt_sage_intacct v0.3.0

[PR #19](https://github.com/fivetran/dbt_sage_intacct/pull/19) includes the following updates.

## 🚨 Breaking Changes 🚨 (within the upstream dbt_sage_intacct_source package):
- Removal of the `_fivetran_deleted` field from the upstream `stg_sage_intacct__gl_detail` table due to this field being deprecated within the connector. The relevant information is now available within the `gl_batch` source table. For more details please refer to the relevant [dbt_sage_intacct_source v0.3.0 release](https://github.com/fivetran/dbt_sage_intacct_source/releases/tag/v0.3.0).

## Bug Fixes
- Added a new `int_sage_intacct__active_gl_detail` model. This model properly filters out any soft deleted GL Detail records by joining on the GL Batch staging model which contains the reference to if the transaction was deleted or not. Please note that this may result in fewer transactions in your downstream models due the removal of deleted transactions.
- While this package still does not fully support multi-currency, a bugfix was applied in the `int_sage_intacct__general_ledger_balances` model to properly join on the `currency` field so duplicates would not be introduced in the end models.
- In addition to the above, the following combination of column uniqueness tests were updated to take `currency` into consideration:
    - `sage_intacct__general_ledger_by_period`
    - `sage_intacct__profit_and_loss`
    - `sage_intacct__balance_sheet`

## Under the Hood
- Updated Maintainer PR Template
- Included auto-releaser GitHub Actions workflow to automate future releases

# dbt_sage_intacct v0.2.2

## Add Null to Coalesce clause:
- The variables `sage_intacct__using_bills` and `sage_intacct__using_invoices` are used in coalesce statements in the `sage_intacct__ap_ar_enhanced` model. In the case where 1 is true and the other is false, the model fails for some warehouses. This is because in some warehouses like Snowflake, the coalesce clause is unable to only take 1 argument. Therefore, as a fix, this PR explicitly adds a null as a third argument. That way, for this scenario, there will still be 2 arguments. ([PR #17](https://github.com/fivetran/dbt_sage_intacct/pull/17))

 ## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github). ([PR #15](https://github.com/fivetran/dbt_sage_intacct/pull/15))

# dbt_sage_intacct v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #13](https://github.com/fivetran/dbt_sage_intacct/pull/13) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.
# dbt_sage_intacct v0.1.2
## Fix balance sheet not tying out
- The amounts in the balance sheet model were not tying out. We have added an additional `Adj. Net Income` account to include for a net income adjustment as part of the Retained Earnings category.  ([#8](https://github.com/fivetran/dbt_sage_intacct/issues/8))
## Contributors
[@santi95](https://github.com/santi95) ([#9](https://github.com/fivetran/dbt_sage_intacct/pull/9))

# dbt_sage_intacct v0.1.1
## Updates
- Allow for pass-through columns from the  `gl_detail` and `gl_account` source tables. In the gl_detail staging model, added additional fields and enabled/disabled configs for the AP Bill and AR Invoice tables which may not be present in the customer schema.

([#6](https://github.com/fivetran/dbt_sage_intacct/issues/6))
([#7](https://github.com/fivetran/dbt_sage_intacct/issues/7))
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


[PR #35](https://github.com/fivetran/dbt_sage_intacct/pull/35) includes the following updates:

### Under the Hood - July 2025 Updates

- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.
- Added `+docs: show: False` to `integration_tests/dbt_project.yml`.
- Migrated `flags` (e.g., `send_anonymous_usage_stats`, `use_colors`) from `sample.profiles.yml` to `integration_tests/dbt_project.yml`.
- Updated `maintainer_pull_request_template.md` with improved checklist.
- Refreshed README tag block:
  - Standardized Quickstart-compatible badge set
  - Left-aligned and positioned below the H1 title.
- Updated Python image version to `3.10.13` in `pipeline.yml`.
- Added `CI_DATABRICKS_DBT_CATALOG` to:
  - `.buildkite/hooks/pre-command` (as an export)
  - `pipeline.yml` (under the `environment` block, after `CI_DATABRICKS_DBT_TOKEN`)
- Added `certifi==2025.1.31` to `requirements.txt` (if missing).
- Updated `.gitignore` to exclude additional DBT, Python, and system artifacts.

# dbt_sage_intacct v0.7.0
[PR #30](https://github.com/fivetran/dbt_sage_intacct/pull/30) includes the following updates:

## Breaking Change for dbt Core < 1.9.6

> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Sage Intacct Source v0.5.0](https://github.com/fivetran/dbt_sage_intacct_source/releases/tag/v0.5.0)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `sage_intacct` in file
`models/src_sage_intacct.yml`. The `freshness` top-level property should be moved
into the `config` of `sage_intacct`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Sage Intacct freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `sage_intacct` package. Pin your dependency on v0.6.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `sage_intacct` source and apply freshness via the previous release top-level property route. This will require you to copy and paste the entirety of the previous release `src_sage_intacct.yml` file and add an `overrides: sage_intacct_source` property.

## Under the Hood
- Updates to ensure integration tests use latest version of dbt.

# dbt_sage_intacct v0.6.0
[PR #29](https://github.com/fivetran/dbt_sage_intacct/pull/29) includes the following updates:
 
## Breaking Changes (originating within the upstream `dbt_sage_intacct_source` package):
- Reintroduced `_fivetran_deleted` from the `gl_detail` source table, as the field was not fully deprecated within in the connector. **It is null in normal incremental syncs, but can populate true or false in historical resyncs.** For more details please refer to the relevant [dbt_sage_intacct_source v0.4.0 release](https://github.com/fivetran/dbt_sage_intacct_source/releases/tag/v0.4.0).
- Updated `int_sage_intacct__active_gl_detail` model to exclude `gl_detail` records where `_fivetran_deleted` (aliased to `is_detail_deleted`) is true. This may filter out data that was previously included in the general ledger and downstream models.
- Renamed `_fivetran_deleted` from the `gl_batch` source to `is_batch_deleted` to ensure no duplicate columns.  This field is present in `int_sage_intacct__active_gl_detail` and `stg_sage_intacct__gl_batch`.

## Documentation
- Added Quickstart model counts to README. ([#28](https://github.com/fivetran/dbt_sage_intacct/pull/28))
- Corrected references to connectors and connections in the README. ([#28](https://github.com/fivetran/dbt_sage_intacct/pull/28))

## Under the Hood
- Added `fivetran_consistency_gl_period_exclusion_documents` filter for account numbers with irregular behavior to pass the `consistency_general_ledger_by_period` test.

# dbt_sage_intacct v0.5.0
[PR #24](https://github.com/fivetran/dbt_sage_intacct/pull/24) includes the following updates.

## 🚨 Breaking Changes: Bug Fixes 🚨
- Updated the structure of the `int_sage_intacct__general_ledger_date_spine` model for improved performance and maintainability.
    - Modified the date spine logic so that the model will take the maximum `entry_date_at` from the `sage_intacct__general_ledger` for the last date of the spine if it is available, rather than the current date. This will help capture future-dated transactions as well beyond the current date. 
    - This is a breaking change, as changing the behavior of the date spine which will adjust the transaction records in the  `sage_intacct__general_ledger_by_period` model to be more accurate.

# Bug Fixes
- Updated the `int_sage_intacct__general_ledger_date_spine` model to accommodate for the cases when the compiled `sage_intacct__general_ledger` model has no transactions. In this case, the model now defaults to a range of one month leading up to the current date.

## Under The Hood
- Added `flags.WHICH in ('run', 'build')` as a condition in `int_sage_intacct__general_ledger_date_spine` to prevent call statements from querying the staging models during a `dbt compile`.
- Addition of integrity and consistency validation tests within integration tests for the `sage_intacct__general_ledger` and `sage_intacct__general_ledger_by_period` model.

# dbt_sage_intacct v0.4.0
[PR #22](https://github.com/fivetran/dbt_sage_intacct/pull/22) includes the following updates.

## 🚨 Breaking Changes: Bug Fixes 🚨
- The `account_no` and `offset_gl_account_no` fields in the `sage_intacct__ap_ar_enhanced` end model are now consistently casted as strings using `{{ dbt.type_string() }}`. This ensures compatibility within the union all operation, preventing datatype conflicts between the fields within the upstream `invoice_item` and `bill_item` tables.

## Under the Hood
- Addition of integrity and consistency validation tests within integration tests for the `sage_intacct__ap_ar_enhanced` model.
- Updates to the `accountno` and `amount` seed datatypes within the integration tests to more closely resemble the datatype of those fields in the Sage Intacct connector.

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


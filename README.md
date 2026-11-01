# Snowflake Data Engineering Labs

Hands-on lab work for Snowflake data engineering.

## Contents

| Folder | Description |
|---|---|
| [`modern-data-engineering-snowflake`](modern-data-engineering-snowflake/) | Labs for the *Introduction to Modern Data Engineering with Snowflake* course (Tasty Bytes case study): batch ingestion, transformations, Streamlit and Native Apps, and pipeline orchestration. |

## Source and attribution

`modern-data-engineering-snowflake` is copied from
[Snowflake-Labs/modern-data-engineering-snowflake](https://github.com/Snowflake-Labs/modern-data-engineering-snowflake)
at commit `824bc65` (October 14, 2026). All original content belongs to Snowflake Inc.

Local additions:

- `module-2/frostbyte_weathersource.sql`: mounts the free **Pelmorex Weather Source: Frostbyte**
  Marketplace listing (formerly *Weather Source LLC: frostbyte*, listing `GZSOZ1LLEL`) as
  `FROSTBYTE_WEATHERSOURCE`, the database name the module 2 and 3 labs expect, then runs the
  original module 2 verification query.

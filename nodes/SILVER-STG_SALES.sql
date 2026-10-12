@id("ae32a143-f371-42af-9a30-a507382a76f8")
@nodeType("SQL:::SQLWork")
@description("Unified sales lines for FR, DE and ES - single source of truth for sales")
@tests("SELECT 1 FROM {{ this }} WHERE QUANTITY > 0 AND NET_AMOUNT_EXCL_VAT_EUR < 0", true, "After")
WITH "ALL_SALES" AS (
    SELECT * FROM {{ ref('SILVER', 'STG_SALES_FR') }}
    UNION ALL
    SELECT * FROM {{ ref('SILVER', 'STG_SALES_DE') }}
    UNION ALL
    SELECT * FROM {{ ref('SILVER', 'STG_SALES_ES') }}
)
SELECT
    CAST("S"."SALE_LINE_KEY" AS VARCHAR)              AS "SALE_LINE_KEY"           @not_null @uniqueness,
    CAST("S"."COUNTRY_CODE" AS VARCHAR(2))            AS "COUNTRY_CODE"            @accepted_values("'FR', 'DE', 'ES'"),
    CAST("S"."TICKET_KEY" AS VARCHAR)                 AS "TICKET_KEY",
    CAST("S"."LINE_NO" AS NUMBER(5,0))                AS "LINE_NO",
    CAST("S"."SALE_DATE" AS DATE)                     AS "SALE_DATE"               @not_null,
    CAST("S"."SALE_TIME" AS TIME)                     AS "SALE_TIME",
    CAST("S"."STORE_CODE" AS VARCHAR)                 AS "STORE_CODE"              @not_null,
    CAST("S"."SKU" AS VARCHAR)                        AS "SKU"                     @not_null,
    CAST("S"."STAFF_ID" AS VARCHAR)                   AS "STAFF_ID",
    CAST("S"."QUANTITY" AS NUMBER(10,0))              AS "QUANTITY",
    CAST("S"."DISCOUNT_RATE" AS NUMBER(5,4))          AS "DISCOUNT_RATE"           @min_max("0", "1"),
    CAST("S"."VAT_RATE" AS NUMBER(5,4))               AS "VAT_RATE",
    CAST("S"."AMOUNT_INCL_VAT_EUR" AS NUMBER(12,2))   AS "AMOUNT_INCL_VAT_EUR",
    CAST("S"."NET_AMOUNT_EXCL_VAT_EUR" AS NUMBER(12,2)) AS "NET_AMOUNT_EXCL_VAT_EUR",
    CAST("S"."IS_RETURN" AS BOOLEAN)                  AS "IS_RETURN",
    CAST("S"."SOURCE_FILE_NAME" AS VARCHAR)           AS "SOURCE_FILE_NAME",
    CAST("S"."LOADED_TS" AS TIMESTAMP_LTZ)            AS "LOADED_TS"
FROM "ALL_SALES" "S"
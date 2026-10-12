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
    CAST("S"."SALE_LINE_KEY" AS VARCHAR)              AS "SALE_LINE_KEY"           @not_null @uniqueness @description("Unique sale line key: country-prefixed ticket number and line position"),
    CAST("S"."COUNTRY_CODE" AS VARCHAR(2))            AS "COUNTRY_CODE"            @accepted_values("'FR', 'DE', 'ES'") @description("Country of the selling store"),
    CAST("S"."TICKET_KEY" AS VARCHAR)                 AS "TICKET_KEY" @description("Country-prefixed receipt/ticket identifier"),
    CAST("S"."LINE_NO" AS NUMBER(5,0))                AS "LINE_NO" @description("Line position within the ticket"),
    CAST("S"."SALE_DATE" AS DATE)                     AS "SALE_DATE"               @not_null @description("Date of sale"),
    CAST("S"."SALE_TIME" AS TIME)                     AS "SALE_TIME" @description("Time of sale"),
    CAST("S"."STORE_CODE" AS VARCHAR)                 AS "STORE_CODE"              @not_null @description("Store where the sale occurred"),
    CAST("S"."SKU" AS VARCHAR)                        AS "SKU"                     @not_null @description("Product SKU sold"),
    CAST("S"."STAFF_ID" AS VARCHAR)                   AS "STAFF_ID" @description("Staff member who made the sale"),
    CAST("S"."QUANTITY" AS NUMBER(10,0))              AS "QUANTITY" @description("Units sold; negative for returns"),
    CAST("S"."DISCOUNT_RATE" AS NUMBER(5,4))          AS "DISCOUNT_RATE"           @min_max("0", "1") @description("Discount applied as a fraction (0-1)"),
    CAST("S"."VAT_RATE" AS NUMBER(5,4))               AS "VAT_RATE" @description("VAT rate applied to the line"),
    CAST("S"."AMOUNT_INCL_VAT_EUR" AS NUMBER(12,2))   AS "AMOUNT_INCL_VAT_EUR" @description("Line amount including VAT, in EUR"),
    CAST("S"."NET_AMOUNT_EXCL_VAT_EUR" AS NUMBER(12,2)) AS "NET_AMOUNT_EXCL_VAT_EUR" @description("Line net amount excluding VAT, in EUR"),
    CAST("S"."IS_RETURN" AS BOOLEAN)                  AS "IS_RETURN" @description("True when the line is a return (negative quantity)"),
    CAST("S"."SOURCE_FILE_NAME" AS VARCHAR)           AS "SOURCE_FILE_NAME" @description("Source file the row was loaded from"),
    CAST("S"."LOADED_TS" AS TIMESTAMP_LTZ)            AS "LOADED_TS" @description("Timestamp the row was loaded into RAW")
FROM "ALL_SALES" "S"
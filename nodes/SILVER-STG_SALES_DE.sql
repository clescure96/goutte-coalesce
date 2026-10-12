@id("a5fc499e-f2d2-4412-8670-2bc5818a14a2")
@nodeType("SQL:::SQLWork")
@description("German POS sales lines, harmonised. POS re-sends duplicate batches: deduplicated on ticket + line. Amounts already excl. VAT (DE VAT 19%)")
WITH "DEDUP" AS (
    SELECT *
    FROM {{ ref('RAW', 'RAW_SALES_DE') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY "BELEG_NR", "POSITION" ORDER BY "_LOADED_AT") = 1
)
SELECT
    'DE-' || "D"."BELEG_NR" || '-' || "D"."POSITION"                            AS "SALE_LINE_KEY" @description("Unique sale line key: country-prefixed ticket number and line position"),
    CAST('DE' AS VARCHAR(2))                                                    AS "COUNTRY_CODE" @description("Country of the selling store (Germany)"),
    'DE-' || "D"."BELEG_NR"                                                     AS "TICKET_KEY" @description("Country-prefixed receipt/ticket identifier"),
    CAST("D"."POSITION" AS NUMBER(5,0))                                         AS "LINE_NO" @description("Line position within the ticket"),
    TO_DATE("D"."VERKAUFSDATUM", 'YYYY-MM-DD')                                  AS "SALE_DATE" @description("Date of sale"),
    TO_TIME("D"."UHRZEIT")                                                      AS "SALE_TIME" @description("Time of sale"),
    "D"."FILIALE"                                                               AS "STORE_CODE" @description("Store where the sale occurred"),
    "D"."ARTIKEL_NR"                                                            AS "SKU" @description("Product SKU sold"),
    "D"."MITARBEITER_ID"                                                        AS "STAFF_ID" @description("Staff member who made the sale"),
    CAST("D"."MENGE" AS NUMBER(10,0))                                           AS "QUANTITY" @description("Units sold; negative for returns"),
    CAST(TO_NUMBER("D"."RABATT_PROZENT", 5, 1) / 100 AS NUMBER(5,4))            AS "DISCOUNT_RATE" @description("Discount applied as a fraction (0-1)"),
    CAST(0.19 AS NUMBER(5,4))                                                   AS "VAT_RATE" @description("VAT rate applied (German 19%)"),
    CAST(ROUND(TO_NUMBER("D"."BETRAG_NETTO", 12, 2) * 1.19, 2) AS NUMBER(12,2)) AS "AMOUNT_INCL_VAT_EUR" @description("Line amount including VAT, in EUR"),
    CAST(TO_NUMBER("D"."BETRAG_NETTO", 12, 2) AS NUMBER(12,2))                  AS "NET_AMOUNT_EXCL_VAT_EUR" @description("Line net amount excluding VAT, in EUR"),
    CAST(TO_NUMBER("D"."MENGE") < 0 AS BOOLEAN)                                 AS "IS_RETURN" @description("True when the line is a return (negative quantity)"),
    "D"."_FILE_NAME"                                                            AS "SOURCE_FILE_NAME" @description("Source file the row was loaded from"),
    "D"."_LOADED_AT"                                                            AS "LOADED_TS" @description("Timestamp the row was loaded into RAW")
FROM "DEDUP" "D"
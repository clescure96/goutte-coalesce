@id("a5fc499e-f2d2-4412-8670-2bc5818a14a2")
@nodeType("SQL:::SQLWork")
@description("German POS sales lines, harmonised. POS re-sends duplicate batches: deduplicated on ticket + line. Amounts already excl. VAT (DE VAT 19%)")
WITH "DEDUP" AS (
    SELECT *
    FROM {{ ref('RAW', 'RAW_SALES_DE') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY "BELEG_NR", "POSITION" ORDER BY "_LOADED_AT") = 1
)
SELECT
    'DE-' || "D"."BELEG_NR" || '-' || "D"."POSITION"                            AS "SALE_LINE_KEY",
    CAST('DE' AS VARCHAR(2))                                                    AS "COUNTRY_CODE",
    'DE-' || "D"."BELEG_NR"                                                     AS "TICKET_KEY",
    CAST("D"."POSITION" AS NUMBER(5,0))                                         AS "LINE_NO",
    TO_DATE("D"."VERKAUFSDATUM", 'YYYY-MM-DD')                                  AS "SALE_DATE",
    TO_TIME("D"."UHRZEIT")                                                      AS "SALE_TIME",
    "D"."FILIALE"                                                               AS "STORE_CODE",
    "D"."ARTIKEL_NR"                                                            AS "SKU",
    "D"."MITARBEITER_ID"                                                        AS "STAFF_ID",
    CAST("D"."MENGE" AS NUMBER(10,0))                                           AS "QUANTITY",
    CAST(TO_NUMBER("D"."RABATT_PROZENT", 5, 1) / 100 AS NUMBER(5,4))            AS "DISCOUNT_RATE",
    CAST(0.19 AS NUMBER(5,4))                                                   AS "VAT_RATE",
    CAST(ROUND(TO_NUMBER("D"."BETRAG_NETTO", 12, 2) * 1.19, 2) AS NUMBER(12,2)) AS "AMOUNT_INCL_VAT_EUR",
    CAST(TO_NUMBER("D"."BETRAG_NETTO", 12, 2) AS NUMBER(12,2))                  AS "NET_AMOUNT_EXCL_VAT_EUR",
    CAST(TO_NUMBER("D"."MENGE") < 0 AS BOOLEAN)                                 AS "IS_RETURN",
    "D"."_FILE_NAME"                                                            AS "SOURCE_FILE_NAME",
    "D"."_LOADED_AT"                                                            AS "LOADED_TS"
FROM "DEDUP" "D"
@id("f647c2ce-2f0b-4c84-9f11-31298f52711e")
@nodeType("SQL:::SQLWork")
@description("Spanish POS sales lines, harmonised: typed, net amounts excl. VAT (ES VAT 21%)")
SELECT
    'ES-' || "E"."TICKET_ID" || '-' || "E"."LINE_NO"                            AS "SALE_LINE_KEY",
    CAST('ES' AS VARCHAR(2))                                                    AS "COUNTRY_CODE",
    'ES-' || "E"."TICKET_ID"                                                    AS "TICKET_KEY",
    CAST("E"."LINE_NO" AS NUMBER(5,0))                                          AS "LINE_NO",
    TO_DATE("E"."SALE_DATE", 'DD-MM-YYYY')                                      AS "SALE_DATE",
    TO_TIME("E"."SALE_TIME")                                                    AS "SALE_TIME",
    "E"."STORE_CODE"                                                            AS "STORE_CODE",
    "E"."SKU"                                                                   AS "SKU",
    "E"."STAFF_ID"                                                              AS "STAFF_ID",
    CAST("E"."QTY" AS NUMBER(10,0))                                             AS "QUANTITY",
    CAST(TO_NUMBER("E"."DISCOUNT_RATE", 5, 2) AS NUMBER(5,4))                   AS "DISCOUNT_RATE",
    CAST(0.21 AS NUMBER(5,4))                                                   AS "VAT_RATE",
    CAST(TO_NUMBER("E"."LINE_AMOUNT_GROSS", 12, 2) AS NUMBER(12,2))             AS "AMOUNT_INCL_VAT_EUR",
    CAST(ROUND(TO_NUMBER("E"."LINE_AMOUNT_GROSS", 12, 2) / 1.21, 2) AS NUMBER(12,2)) AS "NET_AMOUNT_EXCL_VAT_EUR",
    CAST(TO_NUMBER("E"."QTY") < 0 AS BOOLEAN)                                   AS "IS_RETURN",
    "E"."_FILE_NAME"                                                            AS "SOURCE_FILE_NAME",
    "E"."_LOADED_AT"                                                            AS "LOADED_TS"
FROM {{ ref('RAW', 'RAW_SALES_ES') }} "E"
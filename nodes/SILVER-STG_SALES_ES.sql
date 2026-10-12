@id("f647c2ce-2f0b-4c84-9f11-31298f52711e")
@nodeType("SQL:::SQLWork")
@description("Spanish POS sales lines, harmonised: typed, net amounts excl. VAT (ES VAT 21%)")
SELECT
    'ES-' || "E"."TICKET_ID" || '-' || "E"."LINE_NO"                            AS "SALE_LINE_KEY" @description("Unique sale line key: country-prefixed ticket number and line position"),
    CAST('ES' AS VARCHAR(2))                                                    AS "COUNTRY_CODE" @description("Country of the selling store (Spain)"),
    'ES-' || "E"."TICKET_ID"                                                    AS "TICKET_KEY" @description("Country-prefixed receipt/ticket identifier"),
    CAST("E"."LINE_NO" AS NUMBER(5,0))                                          AS "LINE_NO" @description("Line position within the ticket"),
    TO_DATE("E"."SALE_DATE", 'DD-MM-YYYY')                                      AS "SALE_DATE" @description("Date of sale"),
    TO_TIME("E"."SALE_TIME")                                                    AS "SALE_TIME" @description("Time of sale"),
    "E"."STORE_CODE"                                                            AS "STORE_CODE" @description("Store where the sale occurred"),
    "E"."SKU"                                                                   AS "SKU" @description("Product SKU sold"),
    "E"."STAFF_ID"                                                              AS "STAFF_ID" @description("Staff member who made the sale"),
    CAST("E"."QTY" AS NUMBER(10,0))                                             AS "QUANTITY" @description("Units sold; negative for returns"),
    CAST(TO_NUMBER("E"."DISCOUNT_RATE", 5, 2) AS NUMBER(5,4))                   AS "DISCOUNT_RATE" @description("Discount applied as a fraction (0-1)"),
    CAST(0.21 AS NUMBER(5,4))                                                   AS "VAT_RATE" @description("VAT rate applied (Spanish 21%)"),
    CAST(TO_NUMBER("E"."LINE_AMOUNT_GROSS", 12, 2) AS NUMBER(12,2))             AS "AMOUNT_INCL_VAT_EUR" @description("Line amount including VAT, in EUR"),
    CAST(ROUND(TO_NUMBER("E"."LINE_AMOUNT_GROSS", 12, 2) / 1.21, 2) AS NUMBER(12,2)) AS "NET_AMOUNT_EXCL_VAT_EUR" @description("Line net amount excluding VAT, in EUR (gross / 1.21)"),
    CAST(TO_NUMBER("E"."QTY") < 0 AS BOOLEAN)                                   AS "IS_RETURN" @description("True when the line is a return (negative quantity)"),
    "E"."_FILE_NAME"                                                            AS "SOURCE_FILE_NAME" @description("Source file the row was loaded from"),
    "E"."_LOADED_AT"                                                            AS "LOADED_TS" @description("Timestamp the row was loaded into RAW")
FROM {{ ref('RAW', 'RAW_SALES_ES') }} "E"
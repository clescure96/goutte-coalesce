@id("6bab5988-b044-4899-a96a-a254db4dd1df")
@nodeType("SQL:::SQLWork")
@description("French POS sales lines, harmonised: English names, typed, net amounts excl. VAT (FR VAT 20%)")
SELECT
    'FR-' || "F"."ID_TICKET" || '-' || "F"."NUM_LIGNE"                          AS "SALE_LINE_KEY" @description("Unique sale line key: country-prefixed ticket number and line position"),
    CAST('FR' AS VARCHAR(2))                                                    AS "COUNTRY_CODE" @description("Country of the selling store (France)"),
    'FR-' || "F"."ID_TICKET"                                                    AS "TICKET_KEY" @description("Country-prefixed receipt/ticket identifier"),
    CAST("F"."NUM_LIGNE" AS NUMBER(5,0))                                        AS "LINE_NO" @description("Line position within the ticket"),
    TO_DATE("F"."DATE_VENTE", 'DD/MM/YYYY')                                     AS "SALE_DATE" @description("Date of sale"),
    TO_TIME("F"."HEURE_VENTE")                                                  AS "SALE_TIME" @description("Time of sale"),
    "F"."CODE_MAGASIN"                                                          AS "STORE_CODE" @description("Store where the sale occurred"),
    "F"."CODE_ARTICLE"                                                          AS "SKU" @description("Product SKU sold"),
    "F"."ID_VENDEUR"                                                            AS "STAFF_ID" @description("Staff member who made the sale"),
    CAST("F"."QUANTITE" AS NUMBER(10,0))                                        AS "QUANTITY" @description("Units sold; negative for returns"),
    CAST(TO_NUMBER("F"."REMISE_PCT") / 100 AS NUMBER(5,4))                      AS "DISCOUNT_RATE" @description("Discount applied as a fraction (0-1)"),
    CAST(0.20 AS NUMBER(5,4))                                                   AS "VAT_RATE" @description("VAT rate applied (French 20%)"),
    CAST(TO_NUMBER(REPLACE("F"."MONTANT_TTC", ',', '.'), 12, 2) AS NUMBER(12,2))          AS "AMOUNT_INCL_VAT_EUR" @description("Line amount including VAT, in EUR"),
    CAST(ROUND(TO_NUMBER(REPLACE("F"."MONTANT_TTC", ',', '.'), 12, 2) / 1.20, 2) AS NUMBER(12,2)) AS "NET_AMOUNT_EXCL_VAT_EUR" @description("Line net amount excluding VAT, in EUR (gross / 1.20)"),
    CAST(TO_NUMBER("F"."QUANTITE") < 0 AS BOOLEAN)                              AS "IS_RETURN" @description("True when the line is a return (negative quantity)"),
    "F"."_FILE_NAME"                                                            AS "SOURCE_FILE_NAME" @description("Source file the row was loaded from"),
    "F"."_LOADED_AT"                                                            AS "LOADED_TS" @description("Timestamp the row was loaded into RAW")
FROM {{ ref('RAW', 'RAW_SALES_FR') }} "F"
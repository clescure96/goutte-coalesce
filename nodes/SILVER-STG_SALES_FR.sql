@id("6bab5988-b044-4899-a96a-a254db4dd1df")
@nodeType("SQL:::SQLWork")
@description("French POS sales lines, harmonised: English names, typed, net amounts excl. VAT (FR VAT 20%)")
SELECT
    'FR-' || "F"."ID_TICKET" || '-' || "F"."NUM_LIGNE"                          AS "SALE_LINE_KEY",
    CAST('FR' AS VARCHAR(2))                                                    AS "COUNTRY_CODE",
    'FR-' || "F"."ID_TICKET"                                                    AS "TICKET_KEY",
    CAST("F"."NUM_LIGNE" AS NUMBER(5,0))                                        AS "LINE_NO",
    TO_DATE("F"."DATE_VENTE", 'DD/MM/YYYY')                                     AS "SALE_DATE",
    TO_TIME("F"."HEURE_VENTE")                                                  AS "SALE_TIME",
    "F"."CODE_MAGASIN"                                                          AS "STORE_CODE",
    "F"."CODE_ARTICLE"                                                          AS "SKU",
    "F"."ID_VENDEUR"                                                            AS "STAFF_ID",
    CAST("F"."QUANTITE" AS NUMBER(10,0))                                        AS "QUANTITY",
    CAST(TO_NUMBER("F"."REMISE_PCT") / 100 AS NUMBER(5,4))                      AS "DISCOUNT_RATE",
    CAST(0.20 AS NUMBER(5,4))                                                   AS "VAT_RATE",
    CAST(TO_NUMBER(REPLACE("F"."MONTANT_TTC", ',', '.'), 12, 2) AS NUMBER(12,2))          AS "AMOUNT_INCL_VAT_EUR",
    CAST(ROUND(TO_NUMBER(REPLACE("F"."MONTANT_TTC", ',', '.'), 12, 2) / 1.20, 2) AS NUMBER(12,2)) AS "NET_AMOUNT_EXCL_VAT_EUR",
    CAST(TO_NUMBER("F"."QUANTITE") < 0 AS BOOLEAN)                              AS "IS_RETURN",
    "F"."_FILE_NAME"                                                            AS "SOURCE_FILE_NAME",
    "F"."_LOADED_AT"                                                            AS "LOADED_TS"
FROM {{ ref('RAW', 'RAW_SALES_FR') }} "F"
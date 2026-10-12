@id("e54674a2-41ca-4bf3-b25d-2704ad69a342")
@nodeType("SQL:::SQLWork")
@description("Product master from HQ PLM: one row per SKU")
SELECT
    "P"."SKU"                                                         AS "SKU"            @not_null @uniqueness,
    "P"."STYLE_CODE"                                                  AS "STYLE_CODE",
    "P"."PRODUCT_NAME"                                                AS "PRODUCT_NAME",
    "P"."CATEGORY"                                                    AS "CATEGORY",
    "P"."GENDER"                                                      AS "GENDER",
    "P"."COLLECTION"                                                  AS "COLLECTION",
    "P"."SEASON"                                                      AS "SEASON",
    "P"."COLOR"                                                       AS "COLOR",
    "P"."SIZE"                                                        AS "SIZE",
    CAST(TO_NUMBER("P"."LIST_PRICE_EUR_INCL_VAT", 10, 2) AS NUMBER(10,2)) AS "LIST_PRICE_INCL_VAT_EUR",
    CAST(TO_NUMBER("P"."UNIT_COST_EUR", 10, 2) AS NUMBER(10,2))       AS "UNIT_COST_EXCL_VAT_EUR"
FROM {{ ref('RAW', 'RAW_PRODUCTS') }} "P"
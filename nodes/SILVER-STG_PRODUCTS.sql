@id("e54674a2-41ca-4bf3-b25d-2704ad69a342")
@nodeType("SQL:::SQLWork")
@description("Product master from HQ PLM: one row per SKU")
SELECT
    "P"."SKU"                                                         AS "SKU"            @not_null @uniqueness @description("Stock keeping unit; unique product identifier"),
    "P"."STYLE_CODE"                                                  AS "STYLE_CODE" @description("Style code grouping SKUs of the same design"),
    "P"."PRODUCT_NAME"                                                AS "PRODUCT_NAME" @description("Product display name"),
    "P"."CATEGORY"                                                    AS "CATEGORY" @description("Product category"),
    "P"."GENDER"                                                      AS "GENDER" @description("Target gender"),
    "P"."COLLECTION"                                                  AS "COLLECTION" @description("Collection the product belongs to"),
    "P"."SEASON"                                                      AS "SEASON" @description("Season the product belongs to"),
    "P"."COLOR"                                                       AS "COLOR" @description("Product color"),
    "P"."SIZE"                                                        AS "SIZE" @description("Product size"),
    CAST(TO_NUMBER("P"."LIST_PRICE_EUR_INCL_VAT", 10, 2) AS NUMBER(10,2)) AS "LIST_PRICE_INCL_VAT_EUR" @description("List/retail price in EUR, including VAT"),
    CAST(TO_NUMBER("P"."UNIT_COST_EUR", 10, 2) AS NUMBER(10,2))       AS "UNIT_COST_EXCL_VAT_EUR" @description("Unit cost in EUR, excluding VAT")
FROM {{ ref('RAW', 'RAW_PRODUCTS') }} "P"
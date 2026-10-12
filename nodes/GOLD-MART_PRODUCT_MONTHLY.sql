@id("664d5273-71d5-46eb-9b39-e9b2731f8efb")
@nodeType("SQL:::SQLWork")
@materializationType("view")
@description("Monthly product mix per country: revenue, units and return rate by category, gender and collection")
WITH "AGG" AS (
    SELECT
        DATE_TRUNC('MONTH', "F"."SALE_DATE")                  AS "MONTH_DATE",
        "F"."COUNTRY_CODE"                                    AS "COUNTRY_CODE",
        "P"."CATEGORY"                                        AS "CATEGORY",
        "P"."GENDER"                                          AS "GENDER",
        "P"."COLLECTION"                                      AS "COLLECTION",
        SUM("F"."NET_AMOUNT_EXCL_VAT_EUR")                    AS "NET_REVENUE",
        SUM(IFF("F"."IS_RETURN", 0, "F"."QUANTITY"))          AS "UNITS_SOLD",
        SUM(IFF("F"."IS_RETURN", -"F"."QUANTITY", 0))         AS "UNITS_RETURNED"
    FROM {{ ref('GOLD', 'FCT_SALES') }} "F"
    JOIN {{ ref('GOLD', 'DIM_PRODUCT') }} "P" ON "P"."SKU" = "F"."SKU"
    GROUP BY 1, 2, 3, 4, 5
)
SELECT
    CAST("A"."MONTH_DATE" AS DATE)                                          AS "MONTH_DATE",
    CAST("A"."COUNTRY_CODE" AS VARCHAR(2))                                  AS "COUNTRY_CODE",
    CAST("A"."CATEGORY" AS VARCHAR)                                         AS "CATEGORY",
    CAST("A"."GENDER" AS VARCHAR)                                           AS "GENDER",
    CAST("A"."COLLECTION" AS VARCHAR)                                       AS "COLLECTION",
    CAST("A"."NET_REVENUE" AS NUMBER(14,2))                                 AS "NET_REVENUE_EXCL_VAT_EUR",
    CAST("A"."UNITS_SOLD" AS NUMBER(10,0))                                  AS "UNITS_SOLD",
    CAST("A"."UNITS_RETURNED" AS NUMBER(10,0))                              AS "UNITS_RETURNED",
    CAST("A"."UNITS_RETURNED" / NULLIF("A"."UNITS_SOLD", 0) AS NUMBER(6,4)) AS "RETURN_RATE"
FROM "AGG" "A"
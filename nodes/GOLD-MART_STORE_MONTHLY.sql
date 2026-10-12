@id("fe7f1b5c-ba3b-4a92-9ce7-eb22bfcc772e")
@nodeType("SQL:::SQLWork")
@materializationType("view")
@description("Monthly store performance vs target: revenue, margin, basket, UPT, returns. Main dashboard source for the CFO.")
WITH "SALES" AS (
    SELECT
        DATE_TRUNC('MONTH', "F"."SALE_DATE")                          AS "MONTH_DATE",
        "F"."STORE_CODE"                                              AS "STORE_CODE",
        "F"."TICKET_KEY"                                              AS "TICKET_KEY",
        "F"."QUANTITY"                                                AS "QUANTITY",
        "F"."IS_RETURN"                                               AS "IS_RETURN",
        "F"."NET_AMOUNT_EXCL_VAT_EUR"                                 AS "NET_AMOUNT",
        "F"."QUANTITY" * "P"."UNIT_COST_EXCL_VAT_EUR"                 AS "COST_AMOUNT"
    FROM {{ ref('GOLD', 'FCT_SALES') }} "F"
    LEFT JOIN {{ ref('GOLD', 'DIM_PRODUCT') }} "P" ON "P"."SKU" = "F"."SKU"
),
"AGG" AS (
    SELECT
        "SA"."MONTH_DATE", "SA"."STORE_CODE",
        SUM("SA"."NET_AMOUNT")                                                AS "NET_REVENUE",
        SUM("SA"."NET_AMOUNT") - SUM("SA"."COST_AMOUNT")                      AS "GROSS_MARGIN",
        COUNT(DISTINCT IFF("SA"."IS_RETURN", NULL, "SA"."TICKET_KEY"))        AS "TICKETS",
        SUM(IFF("SA"."IS_RETURN", 0, "SA"."QUANTITY"))                        AS "UNITS_SOLD",
        SUM(IFF("SA"."IS_RETURN", -"SA"."QUANTITY", 0))                       AS "UNITS_RETURNED"
    FROM "SALES" "SA"
    GROUP BY "SA"."MONTH_DATE", "SA"."STORE_CODE"
)
SELECT
    CAST("A"."MONTH_DATE" AS DATE)                                            AS "MONTH_DATE",
    CAST("S"."COUNTRY_CODE" AS VARCHAR(2))                                    AS "COUNTRY_CODE",
    CAST("A"."STORE_CODE" AS VARCHAR)                                         AS "STORE_CODE",
    CAST("S"."STORE_NAME" AS VARCHAR)                                         AS "STORE_NAME",
    CAST("S"."STORE_TYPE" AS VARCHAR)                                         AS "STORE_TYPE",
    CAST("A"."NET_REVENUE" AS NUMBER(14,2))                                   AS "NET_REVENUE_EXCL_VAT_EUR",
    CAST("A"."GROSS_MARGIN" AS NUMBER(14,2))                                  AS "GROSS_MARGIN_EUR",
    CAST("A"."GROSS_MARGIN" / NULLIF("A"."NET_REVENUE", 0) AS NUMBER(6,4))    AS "GROSS_MARGIN_RATE",
    CAST("A"."TICKETS" AS NUMBER(10,0))                                       AS "TICKETS",
    CAST("A"."UNITS_SOLD" AS NUMBER(10,0))                                    AS "UNITS_SOLD",
    CAST("A"."NET_REVENUE" / NULLIF("A"."TICKETS", 0) AS NUMBER(10,2))        AS "AVG_BASKET_EUR",
    CAST("A"."UNITS_SOLD" / NULLIF("A"."TICKETS", 0) AS NUMBER(6,2))          AS "UPT",
    CAST("A"."UNITS_RETURNED" / NULLIF("A"."UNITS_SOLD", 0) AS NUMBER(6,4))   AS "RETURN_RATE",
    CAST("T"."TARGET_NET_REVENUE_EUR" AS NUMBER(14,2))                        AS "TARGET_NET_REVENUE_EUR",
    CAST("A"."NET_REVENUE" / NULLIF("T"."TARGET_NET_REVENUE_EUR", 0) AS NUMBER(6,4)) AS "TARGET_ACHIEVEMENT_RATE"
FROM "AGG" "A"
JOIN {{ ref('GOLD', 'DIM_STORE') }} "S"
    ON "S"."STORE_CODE" = "A"."STORE_CODE" AND "S"."SYSTEM_CURRENT_FLAG" = 'Y'
LEFT JOIN {{ ref('SILVER', 'STG_TARGETS') }} "T"
    ON "T"."STORE_CODE" = "A"."STORE_CODE" AND "T"."TARGET_MONTH_DATE" = "A"."MONTH_DATE"
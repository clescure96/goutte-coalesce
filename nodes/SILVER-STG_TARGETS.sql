@id("92e6314f-551d-4a3f-8e21-b476a179fe63")
@nodeType("SQL:::SQLWork")
@description("Monthly net revenue targets (excl. VAT) per store")
SELECT
    "T"."STORE_CODE"                                                  AS "STORE_CODE"          @not_null @description("Store this target applies to"),
    TO_DATE("T"."TARGET_MONTH" || '-01', 'YYYY-MM-DD')                AS "TARGET_MONTH_DATE"   @not_null @description("First day of the target month"),
    CAST(TO_NUMBER("T"."TARGET_NET_REVENUE_EUR", 12, 2) AS NUMBER(12,2)) AS "TARGET_NET_REVENUE_EUR" @min_value("0") @description("Monthly net revenue target in EUR, excl. VAT")
FROM {{ ref('RAW', 'RAW_TARGETS') }} "T"
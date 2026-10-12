@id("2a98c573-420f-4312-a611-8ca8895cbb76")
@nodeType("SQL:::SQLWork")
@description("Sales staff master - contains PII (masked in gold)")
SELECT
    "E"."STAFF_ID"                                    AS "STAFF_ID"       @not_null @uniqueness,
    "E"."STORE_CODE"                                  AS "STORE_CODE",
    "E"."FIRST_NAME"                                  AS "FIRST_NAME",
    "E"."LAST_NAME"                                   AS "LAST_NAME",
    "E"."EMAIL"                                       AS "EMAIL",
    "E"."PHONE"                                       AS "PHONE",
    "E"."JOB_TITLE"                                   AS "JOB_TITLE",
    TO_DATE("E"."HIRE_DATE", 'YYYY-MM-DD')            AS "HIRE_DATE"
FROM {{ ref('RAW', 'RAW_STAFF') }} "E"
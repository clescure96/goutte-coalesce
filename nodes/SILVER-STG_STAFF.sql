@id("2a98c573-420f-4312-a611-8ca8895cbb76")
@nodeType("SQL:::SQLWork")
@description("Sales staff master - contains PII (masked in gold)")
SELECT
    "E"."STAFF_ID"                                    AS "STAFF_ID"       @not_null @uniqueness @description("Unique staff member identifier"),
    "E"."STORE_CODE"                                  AS "STORE_CODE" @description("Store the staff member is assigned to"),
    "E"."FIRST_NAME"                                  AS "FIRST_NAME" @description("Staff first name (PII)"),
    "E"."LAST_NAME"                                   AS "LAST_NAME" @description("Staff last name (PII)"),
    "E"."EMAIL"                                       AS "EMAIL" @description("Staff email address (PII)"),
    "E"."PHONE"                                       AS "PHONE" @description("Staff phone number (PII)"),
    "E"."JOB_TITLE"                                   AS "JOB_TITLE" @description("Job title/role"),
    TO_DATE("E"."HIRE_DATE", 'YYYY-MM-DD')            AS "HIRE_DATE" @description("Date the staff member was hired")
FROM {{ ref('RAW', 'RAW_STAFF') }} "E"
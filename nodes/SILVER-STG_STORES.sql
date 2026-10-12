@id("2a3c4af8-ccf4-4d83-bcd0-22829e4ac9f0")
@nodeType("SQL:::SQLWork")
@description("Store master (full snapshot delivered by HQ)")
SELECT
    "S"."STORE_CODE"                                  AS "STORE_CODE"     @not_null @uniqueness @description("Unique store identifier"),
    "S"."STORE_NAME"                                  AS "STORE_NAME" @description("Store name"),
    "S"."CITY"                                        AS "CITY" @description("City where the store is located"),
    CAST("S"."COUNTRY_CODE" AS VARCHAR(2))            AS "COUNTRY_CODE"   @accepted_values("'FR', 'DE', 'ES'") @description("Country of the store (FR, DE, ES)"),
    "S"."REGION"                                      AS "REGION" @description("Region/area the store belongs to"),
    "S"."STORE_TYPE"                                  AS "STORE_TYPE"     @accepted_values("'flagship', 'city', 'outlet'") @description("Store format: flagship, city, or outlet"),
    CAST("S"."SURFACE_SQM" AS NUMBER(6,0))            AS "SURFACE_SQM" @description("Sales floor surface in square meters"),
    TO_DATE("S"."OPENING_DATE", 'YYYY-MM-DD')         AS "OPENING_DATE" @description("Date the store opened")
FROM {{ ref('RAW', 'RAW_STORES') }} "S"
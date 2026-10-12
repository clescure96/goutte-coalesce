@id("3d752098-9c14-4a66-8634-697c24957c25")
@nodeType("SQL:::SQLWork")
@description("Calendar dimension, 2024-01-01 to 2026-12-31")
WITH "DATES" AS (
    SELECT DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1, '2024-01-01'::DATE) AS "DATE_DAY"
    FROM TABLE(GENERATOR(ROWCOUNT => 1096))
)
SELECT
    CAST("X"."DATE_DAY" AS DATE)                                AS "DATE_DAY"        @not_null @uniqueness,
    CAST(YEAR("X"."DATE_DAY") AS NUMBER(4,0))                   AS "YEAR_NUM",
    CAST(QUARTER("X"."DATE_DAY") AS NUMBER(1,0))                AS "QUARTER_NUM",
    CAST(MONTH("X"."DATE_DAY") AS NUMBER(2,0))                  AS "MONTH_NUM",
    CAST(TO_CHAR("X"."DATE_DAY", 'MMMM') AS VARCHAR)            AS "MONTH_NAME",
    CAST(DATE_TRUNC('MONTH', "X"."DATE_DAY") AS DATE)           AS "MONTH_START_DATE",
    CAST(WEEKISO("X"."DATE_DAY") AS NUMBER(2,0))                AS "ISO_WEEK_NUM",
    CAST(DAYNAME("X"."DATE_DAY") AS VARCHAR)                    AS "DAY_NAME",
    CAST(DAYOFWEEKISO("X"."DATE_DAY") IN (6, 7) AS BOOLEAN)     AS "IS_WEEKEND",
    CAST(MONTH("X"."DATE_DAY") IN (1, 7) AS BOOLEAN)            AS "IS_SALES_SEASON"
FROM "DATES" "X"
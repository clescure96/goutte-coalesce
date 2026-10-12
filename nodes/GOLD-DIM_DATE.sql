@id("3d752098-9c14-4a66-8634-697c24957c25")
@nodeType("SQL:::SQLWork")
@description("Calendar dimension, 2024-01-01 to 2026-12-31")
WITH "DATES" AS (
    SELECT DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1, '2024-01-01'::DATE) AS "DATE_DAY"
    FROM TABLE(GENERATOR(ROWCOUNT => 1096))
)
SELECT
    CAST("X"."DATE_DAY" AS DATE)                                AS "DATE_DAY"        @not_null @uniqueness @description("Calendar day; grain of the dimension"),
    CAST(YEAR("X"."DATE_DAY") AS NUMBER(4,0))                   AS "YEAR_NUM" @description("Calendar year"),
    CAST(QUARTER("X"."DATE_DAY") AS NUMBER(1,0))                AS "QUARTER_NUM" @description("Calendar quarter (1-4)"),
    CAST(MONTH("X"."DATE_DAY") AS NUMBER(2,0))                  AS "MONTH_NUM" @description("Month number (1-12)"),
    CAST(TO_CHAR("X"."DATE_DAY", 'MMMM') AS VARCHAR)            AS "MONTH_NAME" @description("Full month name"),
    CAST(DATE_TRUNC('MONTH', "X"."DATE_DAY") AS DATE)           AS "MONTH_START_DATE" @description("First day of the month"),
    CAST(WEEKISO("X"."DATE_DAY") AS NUMBER(2,0))                AS "ISO_WEEK_NUM" @description("ISO week number (1-53)"),
    CAST(DAYNAME("X"."DATE_DAY") AS VARCHAR)                    AS "DAY_NAME" @description("Day-of-week name"),
    CAST(DAYOFWEEKISO("X"."DATE_DAY") IN (6, 7) AS BOOLEAN)     AS "IS_WEEKEND" @description("True for Saturday and Sunday"),
    CAST(MONTH("X"."DATE_DAY") IN (1, 7) AS BOOLEAN)            AS "IS_SALES_SEASON" @description("True during sale-season months (January and July)")
FROM "DATES" "X"
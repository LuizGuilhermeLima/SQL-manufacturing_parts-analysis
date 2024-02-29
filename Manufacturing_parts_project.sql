-- Create a new database named 'manufacturing'
create database manufacturing;

-- Switch to the 'manufacturing' database
use manufacturing;

-- Drop the table 'manufacturing_parts' if it exists in the 'manufacturing' database
drop table if exists manufacturing.manufacturing_parts;

-- Create a new table 'manufacturing_parts' in the 'manufacturing' database
create table manufacturing.manufacturing_parts (
    item_no                 int,
    length                  float8,
    width                   float8,
    height                  float8,
    operator                varchar(10)
);

-- Truncate (delete all records from) the 'manufacturing_parts' table to start with an empty table
truncate manufacturing.manufacturing_parts;

-- Load data from a CSV file 'parts.csv' into the 'manufacturing_parts' table
load data local infile '.../parts.csv'
into table manufacturing.manufacturing_parts
fields terminated by ',' ENCLOSED BY '"'
lines terminated by '\n'
ignore 1 lines;

-- Select the first 5 records from the 'manufacturing_parts' table to verify the data has been loaded correctly
select * from manufacturing_parts limit 5;

-- Truncate (delete all records from) the 'alerts_data' table to start with an empty table
truncate manufacturing.alerts_data;

-- Drop the table 'alerts_data' if it exists in the 'manufacturing' database
drop table if exists manufacturing.alerts_data;

-- Create a new table called alerts_data in the manufacturing schema to store the calculated alerts data
create table manufacturing.alerts_data as

-- Common Table Expressions (CTEs) to calculate statistics and control limits for manufacturing parts
-- Calculate statistics for each operator, including average height, standard deviation, and row number
WITH OperatorStats AS (
    SELECT
        operator,
        height,
        AVG(height) OVER (PARTITION BY operator ORDER BY item_no ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS avg_height,
        STDDEV(height) OVER (PARTITION BY operator ORDER BY item_no ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS stddev_height,
        ROW_NUMBER() OVER (PARTITION BY operator ORDER BY item_no) AS row_num
    FROM
        manufacturing_parts
),
-- Calculate control limits for each operator based on the statistics calculated in OperatorStats CTE
ControlLimits AS (
    SELECT
        operator,
        height,
        avg_height,
        stddev_height,
        avg_height + (3 * stddev_height / SQRT(5)) AS ucl, -- Calculate Upper Control Limit (UCL)
        CASE WHEN (avg_height - (3 * stddev_height / SQRT(5))) < 0 THEN 0 ELSE avg_height - (3 * stddev_height / SQRT(5)) END AS lcl, -- Calculate Lower Control Limit (LCL), ensuring it's not negative
        row_num
    FROM
        OperatorStats
    WHERE row_num >= 5 -- Exclude the first 4 rows as they don't have enough data points for control limit calculation
)
-- Select the final data to be stored in alerts_data table, including operator, row number, height, statistics, control limits, and alert status
SELECT
    operator,
    row_num,
    height,
    avg_height,
    stddev_height,
    ucl,
    lcl,
    height NOT BETWEEN lcl AND ucl AS alert -- Determine if the height is outside the control limits (1 if outside, 0 if within)
FROM
    ControlLimits
ORDER BY
    operator, row_num; -- Order the results by operator and row number

-- Showing the resulting alerts info that was created by the query
select * from alerts_data

-- Note that questions or code explanation comments are written with '--', while answers or short soutions are written with '/* */'


--Data Exploration and Cleansing
--1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month
ALTER TABLE fresh_segments.interest_metrics
ALTER COLUMN month_year TYPE DATE
USING TO_DATE(month_year, 'MM-YYYY');

select * from fresh_segments.interest_metrics

--2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?
SELECT month_year, COUNT(*) 
FROM fresh_segments.interest_metrics 
GROUP BY month_year 
ORDER BY month_year ASC;

--3. What do you think we should do with these null values in the fresh_segments.interest_metrics
--since there are a lot of null values, and exclusion may bias the result, I will add a new column 'month_year_is_null' to indicate if a value was inputed or left null
ALTER TABLE fresh_segments.interest_metrics
ADD COLUMN month_year_is_null BOOLEAN;

--udating the flagged column
UPDATE fresh_segments.interest_metrics
SET month_year_is_null = (month_year IS NULL);

--then put a placeholder date '1970-01-01' to keep the dataset complete
UPDATE fresh_segments.interest_metrics
SET month_year = '1970-01-01'
WHERE month_year IS NULL;

--then, I ensure to exclude the placeholder dates where it may affect the analysis
SELECT *
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01';

--4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?
--check the data types 
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'interest_metrics' AND column_name = 'interest_id';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'interest_map' AND column_name = 'id';

-- Interest_id values in interest_metrics but not in interest_map
SELECT DISTINCT interest_id
FROM fresh_segments.interest_metrics 
WHERE interest_id::INTEGER NOT IN (SELECT id FROM fresh_segments.interest_map)
AND month_year <> '1970-01-01';  -- Excluding placeholder dates

-- Interest_id values in interest_map but not in interest_metrics
SELECT DISTINCT id 
FROM fresh_segments.interest_map 
WHERE id NOT IN (SELECT interest_id::INTEGER FROM fresh_segments.interest_metrics);

--5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table
SELECT DISTINCT id, COUNT(*) AS record_count
FROM fresh_segments.interest_map 
GROUP BY id;

--6. What sort of table join should we perform for our analysis and why? 
/*in this scenario, LEFT JOIN is the best type of JOIN to use 
LEFT JOIN ensures I maintain all records from interest_metrics, which is crucial for a complete analysis.
INNER JOIN and RIGHT JOIN could exclude important data from interest_metrics, which you likely want to avoid.
FULL OUTER JOIN could include too much irrelevant data, complicating the analysis.*/
SELECT im.*, imap.interest_name, imap.interest_summary, imap.created_at, imap.last_modified
FROM fresh_segments.interest_metrics im
LEFT JOIN fresh_segments.interest_map imap 
ON im.interest_id::INTEGER = imap.id  -- Convert interest_id to INTEGER

--6b, Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.
SELECT im.*, imap.interest_name, imap.interest_summary, imap.created_at, imap.last_modified
FROM fresh_segments.interest_metrics im
LEFT JOIN fresh_segments.interest_map imap 
ON im.interest_id::INTEGER = imap.id  -- Convert interest_id to INTEGER
WHERE im.interest_id::INTEGER = 21246;  -- Convert interest_id to INTEGER in the WHERE clause as well

--7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? 
/*yes there are, this may be because of 'data entry errors', or 'data processing issues', amongst other causes*/
--7b. Do you think these values are valid and why?
/*I believe these values are invalid because, it would not make sense for an interest_id to have associated metrics before it was created or available in the system. 
This suggests that these records may not be valid and need further investigation or correction.
the query shows the data in 7.*/
SELECT im.*, imap.created_at 
FROM fresh_segments.interest_metrics im 
JOIN fresh_segments.interest_map imap 
ON im.interest_id::INTEGER = imap.id  -- Convert interest_id to INTEGER
WHERE im.month_year < imap.created_at;

--INTEREST ANALYSIS
--1. Which interests have been present in all month_year dates in our dataset?
SELECT interest_id
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
GROUP BY interest_id
HAVING COUNT(DISTINCT month_year) = (SELECT COUNT(DISTINCT month_year) FROM fresh_segments.interest_metrics WHERE month_year <> '1970-01-01');

--2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months 
-- which total_months value passes the 90% cumulative percentage value?
WITH total_months AS (
    SELECT interest_id, COUNT(DISTINCT month_year) AS months_present
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY interest_id
),
ranked_months AS (
    SELECT months_present, COUNT(*) AS frequency
    FROM total_months
    GROUP BY months_present
),
cumulative_totals AS (
    SELECT months_present,
           frequency,
           SUM(frequency) OVER (ORDER BY months_present DESC) AS cumulative_frequency,
           SUM(frequency) OVER () AS total_frequency
    FROM ranked_months
)
SELECT months_present, 
       (cumulative_frequency::DECIMAL / total_frequency) * 100 AS cumulative_percentage
FROM cumulative_totals
WHERE (cumulative_frequency::DECIMAL / total_frequency) * 100 > 90;

--3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question 
-- how many total data points would we be removing?
SELECT COUNT(*)
FROM fresh_segments.interest_metrics
WHERE interest_id NOT IN (
    SELECT interest_id
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY interest_id
    HAVING COUNT(DISTINCT month_year) >= 14  -- Example value from previous calculation
);

--4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.
     /*From a business perspective, it generally makes sense to remove data points representing interests with less than 14 months of data if the goal is to focus on long-term, stable trends. 
     This approach reduces noise and ensures that strategic decisions are based on consistent and reliable data. 
     However, there should be exceptions for newly emerging interests or seasonal interests where incomplete data still offers valuable insights.*/

--5. After removing these interests - how many unique interests are there for each month?
SELECT month_year, COUNT(DISTINCT interest_id) AS unique_interests
FROM fresh_segments.interest_metrics
WHERE interest_id IN (
    SELECT interest_id
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY interest_id
    HAVING COUNT(DISTINCT month_year) >= 14
)
GROUP BY month_year;

WITH filtered_interests AS (
    SELECT interest_id
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY interest_id
    HAVING COUNT(DISTINCT month_year) >= 14  -- Only keep interests with data in at least 14 months
)
SELECT month_year, COUNT(DISTINCT interest_id) AS unique_interests
FROM fresh_segments.interest_metrics
WHERE interest_id IN (SELECT interest_id FROM filtered_interests)
GROUP BY month_year
ORDER BY month_year;


--SEGMENT ANALYSIS
--1. Using our filtered dataset by removing the interests with less than 6 months worth of data, 
--which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? 
--Only use the maximum composition value for each interest but you must keep the corresponding month_year

-- Top 10
SELECT interest_id, MAX(composition) AS max_composition, month_year
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
GROUP BY interest_id, month_year
ORDER BY max_composition DESC
LIMIT 10;

-- Bottom 10
SELECT interest_id, MAX(composition) AS max_composition, month_year
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
GROUP BY interest_id, month_year
ORDER BY max_composition ASC
LIMIT 10;

--2. Which 5 interests had the lowest average ranking value?
SELECT interest_id, AVG(ranking) AS avg_ranking
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
GROUP BY interest_id
ORDER BY avg_ranking ASC
LIMIT 5;

--3. Which 5 interests had the largest standard deviation in their percentile_ranking value?

--excluding null values
SELECT interest_id, 
       STDDEV(percentile_ranking) AS stddev_percentile_ranking
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
  AND percentile_ranking IS NOT NULL  -- Exclude NULL percentile_ranking values
GROUP BY interest_id
HAVING COUNT(percentile_ranking) > 1  -- Ensure there are at least two data points
ORDER BY stddev_percentile_ranking DESC
LIMIT 5;

--4. For the 5 interests found in the previous question 
-- what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? 
--Can you describe what is happening for these 5 interests?
SELECT interest_id, MIN(percentile_ranking) AS min_percentile, MAX(percentile_ranking) AS max_percentile, month_year
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
AND interest_id IN (
    SELECT interest_id
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY interest_id
    ORDER BY STDDEV(percentile_ranking) DESC
    LIMIT 5
)
GROUP BY interest_id, month_year;

--5. How would you describe our customers in this segment based off their composition and ranking values? 
--What sort of products or services should we show to these customers and what should we avoid?(Find solution in document)

--INDEX ANALYSIS
--1. What is the top 10 interests by the average composition for each month?
SELECT interest_id, AVG(composition / index_value) AS avg_composition
FROM fresh_segments.interest_metrics
WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
GROUP BY interest_id
ORDER BY avg_composition DESC
LIMIT 10;

--2. For all of these top 10 interests - which interest appears the most often?
SELECT interest_id, COUNT(*)
FROM (
    SELECT interest_id, AVG(composition / index_value) AS avg_composition
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY interest_id
    ORDER BY avg_composition DESC
    LIMIT 10
) AS top_interests
GROUP BY interest_id
ORDER BY COUNT(*) DESC
LIMIT 1;

--3. What is the average of the average composition for the top 10 interests for each month?
WITH avg_composition AS (
    SELECT month_year, interest_id, AVG(composition / index_value) AS avg_comp
    FROM fresh_segments.interest_metrics
    WHERE month_year <> '1970-01-01'  -- Exclude placeholder dates
    GROUP BY month_year, interest_id
),
ranked_interests AS (
    SELECT month_year, interest_id, avg_comp, RANK() OVER (ORDER BY avg_comp DESC) AS rank
    FROM avg_composition
)
SELECT month_year, interest_id, avg_comp, 
       AVG(avg_comp) OVER (ORDER BY month_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM ranked_interests
WHERE rank = 1;

--4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.
--For each month, calculate the average composition value by dividing the composition by the index value and identify the interest with the highest average composition.
--Calculate the rolling average of these top values over a 3-month window, allowing you to see how the max average composition evolves over time.

WITH avg_compositions AS (
    SELECT month_year, interest_id, (composition / index_value) AS avg_composition
    FROM fresh_segments.interest_metrics
    WHERE month_year BETWEEN '2018-09-01' AND '2019-08-01'
),
ranked_interests AS (
    SELECT month_year, interest_id, avg_composition,
           ROW_NUMBER() OVER (PARTITION BY month_year ORDER BY avg_composition DESC) AS rank
    FROM avg_compositions
)
SELECT month_year, interest_id, avg_composition,
       AVG(avg_composition) OVER (ORDER BY month_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM ranked_interests
WHERE rank = 1;

--5. Provide a possible reason why the max average composition might change from month to month? 
--Could it signal something is not quite right with the overall business model for Fresh Segments? (Find solution in document)



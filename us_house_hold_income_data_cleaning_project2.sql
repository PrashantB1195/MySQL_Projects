#US house hold data cleaning project

SELECT*
FROM us_household_income
;

ALTER TABLE us_household_income_statistics RENAME COLUMN `ID` TO `id`;

SELECT*
FROM us_household_income_statistics
;

#count id's from both table

SELECT COUNT(id)
FROM us_household_income
;

SELECT COUNT(id)
FROM us_household_income_statistics
;

#identifying duplicates from us_household_income table

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT*
FROM(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM us_household_income
) AS duplicate
WHERE row_num > 1
;

DELETE FROM us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT row_id,
               id,
               ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
        FROM us_household_income
    ) AS duplicate
    WHERE row_num > 1
);

#identifying duplicates from us_household_income_statistics table

SELECT id,COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

#checking spelling mistakes from state name

SELECT DISTINCT(state_name)
FROM us_household_income
ORDER BY 1
;

UPDATE us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia'
;

UPDATE us_household_income
SET state_name = 'Alabama'
WHERE state_name = 'alabama'
;

SELECT *
FROM us_household_income
WHERE place = ''
;

SELECT*
FROM us_household_income
WHERE county = 'Autauga County'
;



UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE county = 'Autauga County'
AND city = 'Vinemont'
;

#checking duplicates in Type column

SELECT Type,COUNT(Type)
FROM us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 
;  

SELECT ALand, AWater
FROM us_household_income
WHERE AWater = 0 
;

# US house hold exploratory data analysis

SELECT*
FROM us_household_income
;

SELECT*
FROM us_household_income_statistics
;

#finding which state have highest/lowest land and water

SELECT State_Name,County,City, ALand,AWater
FROM us_household_income
;

SELECT State_Name,SUM(ALand),SUM(AWater)
FROM us_household_income
GROUP BY State_Name 
ORDER BY SUM(ALand) DESC
;

SELECT State_Name,SUM(ALand),SUM(AWater)
FROM us_household_income
GROUP BY State_Name 
ORDER BY SUM(AWater) DESC
;

#lets see top ten states by land and water

SELECT State_Name,SUM(ALand),SUM(AWater)
FROM us_household_income
GROUP BY State_Name 
ORDER BY SUM(ALand) DESC
LIMIT 10
;

SELECT State_Name,SUM(ALand),SUM(AWater)
FROM us_household_income
GROUP BY State_Name 
ORDER BY SUM(AWater) DESC
LIMIT 10
;

# joining table to see any insights

SELECT*
FROM us_household_income AS uhi
JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
;

SELECT*
FROM us_household_income AS uhi
RIGHT JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE uhi.id IS NULL
;

SELECT*
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
;

SELECT uhi.State_Name,County,Type,`Primary`,Mean,Median
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
;
# finding Avg mean and median for states

SELECT uhi.State_Name,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY uhi.State_Name
ORDER BY AVG(Mean) DESC
;

SELECT uhi.State_Name,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY uhi.State_Name
ORDER BY AVG(Median) DESC
;

SELECT Type,COUNT(Type),ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY AVG(Mean) DESC
LIMIT 10
;

SELECT Type,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY AVG(Mean) DESC
LIMIT 10
;

SELECT Type,COUNT(Type),ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY AVG(Mean) DESC
LIMIT 20
;

SELECT Type,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
INNER JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY AVG(Mean) DESC
LIMIT 20
;

SELECT*
FROM
us_household_income
WHERE Type = 'Community'
;

SELECT uhi.State_Name,city,ROUND(AVG(Mean),1)
FROM us_household_income AS uhi
JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
GROUP BY uhi.State_Name,city
;

SELECT uhi.State_Name,city,ROUND(AVG(Mean),1)
FROM us_household_income AS uhi
JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
GROUP BY uhi.State_Name,city
ORDER BY ROUND(AVG(Mean),1) DESC
;
# lets see which state city makes highest amount of money

SELECT uhi.State_Name,city,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income AS uhi
JOIN us_household_income_statistics AS uhis
ON uhi.id = uhis.id
GROUP BY uhi.State_Name,city
ORDER BY ROUND(AVG(Mean),1) DESC
;




















#World Life Expectancy Project - (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

#Removing any duplicates

SELECT Country, Year, CONCAT(Country,Year), COUNT(CONCAT(Country,Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country,year)
HAVING COUNT(CONCAT(Country,Year)) > 1
;

#Finding duplicate data and there unique row_id

SELECT Row_ID,
       CONCAT(Country, Year),
       ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_num
FROM world_life_expectancy
;

#Using subquery here

SELECT*
FROM(
	 SELECT Row_ID,
	 CONCAT(Country, Year),
	 ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_num
	 FROM world_life_expectancy
     ) AS Row_table
     WHERE Row_num > 1
     ;
     
#Deleting duplicates from table

DELETE FROM world_life_expectancy
WHERE
     Row_ID IN (
     SELECT Row_ID
FROM(
	 SELECT Row_ID,
	 CONCAT(Country, Year),
	 ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_num
	 FROM world_life_expectancy
     ) AS Row_table
     WHERE Row_num > 1
     )
     ;
	
SELECT * 
FROM world_life_expectancy
;

#status is blank so let check how many are there

SELECT*
FROM world_life_expectancy
WHERE Status = ''
;

#lets see total type of status so it will give an idea what to do

SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE Status  <> ''
;

#checking how many countries are there with 'developing' status

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

#now update blank space to corresponding country where status is 'developing'

#we are having more than one country to update status so using IN clause

UPDATE world_life_expectancy
SET status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
                  FROM world_life_expectancy
                  WHERE Status = 'Developing'
                  )
;

#let's use join to work this query, in this query wle1( world_life_expectancy table 1) and wle2( world_life_expectancy table 2) we use to specify country and status

UPDATE world_life_expectancy wle1
JOIN world_life_expectancy wle2
    ON wle1.Country = wle2.Country
SET wle1.Status = 'Developing'
WHERE wle1.Status = ''
AND wle2.Status <> ''
AND wle2.Status = 'Developing'
;

SELECT*
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

UPDATE world_life_expectancy wle1
JOIN world_life_expectancy wle2
    ON wle1.Country = wle2.Country
SET wle1.Status = 'Developed'
WHERE wle1.Status = ''
AND wle2.Status <> ''
AND wle2.Status = 'Developed'
;

SELECT*
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT Country,Year,`Life expectancy` 
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT wle1.Country,wle1.Year,wle1.`Life expectancy`,
 wle2.Country,wle2.Year,wle2.`Life expectancy`,
 wle3.Country,wle3.Year,wle3.`Life expectancy`,
 ROUND((wle2.`Life expectancy` + wle3.`Life expectancy`)/2,1)
FROM world_life_expectancy wle1
  JOIN world_life_expectancy wle2
      ON wle1.Country = wle2.Country
      AND wle1.Year = wle2.Year - 1
  JOIN world_life_expectancy wle3
      ON wle1.Country = wle3.Country
      AND wle1.Year = wle3.Year + 1
WHERE wle1.`Life expectancy` = ''      
;

UPDATE world_life_expectancy wle1
  JOIN world_life_expectancy wle2
      ON wle1.Country = wle2.Country
      AND wle1.Year = wle2.Year - 1
  JOIN world_life_expectancy wle3
      ON wle1.Country = wle3.Country
      AND wle1.Year = wle3.Year + 1
SET wle1.`Life expectancy` = ROUND((wle2.`Life expectancy` + wle3.`Life expectancy`)/2,1)
WHERE wle1.`Life expectancy` = ''
;

SELECT*
FROM world_life_expectancy
;

#World Life Expectancy Project - (Exploratory Analysis)

SELECT Country, 
MIN(`Life expectancy`),
MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country
ORDER BY Country DESC
;

SELECT Country, 
MIN(`Life expectancy`),
MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Country DESC
;

SELECT Country, 
MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years  DESC
;

SELECT Country, 
MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years  ASC
;

SELECT Year, AVG(`Life expectancy`)
FROM world_life_expectancy
GROUP  BY Year
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Year
;

SELECT*
FROM world_life_expectancy
;

SELECT Country,`Life expectancy`,GDP
FROM world_life_expectancy
; 

SELECT Country,
ROUND(AVG(`Life expectancy`),2) AS Life_exp,
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP  BY Country
;

SELECT Country,
ROUND(AVG(`Life expectancy`),2) AS Life_exp,
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP  BY Country
ORDER By Life_exp
;

SELECT Country,
ROUND(AVG(`Life expectancy`),2) AS Life_exp,
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP  BY Country
HAVING Life_exp > 0
AND GDP > 0
ORDER By GDP DESC
;

SELECT
 SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
  AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) AS Low_GDP_Life_exp,
  SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
  AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) AS Low_GDP_Life_exp
FROM world_life_expectancy
;

SELECT*
FROM world_life_expectancy
;

SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status, COUNT(DISTINCT(Country)),ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Country,
ROUND(AVG(`Life expectancy`),1) AS Life_exp,
ROUND(AVG(BMI),1) AS Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_exp > 0
AND Avg_BMI > 0
ORDER BY Avg_BMI DESC
;

SELECT Country, MAX(`under-five deaths`) AS High_under_5_age_children_death
FROM world_life_expectancy
GROUP BY Country
HAVING High_under_5_age_children_death > 0
ORDER BY High_under_5_age_children_death DESC
;

SELECT*
FROM world_life_expectancy
;

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER (PARTITION BY country ORDER BY Year) AS Rolling_total
FROM world_life_expectancy
WHERE Country = "India"
;









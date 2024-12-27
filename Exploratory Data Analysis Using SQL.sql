-- Exploratory data Analysis using SQL

SELECT * 
FROM world_layoffs.layoffs_staging2;

-- Find the max and min total layoffs
SELECT MAX(total_laid_off),MIN(total_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NOT NULL;

-- Find the max and min percentage layoffs
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Find companies that had 100% layoffs
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;

-- filtering by country
SELECT country,percentage_laid_off
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;

-- filter as total
SELECT country,SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- FILTER BY COMPANY
SELECT company,SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 5;

-- YEAR WITH HIGHEST LAYOFFS
SELECT YEAR(`date`),SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- INDUSTRIES WITH THE HIGHEST LAYOFFS
SELECT industry,SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10;

-- Finding th distinct stages in the data
SELECT DISTINCT stage
FROM world_layoffs.layoffs_staging2;

-- Stages of companies with the highest layoffs
SELECT stage,SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT *
FROM world_layoffs.layoffs_staging2;

-- companies per year with the highest layoffs
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- Use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off,SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

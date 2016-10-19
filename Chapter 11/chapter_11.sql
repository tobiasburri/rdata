
/* Only the SQL code is provide.  The permission and licensing issues were not 
 * be resolved with providing the datasets to build the tables                */
 
/* *************************** */
/* section 11.1 SQL Essentials */
/* *************************** */

SELECT first_name,
       last_name
FROM   customer
WHERE  customer_id = 666730 

/* 11.1.1 Joins */

SELECT c.customer_id,
       o.order_id,
       o.product_id,
       o.item_quantity AS qty
FROM   orders o
       INNER JOIN customer c
               ON o.customer_id = c.customer_id
WHERE  c.first_name = 'Mason'
       AND c.last_name = 'Hu'
ORDER  BY o.order_datetime 

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id
FROM   orders o
       RIGHT OUTER JOIN customer c
                     ON o.customer_id = c.customer_id
WHERE  o.order_id IS NULL
ORDER  BY c.last_name,
          c.first_name 
LIMIT 5

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id
FROM   orders o
       RIGHT OUTER JOIN customer c
                     ON o.customer_id = c.customer_id
ORDER  BY c.last_name,
          c.first_name  
LIMIT 5

/* section 11.1.2 Set Operations */

SELECT customer_id,
       order_id,
       order_datetime,
       product_id,
       item_quantity AS qty
FROM   orders_arch
WHERE  product_id = 33611
UNION ALL
SELECT customer_id,
       order_id,
       order_datetime,
       product_id,
       item_quantity AS qty
FROM   orders_recent
WHERE  product_id = 33611
ORDER  BY order_datetime 

SELECT product_id
FROM   orders_arch
INTERSECT
SELECT product_id
FROM   orders_recent

SELECT COUNT(e.*)
FROM   (SELECT product_id
        FROM   orders_arch
        EXCEPT
        SELECT product_id
        FROM   orders_recent) e 

/* ********************************** */
/* section 11.1.3 Grouping Extensions */
/* ********************************** */

SELECT i.product_id,
       SUM(i.item_quantity) AS total
FROM   orders_recent i
GROUP  BY i.product_id
ORDER  BY SUM(i.item_quantity) DESC 
LIMIT 3

SELECT r.product_id,
       DATE_PART('year', r.order_datetime) AS year,
       SUM(r.item_quantity)                AS total
FROM   orders_recent r
WHERE  r.product_id IN (SELECT o.product_id
                        FROM   orders_recent o
                        GROUP  BY o.product_id
                        ORDER  BY SUM(o.item_quantity) DESC
                        LIMIT 3)
GROUP  BY ROLLUP( r.product_id, DATE_PART('year', r.order_datetime) )
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime)

SELECT r.product_id,
       DATE_PART('year', r.order_datetime) AS year,
       SUM(r.item_quantity)                AS total
FROM   orders_recent r
WHERE  r.product_id IN (SELECT o.product_id
                        FROM   orders_recent o
                        GROUP  BY o.product_id
                        ORDER  BY SUM(o.item_quantity) DESC
                        LIMIT 3)
GROUP  BY CUBE( r.product_id, DATE_PART('year', r.order_datetime) )
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime) 

SELECT r.product_id,
       DATE_PART('year', r.order_datetime)           AS year,
       SUM(r.item_quantity)                          AS total,
       GROUPING(r.product_id)                        AS group_id,
       GROUPING(DATE_PART('year', r.order_datetime)) AS group_year
FROM   orders_recent r
WHERE  r.product_id IN (SELECT o.product_id
                        FROM   orders_recent o
                        GROUP  BY o.product_id
                        ORDER  BY SUM(o.item_quantity) DESC
                        LIMIT 3)
GROUP  BY CUBE( r.product_id, DATE_PART('year', r.order_datetime) )
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime) 

SELECT r.product_id,
       DATE_PART('year', r.order_datetime) AS year,
       SUM(r.item_quantity)                AS total
FROM   orders_recent r
WHERE  r.product_id IN (SELECT o.product_id
                        FROM   orders_recent o
                        GROUP  BY o.product_id
                        ORDER  BY SUM(o.item_quantity) DESC
                        LIMIT 3)
GROUP  BY GROUPING SETS( ( r.product_id, DATE_PART('year', r.order_datetime) ),
                                   ( r.product_id ), 
                                   ( DATE_PART('year', r.order_datetime) ), 
                                   ( ) )
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime)  
         

SELECT r.product_id,
       DATE_PART('year', r.order_datetime) AS year,
       SUM(r.item_quantity)                AS total
FROM   orders_recent r
WHERE  r.product_id IN (SELECT o.product_id
                        FROM   orders_recent o
                        GROUP  BY o.product_id
                        ORDER  BY SUM(o.item_quantity) DESC
                        LIMIT 3)
GROUP  BY GROUPING SETS( ( r.product_id, DATE_PART('year', r.order_datetime) ),
                         ( ) )
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime) 

SELECT r.product_id,
       DATE_PART('year', r.order_datetime) AS year,
       SUM(r.item_quantity)                AS total,
       GROUP_ID()                          AS group_id
FROM   orders_recent r
WHERE  r.product_id IN ( 15060 )
GROUP  BY ROLLUP( r.product_id, DATE_PART('year', r.order_datetime) ),
          CUBE( r.product_id, DATE_PART('year', r.order_datetime) )
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime),
          GROUP_ID() 

SELECT r.product_id,
       DATE_PART('year', r.order_datetime) AS year,
       SUM(r.item_quantity)                AS total,
       GROUP_ID()                          AS group_id
FROM   orders_recent r
WHERE  r.product_id IN ( 15060 )
GROUP  BY ROLLUP( r.product_id, DATE_PART('year', r.order_datetime) ),
          CUBE( r.product_id, DATE_PART('year', r.order_datetime) )
HAVING GROUP_ID() = 0
ORDER  BY r.product_id,
          DATE_PART('year', r.order_datetime),
          GROUP_ID() 

/* ************************************** */
/* section 11.2 In-Database Text Analysis */
/* ************************************** */

/* some databases may require the use of a dummy or single row table */
/* in a provided FROM clause to run these statements                 */
 
SELECT SUBSTRING('1234567890', 3,2)   /* returns '34' */
SELECT '1234567890' LIKE '%7%'        /* returns True  */
SELECT '1234567890' LIKE '7%'         /* returns False */
SELECT '1234567890' LIKE '_2%'        /* returns True */
SELECT '1234567890' LIKE '_3%'        /* returns False */
SELECT '1234567890' LIKE '__3%'       /* returns True */

/* Table 11-1 */
SELECT  '123a567' ~ 'a'
SELECT  '123a567' ~* 'A'
SELECT  '123a567' !~ 'A'
SELECT  '123a567' !~* 'b'


/* matches x or y ('x|y')*/
SELECT  '123a567' ~ '23|b'    	/* returns True  */
SELECT  '123a567' ~ '32|b'    	/* returns False */

/* matches the beginning of the string  */
SELECT '123a567' ~ '^123a'       /* returns True  */
SELECT '123a567' ~ '^123a7'      /* returns False */

/* matches the end of the string  */
SELECT '123a567' ~ 'a567$'       /* returns True  */
SELECT '123a567' ~ '27$'         /* returns False */

/* matches any single character */
SELECT '123a567' ~ '2.a'         /* returns True  */
SELECT '123a567' ~ '2..5'        /* returns True  */
SELECT '123a567' ~ '2...5'       /* returns False */

/* matches preceding character zero or more times */
SELECT '123a567' ~ '2*'          /* returns True  */
SELECT '123a567' ~ '2*a'         /* returns True  */
SELECT '123a567' ~ '7*a'         /* returns True  */
SELECT '123a567' ~ '37*'         /* returns True  */
SELECT '123a567' ~ '87*'         /* returns False */

/* matches preceding character one or more times */
SELECT '123a567' ~ '2+'          /* returns True  */
SELECT '123a567' ~ '2+a'         /* returns False */
SELECT '123a567' ~ '7+a'         /* returns False */
SELECT '123a567' ~ '37+'         /* returns False */
SELECT '123a567' ~ '87+'         /* returns False */

/* makes the preceding character optional */
SELECT '123a567' ~ '2?'          /* returns True  */
SELECT '123a567' ~ '2?a'         /* returns True  */
SELECT '123a567' ~ '7?a'         /* returns True  */
SELECT '123a567' ~ '37?'         /* returns True  */
SELECT '123a567' ~ '87?'         /* returns False */

/* Matches the preceding item exactly {n} times */

SELECT '123a567' ~ '5{0}'        /* returns True  */
SELECT '123a567' ~ '5{1}'        /* returns True  */
SELECT '123a567' ~ '5{2}'        /* returns False */
SELECT '1235567' ~ '5{2}'        /* returns True  */
SELECT '123a567' ~ '8{0}'        /* returns True  */
SELECT '123a567' ~ '8{1}'        /* returns False */

/* Matches the contents exactly */
SELECT '123a567' ~ '(23a5)'      /* returns True  */
SELECT '123a567' ~ '(13a5)'      /* returns False */
SELECT '123a567' ~ '(23a5)7*'    /* returns True  */
SELECT '123a567' ~ '(23a5)7+'    /* returns False */

/* Matches any of the contents */
SELECT '123a567' ~ '[23a8]'      /* returns True  */
SELECT '123a567' ~ '[8a32]'      /* returns True  */
SELECT '123a567' ~ '[(13a5)]'    /* returns True  */
SELECT '123a567' ~ '[xyz9]'      /* returns False */
SELECT '123a567' ~ '[a-z]'       /* returns True  */
SELECT '123a567' ~ '[b-z]'       /* returns False */

/* Matches a non-alphanumeric */
SELECT '$50K+' ~ '\\$'           /* returns True */
SELECT '$50K+' ~ '\\+'           /* returns True */
SELECT '$50K+' ~ '\\$\\+'        /* returns False */

/* use of the backslash for escape clauses                        */
/* \\w denotes the characters 0-9, a-z, A-Z, or the underscore(_) */
SELECT '123a567'  ~ '\\w'        /* returns True  */
SELECT '123a567+' ~ '\\w'        /* returns True  */
SELECT '++++++++' ~ '\\w'        /* returns False */
SELECT '_' ~ '\\w'               /* returns True  */
SELECT '+' ~ '\\w'               /* returns False */

/* use of more complex regular expressions */
SELECT '$50K+' ~ '\\$[0-9]*K\\+'           /* returns True  */
SELECT '$50K+' ~ '\\$[0-9]K\\+'            /* returns False */
SELECT '$50M+' ~ '\\$[0-9]*K\\+'           /* returns False */
SELECT '$50M+' ~ '\\$[0-9]*(K|M)\\+'       /* returns True  */

/* check for zipcode of form #####-#### */
SELECT '02038-2531' ~ '[0-9]{5}-[0-9]{4}'  /* returns True  */
SELECT '02038-253'  ~ '[0-9]{5}-[0-9]{4}'  /* returns False */
SELECT '02038'      ~ '[0-9]{5}-[0-9]{4}'  /* returns False */

SELECT address_id, 
       customer_id, 
       city, 
       state, 
       zip, 
       country 
FROM   customer_addresses 
WHERE  zip !~ '^[0-9]{5}-[0-9]{4}$' 

/* to illustrate the above query */
select '57061-o236' !~ '^[0-9]{5}-[0-9]{4}$' 
select 'S0670-0480' !~ '^[0-9]{5}-[0-9]{4}$' 

/* extract zip code from text string */
SELECT SUBSTRING('4321A Main Street Franklin, MA 02038-2531'
FROM '[0-9]{5}-[0-9]{4}')

/* replace long format zip code with short format zip code */
SELECT REGEXP_REPLACE('4321A Main Street Franklin, MA 02038-2531', 
                '[0-9]{5}-[0-9]{4}',
                SUBSTRING(SUBSTRING('4321A Main Street Franklin, MA 02038-2531'
FROM '[0-9]{5}-[0-9]{4}'),1,5)    )

/* ******************************* */
/* section 11.3.1 Window Functions */
/* ******************************* */

SELECT s.customer_id,
       s.sales,
       RANK()
         OVER (
           ORDER BY s.sales DESC ) AS sales_rank
FROM   (SELECT r.customer_id,
               SUM(r.item_quantity * r.item_price) AS sales
        FROM   orders_recent r
        GROUP  BY r.customer_id) s 

SELECT s.category_name,
       s.customer_id,
       s.sales,
       RANK()
         OVER (
           partition BY s.category_name
           ORDER BY s.sales DESC ) AS sales_rank
FROM   (SELECT c.category_name,
               r.customer_id,
               SUM(r.item_quantity * r.item_price) AS sales
        FROM   orders_recent r
               LEFT OUTER JOIN product p
                            ON r.product_id = p.product_id
               LEFT OUTER JOIN category c
                            ON p.category_id = c.category_id
        GROUP  BY c.category_name,
                  r.customer_id) s
ORDER  BY s.category_name,
          sales_rank 

/* moving average */

SELECT year,
       week,
       sales,
       AVG(sales)
         OVER (
           ORDER BY year, week
           ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS moving_avg
FROM   sales_by_week
WHERE  year = 2014
       AND week <= 26
ORDER  BY year,
          week

/* **************************************************** */
/* section 11.3.2 User-defined Functions and Aggregates */
/* **************************************************** */

CREATE FUNCTION fm_convert(text) RETURNS integer AS
'SELECT CASE 
         WHEN $1 = ''F'' THEN 0
         WHEN $1 = ''M'' THEN 1
         ELSE NULL
        END'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT

SELECT customer_gender,
       fm_convert(customer_gender) as male
FROM   customer_demographics 
LIMIT 5

/* EWMA */

CREATE FUNCTION ewma_calc(numeric, numeric, numeric) RETURNS numeric as
/* $1 = prior value of EWMA         */
/* $2 = current value of series     */
/* $3 = alpha, the smoothing factor */
'SELECT CASE
         WHEN $3 IS NULL                       /* bad alpha */
         OR $3 < 0 
         OR $3 > 1 THEN NULL
         WHEN $1 IS NULL THEN $2               /* t = 1        */
         WHEN $2 IS NULL THEN $1               /* y is unknown */
         ELSE ($3 * $2) + (1-$3) *$1           /* t >= 2       */ 
        END'
LANGUAGE SQL
IMMUTABLE

CREATE OR REPLACE FUNCTION dummy_function(numeric,numeric) RETURNS numeric as
'SELECT -9999999.0'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT

CREATE AGGREGATE ewma(numeric, numeric)
       (SFUNC = ewma_calc,
        STYPE = numeric,
        PREFUNC = dummy_function)

SELECT year,
       week,
       sales,
       ewma(sales, .1)
         OVER (
           ORDER BY year, week)
FROM   sales_by_week
WHERE  year = 2014
       AND week <= 26
ORDER  BY year,
          week

/* ******************************** */
/* section 11.3.3 ordered agregates */
/* ******************************** */

SELECT (d.ord_sales[ d.n/2 + 1 ] + d.ord_sales[ (d.n + 1)/2 ]) / 2.0 as median
FROM   (SELECT ARRAY_AGG(s.sales ORDER BY s.sales) AS ord_sales,
               COUNT(*)     AS n
        FROM   sales_by_week s
        WHERE  s.year = 2014
               AND s.week <= 26) d

SELECT ARRAY_AGG(s.sales ORDER BY s.sales) AS ord_sales,
       COUNT(*) AS n  
FROM   sales_by_week s
WHERE  s.year = 2014
       AND s.week <= 5 

SELECT STRING_AGG(s.sales ORDER BY s.sales) AS ord_sales,
       COUNT(*) AS n  
FROM   sales_by_week s
WHERE  s.year = 2014
       AND s.week <= 5

SELECT STRING_AGG(s.sales, ',' ORDER BY s.sales) AS ord_sales,
       COUNT(*) AS n  
FROM   sales_by_week s
WHERE  s.year = 2014
       AND s.week <= 5

/* ************************** */
/* secton 11.3.4 MADlib	      */
/* ************************** */

/* create an empty table to store the input for the k-means analysis */
CREATE TABLE cust_age_sales (
  customer_id integer, 
  coordinates float8[])

/* prepare the input for the k-means analysis */
INSERT INTO cust_age_sales (customer_id, coordinates[1], coordinates[2])
  SELECT d.customer_id,
         d.customer_age,
         CASE
           WHEN s.sales IS NULL THEN 0.0
           ELSE s.sales
         END
  FROM   customer_demographics d
         LEFT OUTER JOIN (SELECT r.customer_id,
                                 SUM(r.item_quantity * r.item_price) AS sales
                          FROM   orders_recent r
                          GROUP  BY r.customer_id) s
         ON d.customer_id = s.customer_id 

/* examine the first 10 rows of the input */
SELECT * from cust_age_sales 
order by customer_id
LIMIT 10

SET SEARCH_PATH to madlib, ddemo

/* 
K-means analysis 

cust_age_sales - SQL table containing the input data
coordinates - the column in the SQL table that contains the data points
customer_id - the column in the SQL table that contains the 
              identifier for each point
km_coord - the table to store each point and its assigned cluster
km_centers - the SQL table to store the centers of each cluster
l2norm - specifies that the standard Euclidean distance formula will be used
25 - the maximum number of iterations
0.001 - a convergence criterion
False(twice) - ignore some options
6 - build six clusters
 */

SELECT madlib.kmeans_random('cust_age_sales', 'coordinates', 'customer_id',
                'km_coord', 'km_centers','l2norm', 25 ,0.001, False, False, 6) 

SELECT *
FROM   km_coord
ORDER  BY pid 
LIMIT 10

SELECT *
FROM   km_centers
ORDER  BY coords 


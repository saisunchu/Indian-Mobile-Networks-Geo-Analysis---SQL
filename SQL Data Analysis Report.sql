USE mndb;

SET SQL_SAFE_UPDATES = 0;

-- 1. Standardize and Validate `radio` Field
Update mcc404 set radio = upper(trim(radio));
Update mcc405 set radio = upper(trim(radio));

-- 2 Handle Missing or Invalid Coordinates
update mcc404 set longitude = null, latitude = null where longitude not between -180 and 180 or latitude not between -90 and 90;
update mcc405 set longitude = null, latitude = null where longitude not between -180 and 180 or latitude not between -90 and 90;

-- 3. Trim Strings and Remove Extra Spaces
UPDATE mcc404 SET mcc = TRIM(mcc), mnc = TRIM(mnc), cid_num = TRIM(cid_num);
UPDATE mcc405 SET mcc = TRIM(mcc), mnc = TRIM(mnc), cid_num = TRIM(cid_num);
UPDATE mcc_mnc_list SET operator = TRIM(operator), circle = TRIM(circle), mcc = TRIM(mcc), mnc = TRIM(mnc);

-- 4. Validate and Deduplicate Data
WITH DupCTE1 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY mcc, mnc, cid_num, longitude, latitude ORDER BY created) AS row_num
    FROM mcc404
)
DELETE FROM mcc404
WHERE EXISTS (
    SELECT 1
    FROM DupCTE1
    WHERE DupCTE1.row_num > 1 
      AND DupCTE1.mcc = mcc404.mcc 
      AND DupCTE1.mnc = mcc404.mnc 
      AND DupCTE1.cid_num = mcc404.cid_num 
      AND DupCTE1.longitude = mcc404.longitude 
      AND DupCTE1.latitude = mcc404.latitude
);
WITH DupCTE2 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY mcc, mnc, cid_num, longitude, latitude ORDER BY created) AS row_num
    FROM mcc405
)
DELETE FROM mcc405
WHERE EXISTS (
    SELECT 1
    FROM DupCTE2
    WHERE DupCTE2.row_num > 1 
      AND DupCTE2.mcc = mcc405.mcc 
      AND DupCTE2.mnc = mcc405.mnc 
      AND DupCTE2.cid_num = mcc405.cid_num 
      AND DupCTE2.longitude = mcc405.longitude 
      AND DupCTE2.latitude = mcc405.latitude
);
WITH DupCTE3 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY mcc, mnc, operator, circle ORDER BY mcc) AS row_num
    FROM mcc_mnc_list
)
DELETE FROM mcc_mnc_list
WHERE EXISTS (
    SELECT 1
    FROM DupCTE3
    WHERE DupCTE3.row_num > 1 
      AND DupCTE3.mcc = mcc_mnc_list.mcc 
      AND DupCTE3.mnc = mcc_mnc_list.mnc 
      AND DupCTE3.operator = mcc_mnc_list.operator 
      AND DupCTE3.circle = mcc_mnc_list.circle 
);


WITH MCC_CTE AS (
    SELECT radio, mcc, mnc, cid_num as cid, longitude as `long`, latitude as lat, created, updated 
    FROM mcc404
    UNION
    SELECT radio, mcc, mnc, cid_num as cid, longitude as `long`, latitude as lat, created, updated 
    FROM mcc405
)
SELECT 
    case 
    when cte.radio = 'GSM' or cte.radio = 'CDMA' then '2G'
    when cte.radio = 'UMTS' then '3G'
    when cte.radio = 'LTE' then '4G'
    when cte.radio = 'NR' then '5G'
    end,
    cte.mcc, 
    cte.mnc, 
    cte.cid, 
    cte.`long`, 
    cte.lat, 
    cte.created, 
    cte.updated, 
    mml.operator, 
    mml.circle
FROM MCC_CTE cte
LEFT JOIN mcc_mnc_list mml 
    ON cte.mcc = mml.mcc AND cte.mnc = mml.mnc;

DESCRIBE mcc404;
DESCRIBE mcc405;
describe mcc_mnc_list;

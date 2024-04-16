SELECT * FROM Portfolio_project.nashvillehousing2;


-- Set SaleDate column into the standard date format -- 
SELECT SaleDate FROM Portfolio_project.nashvillehousing2

UPDATE Portfolio_project.nashvillehousing2
SET 
    SaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %e, %Y'), '%Y-%m-%d');

-- Populate NULL values in the PropertyAddress Column -- 
SELECT * FROM Portfolio_project.nashvillehousing2
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress) AS Address
FROM Portfolio_project.nashvillehousing2 a
JOIN Portfolio_project.nashvillehousing2 b ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


UPDATE Portfolio_project.nashvillehousing2 a
JOIN Portfolio_project.nashvillehousing b ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Breaking Address Into Individual Columns (Address, City, State) --
SELECT *
FROM Portfolio_project.nashvillehousing2

SELECT
	SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1) as PropertyAddress1,
    SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) as PropertyAddressCity
FROM Portfolio_project.nashvillehousing2;

ALTER TABLE nashvillehousing2
ADD COLUMN PropertyAddress1 VARCHAR(255),
ADD COLUMN PropertyAddressCity VARCHAR(255);

UPDATE nashvillehousing2
SET 
    PropertyAddress1 = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1),
    PropertyAddressCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1);
    
/*ALTER TABLE nashvillehousing
DROP COLUMN PropertyAddress;*/


-- Split OwnerAddress Into Address, City, and State Columns --
SELECT * FROM Portfolio_project.nashvillehousing2;


SELECT 
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerAddress1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS OwnerAddressCity,
    SUBSTRING_INDEX(OwnerAddress, ',', -1) AS OwnerAddressState
FROM Portfolio_project.nashvillehousing2;

ALTER TABLE nashvillehousing2
ADD COLUMN OwnerAddress1 VARCHAR(255)

UPDATE nashvillehousing2
SET 
    OwnerAddress1 = SUBSTRING_INDEX(OwnerAddress, ',', 1)
    

ALTER TABLE nashvillehousing2
ADD COLUMN OwnerAddressCity VARCHAR(255)
UPDATE nashvillehousing2
SET 
    OwnerAddressCity =  SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)

ALTER TABLE nashvillehousing2
ADD COLUMN OwnerAddressState VARCHAR(255)
UPDATE nashvillehousing2
SET 
    OwnerAddressState =  SUBSTRING_INDEX(OwnerAddress, ',', -1)


 -- Change 'Y' and 'N' to 'Yes' and 'No' in 'SoldasVacant' column --
 SELECT SoldasVacant 
 FROM Portfolio_project.nashvillehousing2

SELECT Distinct(SoldasVacant), Count(SoldasVacant)
 FROM Portfolio_project.nashvillehousing2
 GROUP BY SoldasVacant
 ORDER BY 2

-- case statement --
 
 SELECT SoldasVacant
 ,CASE
	WHEN SoldasVacant = "Y" THEN "Yes"
    WHEN SoldasVacant = "N" THEN "No"
    ELSE SoldasVacant
    END
 FROM Portfolio_project.nashvillehousing2
 
 UPDATE nashvillehousing2
 SET SoldasVacant = CASE
	WHEN SoldasVacant = "Y" THEN "Yes"
    WHEN SoldasVacant = "N" THEN "No"
    ELSE SoldasVacant
    END

-- REMOVE DUPLICATES --

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                        PropertyAddress,
                        SalePrice,
                        SaleDate,
                        LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM Portfolio_project.nashvillehousing2
)

DELETE FROM Portfolio_project.nashvillehousing2
WHERE UniqueID IN (
    SELECT UniqueID
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (
                PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
                ORDER BY UniqueID
            ) AS row_num
        FROM Portfolio_project.nashvillehousing2
    ) AS RowNumCTE
    WHERE row_num > 1
);

SELECT * FROM Portfolio_project.nashvillehousing2



-- Delete Unused Columns -

ALTER TABLE Portfolio_project.nashvillehousing2
DROP COLUMN
 OwnerAddress,
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress;

ALTER TABLE Portfolio_project.nashvillehousing2
DROP COLUMN
 OwnerAddress,
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress;





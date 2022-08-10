--Cleaning data

--Overview of data
SELECT *
FROM Project..Housing



SELECT SaleDate, CONVERT(date, SaleDate) as clean_date
FROM Project..Housing


Alter Table Housing
Add SaleDateClean date;

UPDATE Housing
SET SaleDateClean = CONVERT(date, SaleDate)


--Property Address

SELECT PropertyAddress
FROM Project..Housing

SELECT *
FROM Project..Housing
WHERE PropertyAddress IS NULL

SELECT *
FROM Project..Housing
Order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM Project..Housing a
JOIN Project..Housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Project..Housing a
JOIN Project..Housing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Taking Address out
SELECT PropertyAddress
FROM Project..Housing

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) as Street,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM Project..Housing


Alter Table Housing
Add Street Nvarchar(250)

UPDATE Housing
SET Street = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)

Alter Table Housing
Add City Nvarchar(250)

UPDATE Housing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))


SELECT OwnerAddress
FROM Project..Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)
FROM Project..Housing

Alter Table Housing
Add Owner_Street Nvarchar(250)

UPDATE Housing
SET Owner_Street = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)

Alter Table Housing
Add Owner_City Nvarchar(250)

UPDATE Housing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)

Alter Table Housing
Add Owner_State Nvarchar(250)

UPDATE Housing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)


SELECT  *
FROM Project..Housing

--Change Y & N to YES & NO
SELECT  DISTINCT SoldAsVacant, COUNT(SoldAsVacant) as counting
FROM Project..Housing
Group by SoldAsVacant


SELECT  SoldAsVacant, 
				CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
						   WHEN SoldAsVacant = 'N' THEN  'No'
						    Else SoldAsVacant END
FROM Project..Housing

Update Project..Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN  'Yes'
						   WHEN SoldAsVacant = 'N' THEN  'No'
						    Else SoldAsVacant END

SELECT  DISTINCT SoldAsVacant, COUNT(SoldAsVacant) as counting
FROM Project..Housing
Group by SoldAsVacant

--Remove Duplicates

WITH row_n as(
SELECT  *, 
			ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference 
			ORDER BY UniqueID) row_num
FROM Project..Housing
)
Select * from row_n
where row_num > 1
Order by row_n.ParcelID


WITH row_n as(
SELECT  *, 
			ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference 
			ORDER BY UniqueID) row_num
FROM Project..Housing
)
Delete from row_n
where row_num > 1


--Delete column


Alter TABLE Project..Housing
Drop Column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

SELECT *
FROM Project..Housing


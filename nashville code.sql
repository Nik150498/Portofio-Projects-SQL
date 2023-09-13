/* Cleaning data in SQL Queries */
Select * FROM project_2.dbo.Nashville;

/* Standardize the Date Format*/-----------------------------------------------------------------------------------------------
--Use of Convert Function

Select SaleDate , CONVERT(Date,SaleDate)as New_Date
from project_2.dbo.Nashville;

Update project_2.dbo.Nashville
SET SaleDate=CONVERT(Date,SaleDate);

Alter table Nashville
Alter Column SaleDate DATE;



/* Populate Property Address Data */-------------------------------------------------------------------------------------------
--Use of ISNULL function and Self Join
Select * FROM project_2.dbo.Nashville

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from project_2.dbo.Nashville a
 inner join project_2.dbo.Nashville b
on a.ParcelID=b.ParcelID
and
a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

Update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from  project_2.dbo.Nashville a
inner join project_2.dbo.Nashville b
on a.ParcelID=b.ParcelID
and
a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;


--Breaking out Address into Individual Columns (Address,City,State)-------------------------------------------------------------
-- use of Substring and CharIndex functions

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as address,
SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as address
from
project_2.dbo.Nashville



Alter Table project_2.dbo.Nashville
ADD propertysplitaddress varchar(255);

Update project_2.dbo.Nashville
SET propertysplitaddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1);


Alter table project_2.dbo.Nashville
add propertysplitcity varchar(255);

Update project_2.dbo.Nashville
SET propertysplitcity=SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress));


Select * FROM project_2.dbo.Nashville

--OTHER WAY---------------------------
--use of PARSENAME to extract the address

Select * FROM project_2.dbo.Nashville

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From project_2.dbo.Nashville

Alter Table project_2.dbo.Nashville
ADD ownersplitaddress varchar(255);

Update project_2.dbo.Nashville
SET ownersplitaddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3);


Alter table project_2.dbo.Nashville
add Ownersplitcity varchar(255);

Update project_2.dbo.Nashville
SET Ownersplitcity=PARSENAME(REPLACE(OwnerAddress,',','.'),2);

Alter table project_2.dbo.Nashville
add Ownersplitstate varchar(255);

Update project_2.dbo.Nashville
SET Ownersplitstate =PARSENAME(REPLACE(OwnerAddress,',','.'),1);

Select * FROM project_2.dbo.Nashville


---------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicates--
--Use of Row Number--

With RowCTE AS(Select *, Row_number() 
        over(
             PARTITION BY ParcelID,
						  PropertyAddress,
					      SalePrice,
						  SaleDate,
						  LegalReference
						  Order by UniqueID
						  ) Row_num
FROM project_2.dbo.Nashville)

/*select * from RowCTE
where Row_num>1
Order by PropertyAddress*/

Delete from RowCTE
where Row_num>1
Order by PropertyAddress



-------------------------------------------------------------------------------------------------------------------------------
--DELETE UNUSED COLOUMNS--
--Use of Alter table command --

Select * FROM project_2.dbo.Nashville



Alter table project_2.dbo.Nashville
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

Alter table project_2.dbo.Nashville
DROP COLUMN SaleDate
















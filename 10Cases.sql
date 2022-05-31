USE UncoverBionic

--1
SELECT s.StaffID, COUNT(p.PurchasedID) as TotalPurchase, v.VendorName
FROM Staff s inner join Purchase p
on s.StaffID = p.StaffID join
PurchaseDetail pd
on p.PurchasedID = pd.PurchasedID join 
Bionic b 
on pd.BionicID = b.BionicID join 
Vendor v 
on p.VendorID = v.VendorID WHERE v.VendorName LIKE ('% Tillman')
GROUP BY s.StaffID, v.VendorName
HAVING COUNT(p.PurchasedID) > 1;

--2
SELECT s.StaffID, s.StaffName, s.StaffSalary, SUM(sd.SoldQty) as TotalBionicSold
FROM Staff s inner join Sales sl 
on s.StaffID = sl.StaffID join 
SalesDetail sd 
on sl.SalesID = sd.SalesID WHERE s.StaffSalary >= 8000000 AND s.StaffSalary <= 10000000
GROUP BY s.StaffID, s.StaffName, s.StaffSalary
HAVING SUM(sd.SoldQty) > 10;

--3
SELECT sl.SalesID, c.CustomerName, c.CustomerGender, SUM(pd.PurchasedQty) as TotalQuantityPurchased, COUNT(pd.PurchasedBionic)
as TotalBionicPurchased, convert(varchar, sl.SoldDate, 107) as SalesDate
FROM Customer c inner join Sales sl 
on c.CustomerID = sl.CustomerID join 
Purchase p 
on sl.StaffID = p.StaffID join 
PurchaseDetail pd 
on p.PurchasedID = pd.PurchasedID WHERE c.CustomerGender LIKE 'Female'
GROUP BY c.CustomerID, c.CustomerName, c.CustomerGender, sl.SalesID, sl.SoldDate
HAVING SUM(pd.PurchasedQty) > 7;

--4
SELECT REPLACE(p.PurchasedID,'PU','PURCHASE ') as PurchasedID, count(pd.PurchasedID) as TotalPurchaseDetail,
MAX(b.BionicPrice) as HighestBionicPrice, bt.BionicTypeName
FROM Purchase p inner join PurchaseDetail pd 
on p.PurchasedID = pd.PurchasedID join 
Bionic b
on pd.BionicID = b.BionicID join 
BionicType bt 
on b.BionicTypeID = bt.BionicTypeID WHERE bt.BionicTypeName LIKE 'Hand'
GROUP BY p.PurchasedID, bt.BionicTypeName
HAVING count(pd.PurchasedID) > 1;

--5
SELECT s.StaffName, CONCAT('Rp. ',s.StaffSalary) as StaffSalary, s.StaffGender,
convert(varchar, p.PurchaseDate, 107) as PurchaseDate, v.VendorName
FROM Staff s inner join Purchase p 
on s.StaffID = p.StaffID join 
Vendor v 
on p.VendorID = v.VendorID 
WHERE s.StaffSalary > (SELECT AVG(StaffSalary) FROM Staff)
AND year(PurchaseDate) = 2020;

--6
SELECT sl.SalesID, s.StaffID, s.StaffName, s.StaffSalary, LEFT(s.StaffGender,1) as StaffGender, b.BionicName,
SUM(b.BionicPrice*sd.SoldQty)
as TotalSoldPrice, convert(varchar, sl.SoldDate, 106) as SalesDate
FROM Staff s inner join Sales sl 
on s.StaffID = sl.StaffID join 
SalesDetail sd 
on sl.SalesID = sd.SalesID join 
Bionic b 
on sd.BionicID = b.BionicID WHERE s.StaffSalary < 5000000
GROUP BY sl.SalesID, s.StaffID, s.StaffName, s.StaffSalary, s.StaffGender, b.BionicName, sl.SoldDate
HAVING SUM(b.BionicPrice*sd.SoldQty) > (SELECT AVG(BionicPrice) FROM Bionic);

--7
SELECT REPLACE(sl.SalesID,'SA','Sales ') as SalesID, convert(varchar, sl.SoldDate, 107) as SalesDate,
CONCAT(SUM(sd.SoldQty),' Pc(s)') as TotalQuantity, b.BionicName,
bt.BionicTypeName, bt.BionicTypeDurability
FROM Sales sl inner join SalesDetail sd 
on sl.SalesID = sd.SalesID join 
Bionic b 
on sd.BionicID = b.BionicID join 
BionicType bt 
on b.BionicTypeID = bt.BionicTypeID WHERE year(sl.SoldDate) > 2016
GROUP BY sl.SalesID, sl.SoldDate, b.BionicName, bt.BionicTypeName, bt.BionicTypeDurability
HAVING bt.BionicTypeDurability < (SELECT AVG(BionicTypeDurability) FROM BionicType);

--8
SELECT REPLACE(v.VendorID,'VE','Vendor ') as VendorID, CONCAT(SUM(pd.PurchasedQty),' Pc(s)') as TotalQuantity, b.BionicID,
bt.BionicTypeName, bt.BionicTypeDurability
FROM Vendor v inner join Purchase p 
on v.VendorID = p.VendorID join 
PurchaseDetail pd 
on p.PurchasedID = pd.PurchasedID join 
Bionic b 
on pd.BionicID = b.BionicID join 
BionicType bt 
on b.BionicTypeID = bt.BionicTypeID
GROUP BY v.VendorID, b.BionicID, bt.BionicTypeName, bt.BionicTypeDurability
HAVING bt.BionicTypeName LIKE 'Eye'
AND SUM(pd.PurchasedQty) >= (SELECT(MAX(BionicStock)) FROM Bionic)
ORDER BY TotalQuantity DESC;

--9
DROP VIEW IF EXISTS LoyalCustomer;
GO

CREATE VIEW LoyalCustomer AS
SELECT c.CustomerID, c.CustomerName, c.CustomerGender, COUNT(sl.SalesID) as TotalTransaction, 
CONCAT(SUM(sd.SoldQty),' Pc(S)') as TotalBionicBought 
FROM Customer c inner join Sales sl 
on c.CustomerID = sl.CustomerID join 
SalesDetail sd 
on sl.SalesID = sd.SalesID
GROUP BY c.CustomerID, c.CustomerName, c.CustomerGender
HAVING COUNT(sl.SalesID) > 1 AND SUM(sd.SoldQty) > 10;

GO

--10
DROP VIEW IF EXISTS StaffPurchaseRecap;
GO

CREATE VIEW StaffPurchaseRecap AS
SELECT s.StaffID, s.StaffName, s.StaffSalary, COUNT(p.PurchasedID) as TotalPurchaseFinished, SUM(pd.PurchasedQty) as 
TotalBionicPurchased
FROM Staff s inner join Purchase p 
on s.StaffID = p.StaffID join 
PurchaseDetail pd 
on p.PurchasedID = pd.PurchasedID WHERE year(p.PurchaseDate) > 2016
GROUP BY s.StaffID, s.StaffName, s.StaffSalary
HAVING COUNT(p.PurchasedID) > 1;

GO
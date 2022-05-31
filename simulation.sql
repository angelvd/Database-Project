USE UncoverBionic

INSERT INTO Customer VALUES 
('CU011', 'Luna', 089020001100, 'Kembang Street', 'Female', 'luna@gmail.com', '2002-08-24')
INSERT INTO Staff VALUES 
('ST011', 'Kezia', 081454545222, 'Hamster Street', 'Female', 'kezia@gmail.com', '2002-10-30', 5000000)
INSERT INTO Vendor VALUES 
('VE011', 'Seysa Jaya', 081234515, 'Anggur Street', 'seysa@gmail.com')
INSERT INTO BionicType VALUES 
('TY011', 'Hand', 90)
INSERT INTO Bionic VALUES 
('BI011', 'Violet', 20, 450000, '2021-11-06', 'TY011')
INSERT INTO Purchase VALUES 
('PU016', 'VE011', 'ST011', '2020-11-11')
INSERT INTO Sales VALUES 
('SA016', 'CU011', 'ST011', '2021-12-12')
INSERT INTO PurchaseDetail VALUES 
('PU016', 'BI001', 'Purple', 16)
INSERT INTO SalesDetail VALUES 
('SA016', 'BI001', 'Purple', 8)
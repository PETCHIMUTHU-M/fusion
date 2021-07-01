CREATE TABLE TASK8(LE_NAME VARCHAR2(100),BUSINESS_UNIT VARCHAR2(100),COMPANY_ID VARCHAR2(100),CUSTOMER_NAME VARCHAR2(100));

SELECT * FROM TASK8;

INSERT INTO TASK8 VALUES('LE1', 'BU1', '200400', 'C1');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200402', 'C2');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200403', 'C2');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200402', 'C1');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200403', 'C3');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200404', 'C3');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200405', 'C3');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200406', 'C4');
INSERT INTO TASK8 VALUES('LE1', 'BU1', '200407', 'C4');


SELECT TASK8.*, ROW_NUMBER() OVER (PARTITION BY CUSTOMER_NAME ORDER BY COMPANY_ID) AS REF FROM TASK8;


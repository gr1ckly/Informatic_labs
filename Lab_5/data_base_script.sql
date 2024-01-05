CREATE TABLE INITIAL_DATA(
  ID INT NOT NULL PRIMARY KEY,
  NAME VARCHAR(2) NOT NULL, 
  VALUE SMALLINT NOT NULL
);

INSERT INTO INITIAL_DATA (ID, NAME, VALUE)
VALUES (1, 'A', 3627), (2, 'C', 19936);

CREATE TABLE BIN_RESULT(
    ID INT NOT NULL PRIMARY KEY,
    X INT NOT NULL,
  B15 char(1) NOT NULL,
  B14 char(1) NOT NULL,
  B13 char(1) NOT NULL,
  B12 char(1) NOT NULL,
  BD1 VARCHAR(1) NOT NULL,
  B11 char(1) NOT NULL,
  B10 char(1) NOT NULL,
  B9 char(1) NOT NULL,
  B8 char(1) NOT NULL,
  BD2 VARCHAR(1) NOT NULL,
  B7 char(1) NOT NULL,
  B6 char(1) NOT NULL,
  B5 char(1) NOT NULL,
  B4 char(1) NOT NULL,
  BD3 VARCHAR(1) NOT NULL,
  B3 char(1) NOT NULL,
  B2 char(1) NOT NULL,
  B1 char(1) NOT NULL,
  B0 char(1) NOT NULL
);

CREATE OR REPLACE FUNCTION INSERT_BIN_X(num INT, val INT) RETURNS void AS $$
DECLARE
  b CHAR(16);
BEGIN
  b:=CAST(val::BIT(16) AS CHAR(16));
  INSERT INTO BIN_RESULT(ID, X, B15, B14, B13, B12, BD1, B11, B10, B9, B8, BD2, B7, B6, B5, B4, BD3, B3, B2, B1, B0)
    VALUES (NUM, VAL, substring(b from 1 for 1), substring(b from 2 for 1), substring(b from 3 for 1), substring(b from 4 for 1), '.', substring(b from 5 for 1), substring(b from 6 for 1), substring(b from 7 for 1), substring(b from 8 for 1), '.', substring(b from 9 for 1), substring(b from 10 for 1), substring(b from 11 for 1), substring(b from 12 for 1), '.',substring(b from 13 for 1), substring(b from 14 for 1), substring(b from 15 for 1), substring(b from 16 for 1));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION INSERT_BIN_RESULT() RETURNS void AS $$
DECLARE 
  VALUE_1 INT;
  VALUE_2 INT;
BEGIN
  SELECT VALUE INTO VALUE_1 FROM INITIAL_DATA
  WHERE ID=1;
  SELECT VALUE INTO VALUE_2 FROM INITIAL_DATA
  WHERE ID=2;
  PERFORM INSERT_BIN_X(1, VALUE_1);
  PERFORM INSERT_BIN_X(2, VALUE_2);
  PERFORM INSERT_BIN_X(3, value_1 + value_2);
  PERFORM INSERT_BIN_X(4, value_1 + value_2 + value_2);
  PERFORM INSERT_BIN_X(5, value_2 - value_1);
END;
$$ LANGUAGE plpgsql;

SELECT INSERT_BIN_RESULT();

CREATE OR REPLACE FUNCTION INSERT_BIN_RESULT_612() RETURNS void AS $$
DECLARE
  VALUE_1 INT;
  VALLUE_2 INT;
BEGIN
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=4;
  PERFORM INSERT_BIN_X(6, 65536 - VALUE_1);
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=1;
  PERFORM INSERT_BIN_X(7, VALUE_1*(-1));
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=2;
  PERFORM INSERT_BIN_X(8, VALUE_1*(-1));
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=3;
  PERFORM INSERT_BIN_X(9, VALUE_1*(-1));
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=4;
  PERFORM INSERT_BIN_X(10, VALUE_1*(-1));
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=5;
  PERFORM INSERT_BIN_X(11, VALUE_1*(-1));
  SELECT X INTO VALUE_1 FROM BIN_RESULT
  WHERE ID=6;
  PERFORM INSERT_BIN_X(12, VALUE_1*(-1));
END;
$$ LANGUAGE plpgsql;

SELECT INSERT_BIN_RESULT_612();

CREATE TABLE BIN_ADDITION(
  ID INT NOT NULL PRIMARY KEY,
  OPERATION VARCHAR(6) NOT NULL,
  C15 char(1) NOT NULL,
    C14 char(1) NOT NULL,
    C13 char(1) NOT NULL,
    C12 char(1) NOT NULL,
    CD1 VARCHAR(1) NOT NULL,
    C11 char(1) NOT NULL,
    C10 char(1) NOT NULL,
    C9 char(1) NOT NULL,
    C8 char(1) NOT NULL,
    CD2 VARCHAR(1) NOT NULL,
    C7 char(1) NOT NULL,
    C6 char(1) NOT NULL,
    C5 char(1) NOT NULL,
    C4 char(1) NOT NULL,
    CD3 VARCHAR(1) NOT NULL,
    C3 char(1) NOT NULL,
    C2 char(1) NOT NULL,
    C1 char(1) NOT NULL,
    C0 char(1) NOT NULL,
  CPAZSO CHAR(6) NOT NULL,
  BIN_RES INT NOT NULL,
  RES INT NOT NULL,
  DESCRIPTION VARCHAR(500) NOT NULL
);

CREATE OR REPLACE FUNCTION INSERT_ADD(VALUE_1 INT, VALUE_2 INT, IND INT, OPER VARCHAR) RETURNS void AS $$
DECLARE
  BIN_RES CHAR(17);
  RES INT;
  COUNTER INT;
  BIN CHAR(15);
  FLAGS CHAR(6);
  DESCRIPT VARCHAR (500);
BEGIN 
  FLAGS = '000000';
  DESCRIPT := '';
  RES := 0;
  COUNTER := 15;
  BIN_RES := CAST((VALUE_1 + VALUE_2)::BIT(17) AS CHAR(17));
  IF SUBSTRING(BIN_RES FROM 2 FOR 1)='1'THEN 
  	BIN := CAST((CAST(CAST(SUBSTRING(BIN_RES FROM 3 FOR 15) AS BIT(15)) AS INTEGER) - 1)::BIT(15) AS CHAR(15));
	BIN := REPLACE(BIN, '0', '4');
	BIN := REPLACE(BIN, '1', '0');
	BIN := REPLACE(BIN, '4', '1');
	WHILE COUNTER>=1 LOOP
		RES := RES + CAST(SUBSTRING(BIN FROM COUNTER FOR 1) AS INTEGER) * POWER(2, 15 - COUNTER);
		COUNTER := COUNTER - 1;
	END LOOP;
	RES := RES * (-1);
  ELSE
  	RES := CAST(CAST(SUBSTRING(BIN_RES FROM 3 FOR 15) AS BIT(15)) AS INTEGER);
  END IF;
  IF RES = VALUE_1 + VALUE_2 THEN
    IF (VALUE_1 < 0 AND VALUE_2 > 0) OR (VALUE_1 > 0 AND VALUE_2 < 0) THEN
		DESCRIPT := DESCRIPT || 'При сложении положительного и отрицательного числа ';
		IF (VALUE_1 + VALUE_2)>0 THEN
			DESCRIPT := DESCRIPT || 'получено положительное число. ';
		ELSIF (VALUE_1 + VALUE_2)< 0 THEN
			DESCRIPT := DESCRIPT || 'получено отрицательное число. ';
		ELSIF (VALUE_1 + VALUE_2)=0 THEN
			DESCRIPT := DESCRIPT || 'получен ноль. ';
		END IF;
	ELSIF VALUE_1 > 0 AND VALUE_2 >0 THEN
		DESCRIPT := DESCRIPT || 'При сложении двух положительных чисел получено положительное число. ';
	ELSIF VALUE_1 <0 AND VALUE_2 <0 THEN 
		DESCRIPT := DESCRIPT || 'При сложении двух отрицательных чисел получено отрицательное число. ';
	ELSIF VALUE_1 = 0 OR VALUE_2 = 0 THEN
		DESCRIPT := DESCRIPT || 'При сложении с нулем получено исходное число. ';
	END IF;
  	IF SUBSTRING(BIN_RES FROM 1 FOR 1)='1' THEN
		DESCRIPT := DESCRIPT || 'Перенос из старшего разряда не учитывается. ';
	END IF;
	DESCRIPT := DESCRIPT || 'Результат корректный, совпадает с суммой десятичных эквивалентов.';
  ELSE 
  	IF VALUE_1 < 0 AND VALUE_2 < 0 THEN
		IF RES > 0 THEN 
			DESCRIPT := DESCRIPT || 'При сложении двух отрицательных чисел получено положительное число. ПЕРЕПОЛНЕНИЕ';
			FLAGS := SUBSTRING(FLAGS FROM 1 FOR 5) || '1';
		ELSIF RES > 0 THEN 
			DESCRIPT := DESCRIPT || 'При сложении двух отрицательных чисел получено большее отрицательное число. ПЕРЕПОЛНЕНИЕ';
			FLAGS := SUBSTRING(FLAGS FROM 1 FOR 5) || '1';
		ELSIF RES=0 THEN
			DESCRIPT := DESCRIPT || 'При сложении двух отрицательных чисел получен ноль. ПЕРЕПОЛНЕНИЕ';
			FLAGS := SUBSTRING(FLAGS FROM 1 FOR 5) || '1';
		END IF;
	ELSIF VALUE_1 > 0 AND VALUE_2 > 0 THEN
		IF RES > 0 THEN 
			DESCRIPT := DESCRIPT || 'При сложении двух положительных чисел получено меньшее положительное число. ПЕРЕПОЛНЕНИЕ';
			FLAGS := SUBSTRING(FLAGS FROM 1 FOR 5) || '1';
		ELSIF RES < 0 THEN 
			DESCRIPT := DESCRIPT || 'При сложении двух положительных чисел получено отрицательное число. ПЕРЕПОЛНЕНИЕ';
			FLAGS := SUBSTRING(FLAGS FROM 1 FOR 5) || '1';
		ELSIF RES=0 THEN
			DESCRIPT := DESCRIPT || 'При сложении двух положительных чисел получен ноль. ПЕРЕПОЛНЕНИЕ';
			FLAGS := SUBSTRING(FLAGS FROM 1 FOR 5) || '1';
		END IF; 
	ELSIF (VALUE_1 > 0 AND VALUE_2 < 0) OR (VALUE_1 > 0 AND VALUE_2 < 0) THEN
		IF RES > 0 THEN 
			DESCRIPT := DESCRIPT || 'При сложении положительного и МЕНЬШЕГО ПО МОДУЛЮ отрицательного числа получено положительное число. Некорректный результат.';
		ELSIF RES < 0 THEN 
			DESCRIPT := DESCRIPT || 'При сложении положительного и МЕНЬШЕГО ПО МОДУЛЮ отрицательного числа получено положительное число. Некорректный результат.';
		END IF;
	END IF;
  END IF;
  IF (CAST(VALUE_1::BIT(16) AS INTEGER) + CAST(VALUE_2::BIT(16) AS INTEGER))>65536 THEN
  	FLAGS := '1' || SUBSTRING(FLAGS FROM 2 FOR 5);
  END IF;
  IF RES = 0 THEN 
  	FLAGS := SUBSTRING(FLAGS FROM 1 FOR 3) || '1' || SUBSTRING(FLAGS FROM 5 FOR 2);
  END IF;
  FLAGS := SUBSTRING(FLAGS FROM 1 FOR 4) || SUBSTRING(BIN_RES FROM 2 FOR 1) || SUBSTRING(FLAGS FROM 6 FOR 1);
  IF SUBSTRING(BIN_RES FROM 17 FOR 1) = '0' THEN
  	FLAGS := SUBSTRING(FLAGS FROM 1 FOR 1) || '1' || SUBSTRING(FLAGS FROM 3 FOR 4);
  END IF;
  IF (CAST(VALUE_1::BIT(16) AS INTEGER)%16 + CAST(VALUE_2::BIT(16) AS INTEGER) % 16) > 15 THEN 
  	FLAGS := SUBSTRING(FLAGS FROM 1 FOR 2) || '1' || SUBSTRING(FLAGS FROM 4 FOR 3);
  END IF;
  INSERT INTO BIN_ADDITION (ID, OPERATION, C15, C14, C13, C12, CD1, C11, C10, C9, C8, CD2, C7, C6, C5, C4, CD3, C3, C2, C1, C0, CPAZSO, BIN_RES, RES, DESCRIPTION)
  VALUES(IND, OPER, substring(bin_res from 2 for 1),substring(bin_res from 3 for 1),
  substring(bin_res from 4 for 1), substring(bin_res from 5 for 1), '.', substring(bin_res from 6 for 1), substring(bin_res from 7 for 1),
  substring(bin_res from 8 for 1), substring(bin_res from 9 for 1), '.', substring(bin_res from 10 for 1), substring(bin_res from 11 for 1),
  substring(bin_res from 12 for 1), substring(bin_res from 13 for 1), '.', substring(bin_res from 14 for 1), substring(bin_res from 15 for 1),
  substring(bin_res from 16 for 1), substring(bin_res from 17 for 1), FLAGS, RES, VALUE_1 + VALUE_2, DESCRIPT);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION INSERT_FULL_ADD() RETURNS VOID AS $$
DECLARE 
	VALUE_1 INT;
	VALUE_2 INT;
BEGIN
	SELECT X INTO VALUE_1 FROM BIN_RESULT 
	WHERE ID =1;
	SELECT X INTO VALUE_2 FROM BIN_RESULT
	WHERE ID = 2;
	PERFORM INSERT_ADD(VALUE_1, VALUE_2, 1, 'B1+B2');
	SELECT X INTO VALUE_1 FROM BIN_RESULT
	WHERE ID = 3;
	PERFORM INSERT_ADD(VALUE_2, VALUE_1, 2, 'B2+B3');
	SELECT X INTO VALUE_1 FROM BIN_RESULT
	WHERE ID=7;
	PERFORM INSERT_ADD(VALUE_2, VALUE_1, 3,  'B2+B7');
	SELECT X INTO VALUE_2 FROM BIN_RESULT 
	WHERE ID=8;
	PERFORM INSERT_ADD(VALUE_1, VALUE_2, 4, 'B7+B8');
	SELECT X INTO VALUE_1 FROM BIN_RESULT 
	WHERE ID=9;
	PERFORM INSERT_ADD(VALUE_1, VALUE_2, 5, 'B8+B9');
	SELECT X INTO VALUE_1 FROM BIN_RESULT
	WHERE ID=1;
	PERFORM INSERT_ADD(VALUE_1, VALUE_2, 6, 'B1+B8');
	SELECT X INTO VALUE_1 FROM BIN_RESULT
	WHERE ID=3;
	SELECT X INTO VALUE_2 FROM BIN_RESULT
	WHERE ID=11;
	PERFORM INSERT_ADD(VALUE_1, VALUE_2, 7, 'B3+B11');
END;
$$ LANGUAGE plpgsql;

SELECT INSERT_FULL_ADD();





CREATE OR REPLACE FUNCTION INSERT_FULL_LAB() RETURNS trigger AS $$
DECLARE 
BEGIN
	DROP TABLE BIN_RESULT, BIN_ADDITION;
	CREATE TABLE BIN_RESULT(
    ID INT NOT NULL PRIMARY KEY,
    X INT NOT NULL,
  B15 char(1) NOT NULL,
  B14 char(1) NOT NULL,
  B13 char(1) NOT NULL,
  B12 char(1) NOT NULL,
  BD1 VARCHAR(1) NOT NULL,
  B11 char(1) NOT NULL,
  B10 char(1) NOT NULL,
  B9 char(1) NOT NULL,
  B8 char(1) NOT NULL,
  BD2 VARCHAR(1) NOT NULL,
  B7 char(1) NOT NULL,
  B6 char(1) NOT NULL,
  B5 char(1) NOT NULL,
  B4 char(1) NOT NULL,
  BD3 VARCHAR(1) NOT NULL,
  B3 char(1) NOT NULL,
  B2 char(1) NOT NULL,
  B1 char(1) NOT NULL,
  B0 char(1) NOT NULL
);
	PERFORM INSERT_BIN_RESULT();
	PERFORM INSERT_BIN_RESULT_612();
	CREATE TABLE BIN_ADDITION(
  ID INT NOT NULL PRIMARY KEY,
  OPERATION VARCHAR(6) NOT NULL,
  C15 char(1) NOT NULL,
    C14 char(1) NOT NULL,
    C13 char(1) NOT NULL,
    C12 char(1) NOT NULL,
    CD1 VARCHAR(1) NOT NULL,
    C11 char(1) NOT NULL,
    C10 char(1) NOT NULL,
    C9 char(1) NOT NULL,
    C8 char(1) NOT NULL,
    CD2 VARCHAR(1) NOT NULL,
    C7 char(1) NOT NULL,
    C6 char(1) NOT NULL,
    C5 char(1) NOT NULL,
    C4 char(1) NOT NULL,
    CD3 VARCHAR(1) NOT NULL,
    C3 char(1) NOT NULL,
    C2 char(1) NOT NULL,
    C1 char(1) NOT NULL,
    C0 char(1) NOT NULL,
  CPAZSO CHAR(6) NOT NULL,
  BIN_RES INT NOT NULL,
  RES INT NOT NULL,
  DESCRIPTION VARCHAR(500) NOT NULL
);
	PERFORM INSERT_FULL_ADD();
	return null;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE TRIGGER check_update
    AFTER UPDATE OF VALUE ON INITIAL_DATA
    FOR EACH STATEMENT
    EXECUTE FUNCTION INSERT_FULL_LAB();
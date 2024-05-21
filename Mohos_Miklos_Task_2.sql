-- Táblák eldobása
-- DROP TABLE PN_CIM;
-- DROP TABLE PN_TORZS;
-- DROP TABLE T_TELEPULES;

/*A táblák létrehozása közben abba a problémába futottam bele, hogy
  a null() típusról nem találtam sok információt, csak annyit, hogy 
  hasonlóan mint a VARCHAR2 változó hosszúságú karakterlánc, ezért
  azzal helyettesítettem a táblákban.
*/
-- Táblák létrehozása
CREATE TABLE T_TELEPULES (
  T_TELEPULES_ID VARCHAR2(5) PRIMARY KEY,
  NEV VARCHAR2(200),
  IRSZ VARCHAR2(10),
  T_MEGYE_ID NUMBER(5)
);
CREATE TABLE PN_TORZS (
  PN_TORZS_ID VARCHAR2(9) PRIMARY KEY,
  T_TELEPULES_ID VARCHAR2(5),
  UTCA VARCHAR2(200),
  HAZSZAM VARCHAR2(50),
  FOREIGN KEY (T_TELEPULES_ID ) REFERENCES t_telepules(T_TELEPULES_ID )
);
CREATE TABLE PN_CIM (
  PN_CÍM_ID VARCHAR2(9) PRIMARY KEY,
  PN_TORZS_ID VARCHAR2(9),
  TIPUS CHAR(1),
  T_TELEPULES_ID VARCHAR2(5),
  UTCA VARCHAR2(200),
  HAZSZAM VARCHAR2(50),
FOREIGN KEY (T_TELEPULES_ID ) REFERENCES t_telepules(T_TELEPULES_ID ),
FOREIGN KEY (PN_TORZS_ID ) REFERENCES pn_torzs(PN_TORZS_ID )
);
 
--Táblák feltöltése
INSERT INTO t_telepules VALUES ('BP1', 'Budapest', '1103', 1111);
INSERT INTO t_telepules VALUES ('GY1', 'Gyõr', '9024', 2222);
INSERT INTO t_telepules VALUES ('GY2', 'Gyõr', '9027', 2222);
INSERT INTO pn_torzs VALUES ('BP_KO', 'BP1', 'Kõér utca', '3/a');
INSERT INTO pn_torzs VALUES ('GY_VA', 'GY1', 'Vasvári Pál utca', '1/b');
INSERT INTO pn_torzs VALUES ('GY_HÛ', 'GY2', 'Hûtõház utca', '2-4');
INSERT INTO pn_cim VALUES ('13579', 'BP_KO', 'S', 'BP1', NULL, NULL);
INSERT INTO pn_cim VALUES ('02468', 'GY_VA', 'S', 'GY1', 'Nem székhely Gyõr1 utca', '15');
INSERT INTO pn_cim VALUES ('12345', 'GY_HÛ', 'S', 'GY2', 'Nem székhely Gyõr2 utca', '20');


CREATE OR REPLACE PACKAGE PK_PARTNER AS
  FUNCTION GET_PN_SZALL_CIM(p_pn_torzs_id VARCHAR2)
  RETURN VARCHAR2;
END PK_PARTNER;
/
CREATE OR REPLACE PACKAGE BODY PK_PARTNER AS
  FUNCTION GET_PN_SZALL_CIM(p_pn_torzs_id VARCHAR2)
  RETURN VARCHAR2 AS
    v_szá_város VARCHAR2(200);
    v_szá_utca VARCHAR2(200);
    v_szá_irsz VARCHAR2(200);
    v_szá_házszám VARCHAR2(200);
    v_város VARCHAR2(200);
    v_utca VARCHAR2(200);
    v_irsz VARCHAR2(200);
    v_házszám VARCHAR2(200);
  BEGIN
    SELECT c.utca, s.nev, s.irsz, c.hazszam, t.utca, s.nev, s.irsz, t.hazszam
    INTO v_szá_utca, v_szá_város, v_szá_irsz, v_szá_házszám, v_utca, v_város, v_irsz, v_házszám
    FROM PN_TORZS t
    LEFT JOIN PN_CIM c ON t.PN_TORZS_ID = c.PN_TORZS_ID AND c.TIPUS = 'S'
    LEFT JOIN t_telepules s ON t.t_telepules_id = s.t_telepules_id
    WHERE c.PN_TORZS_ID = p_pn_torzs_id
    AND ROWNUM = 1;
    IF v_szá_utca IS NULL THEN
      RETURN v_irsz || ' ' || v_város || ' ' || v_utca || ' ' || v_házszám;
    ELSE
      RETURN v_szá_irsz || ' ' || v_szá_város || ' ' || v_szá_utca || ' ' || v_szá_házszám;
    END IF;
  END GET_PN_SZALL_CIM;
END PK_PARTNER;
/
-- A teszthez tartozó üres címmel rendelkezõ ID --> BP_KO
-- A lekérdezésnél az általam megadott PN_TORZS_ID-k: BP_KO, GY_VA, GY_HÛ
SELECT PK_PARTNER.GET_PN_SZALL_CIM('BP_KO') AS SZALL_CIM FROM DUAL;
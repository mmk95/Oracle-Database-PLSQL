-- T�bl�k eldob�sa
-- DROP TABLE PN_CIM;
-- DROP TABLE PN_TORZS;
-- DROP TABLE T_TELEPULES;

/*A t�bl�k l�trehoz�sa k�zben abba a probl�m�ba futottam bele, hogy
  a null() t�pusr�l nem tal�ltam sok inform�ci�t, csak annyit, hogy 
  hasonl�an mint a VARCHAR2 v�ltoz� hossz�s�g� karakterl�nc, ez�rt
  azzal helyettes�tettem a t�bl�kban.
*/
-- T�bl�k l�trehoz�sa
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
  PN_C�M_ID VARCHAR2(9) PRIMARY KEY,
  PN_TORZS_ID VARCHAR2(9),
  TIPUS CHAR(1),
  T_TELEPULES_ID VARCHAR2(5),
  UTCA VARCHAR2(200),
  HAZSZAM VARCHAR2(50),
FOREIGN KEY (T_TELEPULES_ID ) REFERENCES t_telepules(T_TELEPULES_ID ),
FOREIGN KEY (PN_TORZS_ID ) REFERENCES pn_torzs(PN_TORZS_ID )
);
 
--T�bl�k felt�lt�se
INSERT INTO t_telepules VALUES ('BP1', 'Budapest', '1103', 1111);
INSERT INTO t_telepules VALUES ('GY1', 'Gy�r', '9024', 2222);
INSERT INTO t_telepules VALUES ('GY2', 'Gy�r', '9027', 2222);
INSERT INTO pn_torzs VALUES ('BP_KO', 'BP1', 'K��r utca', '3/a');
INSERT INTO pn_torzs VALUES ('GY_VA', 'GY1', 'Vasv�ri P�l utca', '1/b');
INSERT INTO pn_torzs VALUES ('GY_H�', 'GY2', 'H�t�h�z utca', '2-4');
INSERT INTO pn_cim VALUES ('13579', 'BP_KO', 'S', 'BP1', NULL, NULL);
INSERT INTO pn_cim VALUES ('02468', 'GY_VA', 'S', 'GY1', 'Nem sz�khely Gy�r1 utca', '15');
INSERT INTO pn_cim VALUES ('12345', 'GY_H�', 'S', 'GY2', 'Nem sz�khely Gy�r2 utca', '20');


CREATE OR REPLACE PACKAGE PK_PARTNER AS
  FUNCTION GET_PN_SZALL_CIM(p_pn_torzs_id VARCHAR2)
  RETURN VARCHAR2;
END PK_PARTNER;
/
CREATE OR REPLACE PACKAGE BODY PK_PARTNER AS
  FUNCTION GET_PN_SZALL_CIM(p_pn_torzs_id VARCHAR2)
  RETURN VARCHAR2 AS
    v_sz�_v�ros VARCHAR2(200);
    v_sz�_utca VARCHAR2(200);
    v_sz�_irsz VARCHAR2(200);
    v_sz�_h�zsz�m VARCHAR2(200);
    v_v�ros VARCHAR2(200);
    v_utca VARCHAR2(200);
    v_irsz VARCHAR2(200);
    v_h�zsz�m VARCHAR2(200);
  BEGIN
    SELECT c.utca, s.nev, s.irsz, c.hazszam, t.utca, s.nev, s.irsz, t.hazszam
    INTO v_sz�_utca, v_sz�_v�ros, v_sz�_irsz, v_sz�_h�zsz�m, v_utca, v_v�ros, v_irsz, v_h�zsz�m
    FROM PN_TORZS t
    LEFT JOIN PN_CIM c ON t.PN_TORZS_ID = c.PN_TORZS_ID AND c.TIPUS = 'S'
    LEFT JOIN t_telepules s ON t.t_telepules_id = s.t_telepules_id
    WHERE c.PN_TORZS_ID = p_pn_torzs_id
    AND ROWNUM = 1;
    IF v_sz�_utca IS NULL THEN
      RETURN v_irsz || ' ' || v_v�ros || ' ' || v_utca || ' ' || v_h�zsz�m;
    ELSE
      RETURN v_sz�_irsz || ' ' || v_sz�_v�ros || ' ' || v_sz�_utca || ' ' || v_sz�_h�zsz�m;
    END IF;
  END GET_PN_SZALL_CIM;
END PK_PARTNER;
/
-- A teszthez tartoz� �res c�mmel rendelkez� ID --> BP_KO
-- A lek�rdez�sn�l az �ltalam megadott PN_TORZS_ID-k: BP_KO, GY_VA, GY_H�
SELECT PK_PARTNER.GET_PN_SZALL_CIM('BP_KO') AS SZALL_CIM FROM DUAL;
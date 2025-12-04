--A.1
CREATE OR REPLACE TYPE gift_items_n AS TABLE OF VARCHAR2(255);
/
--A.2
CREATE TABLE gift_catalog (
    GIFT_ID NUMBER PRIMARY KEY,
    MIN_PURCHASE NUMBER,
    GIFTS GIFT_ITEMS_N
)
--A.3
NESTED TABLE gifts STORE AS gift_items_st;
/
--A.4
INSERT INTO gift_catalog VALUES (
    1, 100, gift_items_n('Stickers', 'Pen Set')
);
INSERT INTO gift_catalog VALUES (
    2, 1500, gift_items_n('Lawn Mower', 'Fertilizer', 'Rake')
);
INSERT INTO gift_catalog VALUES (
    3, 2500, gift_items_n('Tent', 'Butane Stove', 'Bottle')
);
/
--select * from GIFT_CATALOG;
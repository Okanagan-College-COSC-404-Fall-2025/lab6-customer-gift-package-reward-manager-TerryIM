--C.1
CREATE OR REPLACE PACKAGE customer_manager AS
    FUNCTION get_total_purchase(p_customer_id NUMBER) RETURN NUMBER;
    PROCEDURE assign_gifts_to_all;
    PROCEDURE display_five; --D.1
END customer_manager;
/
CREATE OR REPLACE PACKAGE BODY customer_manager AS

    FUNCTION choose_gift_package(p_total_purchase NUMBER) RETURN NUMBER AS
        v_min_purchase gift_catalog.min_purchase%TYPE;
        v_gift_id gift_catalog.gift_id%TYPE;
    BEGIN
        SELECT MAX(min_purchase)
        INTO v_min_purchase
        FROM gift_catalog
        WHERE min_purchase <= p_total_purchase;

        CASE
            WHEN v_min_purchase IS NULL THEN
                return NULL;
            ELSE
                SELECT gift_id
                INTO v_gift_id
                FROM gift_catalog
                WHERE min_purchase = v_min_purchase;
                RETURN v_gift_id;
        END CASE;
    END choose_gift_package;

    FUNCTION get_total_purchase(p_customer_id NUMBER) RETURN NUMBER AS
        v_total NUMBER :=0;
    BEGIN
        SELECT SUM(oi.unit_price * oi.quantity)
        INTO v_total
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.ORDER_ID
        WHERE o.customer_id = p_customer_id;

        RETURN NVL(v_total, 0);

    END get_total_purchase;

    PROCEDURE assign_gifts_to_all AS
        CURSOR c_customers IS
            SELECT customer_id, email_address
            FROM customers;
        v_total NUMBER;
        v_gift NUMBER;
    BEGIN
        FOR rec IN c_customers LOOP
            v_total := get_total_purchase(rec.customer_id);
            v_gift:= choose_gift_package(v_total);

            IF v_gift IS NOT NULL THEN
                INSERT INTO customer_rewards (customer_email, gift_id, reward_date)
                VALUES (rec.email_address, v_gift, SYSDATE);
            END IF;
        end loop;
    END assign_gifts_to_all;

    --D.1
    PROCEDURE display_five AS
        CURSOR c_rewards IS
            SELECT cr.customer_email,
                gc.gift_id,
                gc.min_purchase,
                cr.reward_date
            FROM customer_rewards cr
            JOIN gift_catalog gc ON cr.gift_id = gc.gift_id
            ORDER BY cr.reward_date
            FETCH FIRST 5 ROWS ONLY;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMAIL | GIFT_ID | MIN_PURCHASE | REWARD_DATE');
        DBMS_OUTPUT.PUT_LINE('_______________________________________________________');

        FOR rec IN c_rewards LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.customer_email || ' | ' ||
                rec.gift_id || ' | ' ||
                rec.min_purchase || ' | ' ||
                TO_CHAR(rec.reward_date, 'YYYY-MM-DD')
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('_______________________________________________________');
    END display_five;

END customer_manager;
/


BEGIN
    CUSTOMER_MANAGER.display_five;
END;
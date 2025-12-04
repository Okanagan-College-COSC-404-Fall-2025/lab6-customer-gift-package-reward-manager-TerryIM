--B.1
CREATE TABLE customer_rewards(
    reward_ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_email VARCHAR2(255) NOT NULL,
    gift_ID NUMBER NOT NULL,
    reward_date DATE DEFAULT SYSDATE,
    
    CONSTRAINT FK_REWARD_GIFT
        FOREIGN KEY (gift_ID) REFERENCES gift_catalog(gift_ID),

    CONSTRAINT FK_REWARD_CUSTOMER
        FOREIGN KEY (customer_email) REFERENCES customers(email_address)
);
/
commit;
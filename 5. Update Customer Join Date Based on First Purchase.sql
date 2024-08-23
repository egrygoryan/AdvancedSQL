/*Create a stored procedure that updates the join_date of each customer to the date of their first 
purchase if it is earlier than the current join_date. This ensures that the join_date reflects the true 
start of the customer relationship.
Potential procedure name: sp_update_customer_join_date
Parameters for procedure: NONE
Example of usage:
-- This updates the join dates of customers to reflect the date of their first purchase if earlier than 
-- the current join date.
CALL sp_update_customer_join_date();*/


CREATE OR REPLACE PROCEDURE sp_update_customer_join_date()
LANGUAGE plpgsql
AS $$
BEGIN
	WITH customers_first_purchase AS(
		SELECT 
			customer_id, 
			MIN(sale_date) AS first_purchase_date
		FROM sales
		GROUP BY customer_id
		ORDER BY customer_id
	)
	UPDATE customers c
	SET join_date = cfp.first_purchase_date
	FROM customers_first_purchase cfp
	WHERE c.customer_id = cfp.customer_id 
		AND c.join_date > cfp.first_purchase_date;
	COMMIT;
END;
$$;


CALL sp_update_customer_join_date();


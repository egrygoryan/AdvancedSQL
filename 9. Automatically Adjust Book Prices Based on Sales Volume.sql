--Create a trigger that automatically increases the price of a book by 10% if the total quantity sold 
--reaches a certain threshold (e.g., 5 units). This helps to dynamically adjust pricing based on the 
--popularity of the book.
--Potential trigger name: tr_adjust_book_price
--Trigger Timing: AFTER INSERT
--Trigger Event: ON table Sales

--added column to track whether the discount has been applied or not
ALTER TABLE Books ADD COLUMN discount_applied BOOLEAN DEFAULT FALSE;

CREATE OR REPLACE FUNCTION adjust_book_price()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
DECLARE
    total_sold INTEGER;
	is_discount BOOLEAN;
BEGIN
  	SELECT SUM(quantity)
    INTO total_sold
    FROM sales
    WHERE book_id = NEW.book_id
	GROUP BY book_id
	HAVING SUM(quantity) > 5;

	
	SELECT discount_applied 
	INTO is_discount
	FROM Books 
	WHERE book_id = NEW.book_id;
	
    
    IF is_discount IS FALSE
		THEN
        
        UPDATE Books
        SET price = price * 1.10,
            discount_applied = TRUE  -- prevent to apply several discounts for already discounted book
        WHERE book_id = NEW.book_id;
    END IF;
	
	RETURN NEW;
END;
$$;


CREATE OR REPLACE TRIGGER tr_adjust_book_price
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE FUNCTION adjust_book_price();

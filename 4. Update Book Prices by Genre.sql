/*Create a stored procedure that increases the prices of all books in a specific genre by a specified 
percentage. The procedure should also output the number of books that were updated. Use RAISE 
for it.
Potential procedure name: sp_bulk_update_book_prices_by_genre
Parameters for procedure: 
p_genre_id INTEGER
p_percentage_change NUMERIC(5, 2)
Example of usage:
-- This increases the prices of all books in genre ID 3 by 5% and output the updated number
CALL sp_bulk_update_book_prices_by_genre(3, 5.00);*/


CREATE OR REPLACE PROCEDURE sp_bulk_update_book_prices_by_genre(
	p_genre_id INTEGER,
	p_percentage_change NUMERIC(5, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    num_books_updated INTEGER;
BEGIN
	update books
	set price = price * (1 + p_percentage_change / 100)
	where genre_id = p_genre_id;
	
	GET DIAGNOSTICS num_books_updated = ROW_COUNT;
	RAISE INFO 'Number of books updated: %', num_books_updated;
	COMMIT;
END;
$$;

CALL sp_bulk_update_book_prices_by_genre(17, 10.00);
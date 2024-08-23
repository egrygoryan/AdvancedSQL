/*Create a function that returns the top N best-selling books in a specific genre, based on total sales 
revenue.
Potential function name: fn_get_top_n_books_by_genre
Parameters:
p_genre_id INTEGER
p_top_n INTEGER
Example of usage:
-- This would return the top 5 best-selling books in genre with ID 1
SELECT * FROM fn_get_top_n_books_by_genre(1, 5);*/


CREATE OR REPLACE FUNCTION fn_get_top_n_books_by_genre(
	p_genre_id INTEGER,
	p_top_n INTEGER)
RETURNS TABLE (
    book_id INTEGER,
    title VARCHAR(255),
    total_revenue NUMERIC(10, 2)
) 
LANGUAGE plpgsql
AS
$$
BEGIN 
RETURN QUERY
    SELECT
        b.book_id,
        b.title,
        SUM(s.quantity * b.price) AS total_revenue
    FROM
        books b
    JOIN
        sales s ON b.book_id = s.book_id
    WHERE
        b.genre_id = p_genre_id
    GROUP BY
        b.book_id, b.title
    ORDER BY
        total_revenue DESC
    LIMIT
        p_top_n;
END;
$$;


SELECT * from fn_get_top_n_books_by_genre(1,5);
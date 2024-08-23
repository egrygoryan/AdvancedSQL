--Create a query that ranks books by their price within each genre using the RANK() window 
--function. The goal is to assign a rank to each book based on its price, with the highest-priced book 
--in each genre receiving a rank of 1.

SELECT *,
RANK() OVER(PARTITION BY genre_id ORDER BY price DESC)
FROM books

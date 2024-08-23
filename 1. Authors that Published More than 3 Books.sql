--Create a CTE that calculates the total number of books each author has published. Then, create 
--SELECT query that will use this CTE, and retrieve a list of authors who have published more than 3 
--books, including the number of books they have published.


WITH books_count AS (
	SELECT author_id, COUNT(*) AS total_books
	FROM books
	GROUP BY author_id
	ORDER BY author_id
)
SELECT bc.author_id, a.name, total_books
FROM books_count bc
INNER JOIN authors a on bc.author_id = a.author_id
WHERE total_books > 3
/*Create a CTE that identifies books whose titles contain the word "The" in any letter case using 
regular expressions. For example, books with titles like "The Great Gatsby," "The Shining", "The Old 
Man and the Sea", or "To the Lighthouse" will meet this criterion. Then, create the SELECT that will
this CTE, and retrieve the book titles, corresponding authors, genre, and publication date.*/


WITH contains_the AS (
	SELECT *
	FROM books
	WHERE title ~* '\mThe\M'
)
SELECT ct.title, a.name, g.genre_name, ct.published_date  
FROM contains_the as ct
JOIN authors a on a.author_id = ct.author_id
JOIN genres g on g.genre_id = ct.genre_id